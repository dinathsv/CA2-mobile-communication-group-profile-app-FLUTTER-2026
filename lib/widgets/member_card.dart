import 'package:flutter/material.dart';

import '../models/member_profile.dart';
import 'member_photo.dart';

class MemberCard extends StatefulWidget {
  const MemberCard({super.key, required this.profile, required this.onTap});

  final MemberProfile profile;
  final VoidCallback onTap;

  @override
  State<MemberCard> createState() => _MemberCardState();
}

class _MemberCardState extends State<MemberCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profile = widget.profile;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(17),
      side: BorderSide(color: theme.colorScheme.outlineVariant),
    );

    return AnimatedScale(
      scale: _pressed && !reduceMotion ? 0.977 : 1,
      duration: reduceMotion
          ? Duration.zero
          : const Duration(milliseconds: 135),
      curve: Curves.easeOut,
      child: Semantics(
        button: true,
        label: '${profile.fullName}, member ${profile.number}',
        onTap: widget.onTap,
        child: ExcludeSemantics(
          child: Material(
            color: theme.colorScheme.surfaceContainerLow,
            clipBehavior: Clip.antiAlias,
            shape: shape,
            child: InkWell(
              onTap: widget.onTap,
              onHighlightChanged: reduceMotion
                  ? null
                  : (value) => setState(() => _pressed = value),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: MemberPhoto(profile: profile)),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(13, 12, 13, 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.fullName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Member ${profile.number}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
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
