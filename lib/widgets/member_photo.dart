import 'package:flutter/material.dart';

import '../models/member_profile.dart';

class MemberPhoto extends StatelessWidget {
  const MemberPhoto({
    super.key,
    required this.profile,
    this.hero = true,
    this.fit = BoxFit.cover,
  });

  final MemberProfile profile;
  final bool hero;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final photo = Image.asset(
      profile.photoAsset,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      semanticLabel: 'Portrait of ${profile.fullName}',
      errorBuilder: (context, error, stackTrace) => ColoredBox(
        color: colors.surfaceContainerHighest,
        child: Center(
          child: Icon(
            Icons.person_outline_rounded,
            color: colors.onSurfaceVariant,
            size: 36,
            semanticLabel: 'Portrait unavailable',
          ),
        ),
      ),
    );

    if (!hero || MediaQuery.disableAnimationsOf(context)) return photo;
    return Hero(tag: 'member-${profile.id}', child: photo);
  }
}
