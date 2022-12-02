// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Agent {
  String displayName;
  String email;
  String imageUrl;
  String phoneNumber;
  String uid;
  String? role;
  bool supervisor;
  bool isAvailable;
  Agent({
    this.role,
    required this.displayName,
    required this.email,
    required this.imageUrl,
    required this.phoneNumber,
    required this.uid,
    required this.supervisor,
    required this.isAvailable,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'displayName': displayName,
      'email': email,
      'imageUrl': imageUrl,
      'phoneNumber': phoneNumber,
      'uid': uid,
      'role': role,
      "supervisor": supervisor,
      'isAvailable': isAvailable
    };
  }

  factory Agent.fromMap(Map<String, dynamic> map) {
    return Agent(
        isAvailable: (map['isAvailable'] as bool?) ?? false,
        supervisor: map['supervisor'] as bool? ?? false,
        displayName: map['displayName'] as String? ?? "",
        email: map['email'] as String? ?? "",
        imageUrl: map['imageUrl'] as String? ?? "",
        phoneNumber: map['phoneNumber'] as String? ?? "",
        uid: map['uid'] as String? ?? "",
        role: map['role'] as String?);
  }

  String toJson() => json.encode(toMap());

  factory Agent.fromJson(String source) =>
      Agent.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Agent(displayName: $displayName, email: $email, imageUrl: $imageUrl, phoneNumber: $phoneNumber, uid: $uid)';
  }

  @override
  bool operator ==(covariant Agent other) {
    if (identical(this, other)) return true;

    return other.displayName == displayName &&
        other.email == email &&
        other.imageUrl == imageUrl &&
        other.phoneNumber == phoneNumber &&
        other.uid == uid;
  }

  @override
  int get hashCode {
    return displayName.hashCode ^
        email.hashCode ^
        imageUrl.hashCode ^
        phoneNumber.hashCode ^
        uid.hashCode;
  }
}
