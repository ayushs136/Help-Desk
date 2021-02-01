import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
import 'package:helpdesk_shift/models/contact.dart';
import 'package:helpdesk_shift/models/helper.dart';
import 'package:helpdesk_shift/models/message.dart';

class ChatMethods {
  final String CHAT_COLLECTION = "chats";
  final String CONTACT_COLLECTION = "contacts";
  final String USER_COLLECTION = "userData";

  Future<void> addMessageToDb(
      Message message, Helper sender, Helper reciever) async {
    var map = message.toMap();

    await FirebaseFirestore.instance
        .collection(CHAT_COLLECTION)
        .doc(message.senderId)
        .collection(message.receiverId)
        .add(map);
    addToContacts(senderId: message.senderId, receiverId: message.receiverId);

    return await FirebaseFirestore.instance
        .collection(CHAT_COLLECTION)
        .doc(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }

  DocumentReference getContactDocument({String of, String forContact}) {
    return FirebaseFirestore.instance
        .collection(USER_COLLECTION)
        .doc(of)
        .collection(CONTACT_COLLECTION)
        .doc(forContact);
  }

  addToContacts({String senderId = '', String receiverId = ''}) async {
    Timestamp currentTime = Timestamp.now();
    await addToSendersContact(senderId, receiverId, currentTime);
    await addToReceiverContact(senderId, receiverId, currentTime);
  }

  Future<void> addToSendersContact(
    String senderId,
    String receiverId,
    currentTime,
  ) async {
    DocumentSnapshot senderSnapshot =
        await getContactDocument(of: senderId, forContact: receiverId).get();
    if (!senderSnapshot.exists) {
      //does not exits

      Contact receiverContact = Contact(uid: receiverId, addedOn: currentTime);

      var receiverMap = receiverContact.toMap(receiverContact);

      getContactDocument(of: senderId, forContact: receiverId).set(receiverMap);
    }
  }

  Future<void> addToReceiverContact(
    String senderId,
    String receiverId,
    currentTime,
  ) async {
    DocumentSnapshot senderSnapshot =
        await getContactDocument(of: receiverId, forContact: senderId).get();
    if (!senderSnapshot.exists) {
      //does not exits

      Contact senderContact = Contact(uid: senderId, addedOn: currentTime);

      var senderMap = senderContact.toMap(senderContact);

      getContactDocument(of: receiverId, forContact: senderId)
          .setData(senderMap);
    }
  }

  Stream<QuerySnapshot> fetchContact({String userId = ''}) =>
      FirebaseFirestore.instance
          .collection(USER_COLLECTION)
          .doc(userId)
          .collection(CONTACT_COLLECTION)
          .snapshots();

  Stream<QuerySnapshot> fetchLastMessageBetween(
          {String senderId, String receiverId}) =>
      FirebaseFirestore.instance
          .collection(CHAT_COLLECTION)
          .doc(senderId)
          .collection(receiverId)
          .orderBy('timestamp')
          .snapshots();
}
