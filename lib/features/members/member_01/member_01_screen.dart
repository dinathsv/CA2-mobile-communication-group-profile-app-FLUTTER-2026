import 'package:flutter/material.dart';

import '../../../models/member_profile.dart';
import '../../../widgets/member_photo.dart';

final member01Profile = MemberProfile(
  id: 'member_01',
  fullName: 'Placeholder Member 01',
  studentId: 'Student ID pending',
  address: 'Address pending',
  email: 'Email pending',
  photoAsset: 'assets/members/member_01/portrait.png',
  qualifications: const ['Qualifications pending'],
  softSkills: const ['Soft skills pending'],
  specialTalents: const ['Special talents pending'],
  designName: 'MONO',
);

class Member01Screen extends StatelessWidget {
  const Member01Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = member01Profile;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('Member ${profile.number}')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: AspectRatio(
                      aspectRatio: 4 / 5,
                      child: MemberPhoto(profile: profile),
                    ),
                  ),
                  const SizedBox(height: 23),
                  Text(
                    profile.designName,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      letterSpacing: 1.6,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Semantics(
                    header: true,
                    child: Text(
                      profile.fullName,
                      style: theme.textTheme.headlineLarge,
                    ),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    'Profile in progress',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
