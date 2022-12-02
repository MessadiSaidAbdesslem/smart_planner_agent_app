import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Residence {
  String? id;
  String image;
  String name;
  String address;
  String phoneNumber;
  List<String> chambres;
  List<String> uid;

  Residence({
    this.id,
    required this.uid,
    required this.image,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.chambres,
  });

  Map<String, dynamic> toMapFirebase() {
    return <String, dynamic>{
      "address": address,
      'imageUrl': image,
      "name": name,
      "phone": phoneNumber,
      "uid": uid,
    };
  }

  Map<String, dynamic> toMapFirebaseUpdate() {
    return <String, dynamic>{
      "address": address,
      'imageUrl': image,
      "name": name,
      "phone": phoneNumber,
    };
  }

  List<String> uidsToStringList(dynamic input) {
    return List<String>.from(input as List<dynamic>)
        .map((x) => x as String)
        .toList();
  }

  factory Residence.fromMapFirebase(Map<String, dynamic> map) {
    List<String> chambresValue = [];
    if (map['chambres'] != null) {
      chambresValue = (map['chambres'] as List<dynamic>).map((e) {
        return (e as DocumentReference<Map<String, dynamic>>).id;
      }).toList();
    }

    return Residence(
      uid: List<String>.from(map["uid"] as List<dynamic>)
          .map((x) => x as String)
          .toList(),
      image: map['imageUrl'],
      name: map['name'],
      address: map['address'],
      phoneNumber: map['phone'],
      chambres: chambresValue,
    );
  }

  String toJsonFireBase() => json.encode(toMapFirebase());

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'image': image,
      'name': name,
      'address': address,
      'phoneNumber': phoneNumber,
      'chambres': chambres,
      "uid": uid,
    };
  }

  factory Residence.fromMap(Map<String, dynamic> map) {
    return Residence(
        uid: List<String>.from((map['uid'] as List<String>)),
        image: map['image'] as String,
        name: map['name'] as String,
        address: map['address'] as String,
        phoneNumber: map['phoneNumber'] as String,
        chambres: List<String>.from(map['chambres'] as List<dynamic>)
            .map((e) => e)
            .toList());
  }

  String toJson() => json.encode(toMap());

  factory Residence.fromJson(String source) =>
      Residence.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Residence(image: $image, name: $name, address: $address, phoneNumber: $phoneNumber, chambres: $chambres)';
  }

  @override
  bool operator ==(covariant Residence other) {
    if (identical(this, other)) return true;

    return other.image == image &&
        other.name == name &&
        other.address == address &&
        other.phoneNumber == phoneNumber &&
        listEquals(other.chambres, chambres);
  }
}
