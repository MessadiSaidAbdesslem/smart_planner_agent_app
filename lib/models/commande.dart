// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/foundation.dart';

class Commande {
  LinkedHashMap<String, bool> cleanedRooms;
  LinkedHashMap<String, bool> controllerRooms;
  List<String> teams;
  LinkedHashMap<String, bool?> roomsAvailable;

  String date;
  List<String> requestedRooms;
  List<String> residence;
  String? id;
  Commande(
      {required this.cleanedRooms,
      required this.controllerRooms,
      required this.date,
      required this.requestedRooms,
      required this.residence,
      required this.teams,
      required this.roomsAvailable,
      this.id});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cleanedRooms': cleanedRooms,
      'controllerRooms': controllerRooms,
      'date': date,
      'requestedRooms': requestedRooms,
      'residence': residence,
      "teams": teams,
      "roomsAvailable": roomsAvailable
    };
  }

  factory Commande.fromMap(Map<String, dynamic> map) {
    return Commande(
      cleanedRooms: LinkedHashMap<String, bool>.from(
          (map['cleanedRooms'] as LinkedHashMap<String, dynamic>)),
      controllerRooms: LinkedHashMap<String, bool>.from(
          (map['controllerRooms'] as LinkedHashMap<String, dynamic>)),
      roomsAvailable: map['roomsAvailable'] != null
          ? LinkedHashMap<String, bool?>.from(
              (map['roomsAvailable'] as LinkedHashMap<String, dynamic>))
          : LinkedHashMap<String, bool?>(),
      date: map['date'] as String,
      requestedRooms:
          List<String>.from((map['requestedRooms'] as List<dynamic>)),
      teams: List<String>.from((map['teams'] as List<dynamic>)),
      residence: List<String>.from((map['residence'] as List<dynamic>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory Commande.fromJson(String source) =>
      Commande.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Commande(cleanedRooms: $cleanedRooms, controllerRooms: $controllerRooms, date: $date, requestedRooms: $requestedRooms, residence: $residence)';
  }

  @override
  bool operator ==(covariant Commande other) {
    if (identical(this, other)) return true;

    return mapEquals(other.cleanedRooms, cleanedRooms) &&
        mapEquals(other.controllerRooms, controllerRooms) &&
        other.date == date &&
        listEquals(other.requestedRooms, requestedRooms) &&
        other.residence == residence;
  }

  @override
  int get hashCode {
    return cleanedRooms.hashCode ^
        controllerRooms.hashCode ^
        date.hashCode ^
        requestedRooms.hashCode ^
        residence.hashCode;
  }
}
