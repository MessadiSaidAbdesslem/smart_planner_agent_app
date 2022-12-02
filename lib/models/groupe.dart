// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/foundation.dart';

class Groupe {
  String id;
  List<String> chambers;
  List<String> members;
  String date;
  String idResidence;
  LinkedHashMap<String, dynamic> chambersState;

  static const menageOK = "menageOK";
  static const retour = "Retour";
  static const controlOK = "controlOK";

  Groupe(
      {required this.id,
      required this.chambers,
      required this.members,
      required this.date,
      required this.idResidence,
      required this.chambersState});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chambers': chambers,
      'members': members,
      'date': date,
      'idResidence': idResidence,
      'id': id
    };
  }

  factory Groupe.fromMap(Map<String, dynamic> map) {
    return Groupe(
        id: map['id'],
        chambers: List<String>.from((map['chambers'] as List<dynamic>)),
        members: List<String>.from((map['members'] as List<dynamic>)),
        date: map['date'] as String,
        idResidence: map['idResidence'] as String,
        chambersState: map['chambersState'] == null
            ? LinkedHashMap()
            : (map['chambersState'] as LinkedHashMap<String, dynamic>));
  }

  String toJson() => json.encode(toMap());

  factory Groupe.fromJson(String source) =>
      Groupe.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Groupe(chambers: $chambers, members: $members, date: $date, idResidence: $idResidence)';
  }

  @override
  bool operator ==(covariant Groupe other) {
    if (identical(this, other)) return true;

    return listEquals(other.chambers, chambers) &&
        listEquals(other.members, members) &&
        other.date == date &&
        other.idResidence == idResidence;
  }

  @override
  int get hashCode {
    return chambers.hashCode ^
        members.hashCode ^
        date.hashCode ^
        idResidence.hashCode;
  }
}
