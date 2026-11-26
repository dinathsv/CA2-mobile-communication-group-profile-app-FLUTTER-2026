import 'package:flutter/widgets.dart';

import '../features/members/member_01/member_01_screen.dart';
import '../features/members/member_02/member_02_screen.dart';
import '../features/members/member_03/member_03_screen.dart';
import '../features/members/member_04/member_04_screen.dart';
import '../features/members/member_05/member_05_screen.dart';
import '../features/members/member_06/member_06_screen.dart';
import '../features/members/member_07/member_07_screen.dart';
import '../features/members/member_08/member_08_screen.dart';
import '../features/members/member_09/member_09_screen.dart';
import '../models/member_profile.dart';

class MemberDirectoryEntry {
  const MemberDirectoryEntry({required this.profile, required this.builder});

  final MemberProfile profile;
  final WidgetBuilder builder;
}

abstract final class MemberRegistry {
  static final List<MemberDirectoryEntry> entries = List.unmodifiable([
    MemberDirectoryEntry(
      profile: member01Profile,
      builder: (_) => const Member01Screen(),
    ),
    MemberDirectoryEntry(
      profile: member02Profile,
      builder: (_) => const Member02Screen(),
    ),
    MemberDirectoryEntry(
      profile: member03Profile,
      builder: (_) => const Member03Screen(),
    ),
    MemberDirectoryEntry(
      profile: member04Profile,
      builder: (_) => const Member04Screen(),
    ),
    MemberDirectoryEntry(
      profile: member05Profile,
      builder: (_) => const Member05Screen(),
    ),
    MemberDirectoryEntry(
      profile: member06Profile,
      builder: (_) => const Member06Screen(),
    ),
    MemberDirectoryEntry(
      profile: member07Profile,
      builder: (_) => const Member07Screen(),
    ),
    MemberDirectoryEntry(
      profile: member08Profile,
      builder: (_) => const Member08Screen(),
    ),
    MemberDirectoryEntry(
      profile: member09Profile,
      builder: (_) => const Member09Screen(),
    ),
  ]);

  static List<MemberDirectoryEntry> search(String query) {
    final name = query.trim().toLowerCase();
    if (name.isEmpty) return entries;
    return entries
        .where((entry) => entry.profile.fullName.toLowerCase().contains(name))
        .toList(growable: false);
  }
}
