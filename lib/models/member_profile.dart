import 'package:flutter/foundation.dart';

@immutable
class MemberProfile {
  MemberProfile({
    required this.id,
    required this.fullName,
    required this.studentId,
    required this.address,
    required this.email,
    required this.photoAsset,
    required List<String> qualifications,
    required List<String> softSkills,
    required List<String> specialTalents,
    required this.designName,
  }) : qualifications = List.unmodifiable(qualifications),
       softSkills = List.unmodifiable(softSkills),
       specialTalents = List.unmodifiable(specialTalents);

  final String id;
  final String fullName;
  final String studentId;
  final String address;
  final String email;
  final String photoAsset;
  final List<String> qualifications;
  final List<String> softSkills;
  final List<String> specialTalents;
  final String designName;

  String get number => id.split('_').last;
}
