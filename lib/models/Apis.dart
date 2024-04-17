import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chatting_app/models/chat_user.dart';
import 'package:chatting_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';

class Api {
  static late ChatUser me;
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static User get user => auth.currentUser!;
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  static Future<void> getFirebaseMessageToken() async {
    await messaging.requestPermission();
    await messaging.getToken().then((value) {
      if (value != null) {
        me.pushToken = value;
      }
    });
  }

  static Future<void> SelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        await getFirebaseMessageToken();
        Api.UpdateActiveStatus(true);
        log('My Data: ${user.data()}');
      } else {
        {
          await createUser().then((value) => SelfInfo());
        }
      }
    });
  }

  static Future<void> sendPushNotification(
      ChatUser chatUser, String msg) async {
    try {
      final body = {
        "to": chatUser.pushToken,
        "notification": {
          "title": me.name,
          "body": msg,
          "android_channel_id": "chats"
        },
      };

      var res = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'key=AAAAkjY2Xw4:APA91bH0gurdM9Tx1wzC4-Z7bUE2GtZCYEgsJlJfqVk5gkB8FLgY_x5bKlTA9CpN8bFrlTvS9AEmlAtzqh8XAqympB21VZ4_UZ7LzlkwztvG7clZVC0S4e5p51BFZXPj-S5ERdSBXnMk'
          },
          body: jsonEncode(body));
      log('Response status: ${res.statusCode}');
      log('Response body: ${res.body}');
    } catch (e) {
      log('\nsendPushNotificationE: $e');
    }
  }

  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  static Future<bool> AddChatUser(String email) async {
    final val = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    if (val.docs.isNotEmpty && val.docs.first.id != user.uid) {
      firestore
          .collection('users')
          .doc(user.uid)
          .firestore
          .collection('my_user')
          .doc(val.docs.first.id)
          .set({});
      return true;
    } else {
      return false;
    }
  }

  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatuser = ChatUser(
        image: user.photoURL.toString(),
        about: "Hey! I'm Using a Chat",
        name: user.displayName.toString(),
        createdAt: time,
        isOnline: false,
        id: user.uid,
        lastActive: time,
        email: user.email.toString(),
        pushToken: '');

    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatuser.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUserId() {
    return firestore
        .collection('users')
        .doc(user.uid)
        .collection('my_user')
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(
      List<String> userIds) {
    return firestore
        .collection('users')
        .where('id', whereIn: userIds)
        .snapshots();
  }

  static Future<void> SendFirstMessage(
      ChatUser chatUser, String msg, Type type) async {
    await firestore
        .collection('users')
        .doc(chatUser.id)
        .collection('my_user')
        .doc(user.uid)
        .set({}).then((value) => SendMessage(chatUser, msg, type));
  }

  static Future<void> UpdateInfo() async {
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'name': me.name, 'about': me.about});
  }

  static Future<void> updateProfile(File file) async {
    final ext = file.path.split('.').last;
    log('Extension: $ext');
    final ref = storage.ref().child('profile_images/ ${user.uid}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'images/ $ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });
    me.image = await ref.getDownloadURL();
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'image': me.image});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUsersInfo(
      ChatUser chatUser) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  static Future<void> UpdateActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': me.pushToken
    });
  }
  // Api related Chat Messages

  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/ messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static Future<void> SendMessage(
      ChatUser chatUser, String msg, Type type) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final Messages message = Messages(
        toID: chatUser.id,
        msg: msg,
        read: '',
        type: type,
        fromID: user.uid,
        sent: time);

    final ref = firestore
        .collection('chats/${getConversationID(chatUser.id)}/ messages/');
    await ref.doc(time).set(message.toJson()).then((value) =>
        sendPushNotification(chatUser, type == Type.text ? msg : 'Photo'));
  }

  static Future<void> updateMessageReadStatus(Messages message) async {
    firestore
        .collection('chats/${getConversationID(message.fromID)}/ messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> LastMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/ messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  static Future<void> SendImageChat(ChatUser chatUser, File file) async {
    final ext = file.path.split('.').last;
    final ref = storage.ref().child(
        'Images/${getConversationID(chatUser.id)}/ ${DateTime.now().millisecondsSinceEpoch}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'images/ $ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });
    final ImageURL = await ref.getDownloadURL();
    await SendMessage(chatUser, ImageURL, Type.image);
  }

  static Future<void> deleteMessage(Messages message) async {
    await firestore
        .collection('chats/${getConversationID(message.toID)}/ messages/')
        .doc(message.sent)
        .delete();
    if (message.type == Type.image)
      await storage.refFromURL(message.msg).delete();
  }
}
