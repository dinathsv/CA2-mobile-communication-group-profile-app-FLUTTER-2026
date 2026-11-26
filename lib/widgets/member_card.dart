import 'package:flutter/material.dart';

import '../models/member_profile.dart';
import 'member_photo.dart';

class MemberCard extends StatelessWidget {
  const MemberCard({
    super.key,
    required this.profile,
    required this.minimumHeight,
    required this.onTap,
  });

  final MemberProfile profile;
  final double minimumHeight;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final dark = theme.brightness == Brightness.dark;

    return Semantics(
      button: true,
      enabled: onTap != null,
      label: 'View profile for ${profile.fullName}',
      onTap: onTap,
      child: ExcludeSemantics(
        child: Material(
          color: colors.surfaceContainerHighest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: BorderSide(color: colors.outlineVariant),
          ),
          elevation: 8,
          shadowColor: dark
              ? Colors.black54
              : colors.primary.withValues(alpha: 0.2),
          surfaceTintColor: Colors.transparent,
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              Positioned.fill(child: MemberPhoto(profile: profile)),
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: minimumHeight),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildCaption(theme.textTheme, colors),
                ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onTap,
                    hoverColor: const Color(0x0fffffff),
                    focusColor: const Color(0x28ffffff),
                    highlightColor: const Color(0x16ffffff),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCaption(TextTheme textTheme, ColorScheme colors) {
    const fadeHeight = 76.0;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: -fadeHeight,
          bottom: 0,
          child: LayoutBuilder(
            builder: (context, constraints) => DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0, fadeHeight / constraints.maxHeight, 1],
                  colors: const [
                    Colors.transparent,
                    Color(0xc40c0a14),
                    Color(0xfa0c0a14),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 6, 20, 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.designName,
                        style: textTheme.labelMedium?.copyWith(
                          color: const Color(0xffe5dbff),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.8,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        profile.fullName,
                        style: textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: (constraints.maxWidth / 8).clamp(
                            20.0,
                            28.0,
                          ),
                          height: 1.07,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.primary,
                  shape: BoxShape.circle,
                ),
                child: SizedBox.square(
                  dimension: 46,
                  child: Icon(
                    Icons.arrow_outward_rounded,
                    color: colors.onPrimary,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
