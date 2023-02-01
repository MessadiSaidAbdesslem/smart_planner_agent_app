// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/foundation.dart';

class Commande {
  LinkedHashMap<String, bool?> roomsAvailable;
  List<String> priorityRooms;
  bool created;
  LinkedHashMap<String, dynamic> addedRooms;
  LinkedHashMap<String, dynamic> deletedRooms;

  String date;
  List<String> requestedRooms;
  List<String> residence;
  String? id;
  Commande(
      {required this.date,
      required this.requestedRooms,
      required this.residence,
      required this.roomsAvailable,
      required this.priorityRooms,
      required this.created,
      required this.addedRooms,
      required this.deletedRooms,
      this.id});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date,
      'requestedRooms': requestedRooms,
      'residence': residence,
      "roomsAvailable": roomsAvailable,
      "priorityRooms": priorityRooms,
      "created": created,
      "addedRooms": addedRooms,
      "deletedRooms": deletedRooms
    };
  }

  factory Commande.fromMap(Map<String, dynamic> map) {
    return Commande(
        roomsAvailable: map['roomsAvailable'] != null
            ? LinkedHashMap<String, bool?>.from(
                (map['roomsAvailable'] as LinkedHashMap<String, dynamic>))
            : LinkedHashMap<String, bool?>(),
        date: map['date'] as String,
        requestedRooms:
            List<String>.from((map['requestedRooms'] as List<dynamic>)),
        residence: List<String>.from((map['residence'] as List<dynamic>)),
        priorityRooms:
            List<String>.from((map['priorityRooms'] as List<dynamic>? ?? [])),
        created: map['created'] ?? true,
        addedRooms: LinkedHashMap<String, dynamic>.from(
            (map['addedRooms'] as LinkedHashMap<String, dynamic>?) ??
                LinkedHashMap()),
        deletedRooms: LinkedHashMap<String, dynamic>.from(
            (map['deletedRooms'] as LinkedHashMap<String, dynamic>?) ??
                LinkedHashMap()));
  }

  String toJson() => json.encode(toMap());

  factory Commande.fromJson(String source) =>
      Commande.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Commande(date: $date, requestedRooms: $requestedRooms, residence: $residence)';
  }

  @override
  bool operator ==(covariant Commande other) {
    if (identical(this, other)) return true;

    return other.date == date &&
        listEquals(other.requestedRooms, requestedRooms) &&
        other.residence == residence;
  }

  @override
  int get hashCode {
    return date.hashCode ^ requestedRooms.hashCode ^ residence.hashCode;
  }
}
