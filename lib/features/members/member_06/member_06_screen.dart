import 'package:flutter/material.dart';

import '../../../models/member_profile.dart';
import '../../../widgets/member_photo.dart';

final member06Profile = MemberProfile(
  id: 'member_06',
  fullName: 'Placeholder Member 06',
  studentId: 'Student ID pending',
  address: 'Address pending',
  email: 'Email pending',
  photoAsset: 'assets/members/member_06/portrait.png',
  qualifications: const ['Qualifications pending'],
  softSkills: const ['Soft skills pending'],
  specialTalents: const ['Special talents pending'],
  designName: 'VOGUE',
);

class Member06Screen extends StatelessWidget {
  const Member06Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = member06Profile;
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
