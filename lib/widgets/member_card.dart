import 'package:flutter/material.dart';

import '../models/member_profile.dart';
import 'member_photo.dart';

class MemberCard extends StatefulWidget {
  const MemberCard({super.key, required this.profile, required this.onTap});

  final MemberProfile profile;
  final Future<void> Function() onTap;

  static double captionHeight(TextScaler scale) =>
      27 + 3 * scale.scale(16) + (4 / 3) * scale.scale(12);

  @override
  State<MemberCard> createState() => _MemberCardState();
}

class _MemberCardState extends State<MemberCard> {
  Offset _tilt = Offset.zero;
  bool _pressed = false;
  bool _opening = false;

  void _updateTilt(Offset position) {
    final size = context.size;
    if (_opening || size == null || size.isEmpty) return;

    setState(() {
      _tilt = Offset(
        (2 * position.dx / size.width - 1).clamp(-1.0, 1.0),
        (2 * position.dy / size.height - 1).clamp(-1.0, 1.0),
      );
    });
  }

  Future<void> _openProfile() async {
    if (_opening) return;

    setState(() {
      _opening = true;
      _pressed = false;
      _tilt = Offset.zero;
    });

    // The portrait needs an axis-aligned source and destination for the Hero.
    if (!MediaQuery.disableAnimationsOf(context)) {
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted) return;
    }

    try {
      await widget.onTap();
    } finally {
      if (mounted) setState(() => _opening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final dark = theme.brightness == Brightness.dark;
    final profile = widget.profile;
    final animate = !MediaQuery.disableAnimationsOf(context) && !_opening;
    final duration = animate
        ? const Duration(milliseconds: 150)
        : Duration.zero;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: BorderSide(color: colors.outlineVariant),
    );

    return MouseRegion(
      onHover: animate ? (event) => _updateTilt(event.localPosition) : null,
      onExit: (_) => setState(() => _tilt = Offset.zero),
      child: TweenAnimationBuilder<Offset>(
        tween: Tween(end: animate ? _tilt : Offset.zero),
        duration: duration,
        curve: Curves.easeOutCubic,
        builder: (context, tilt, child) => Transform(
          alignment: Alignment.center,
          transformHitTests: false,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0016)
            ..rotateX(animate ? -tilt.dy * 0.11 : 0)
            ..rotateY(animate ? tilt.dx * 0.11 : 0),
          child: child,
        ),
        child: AnimatedScale(
          scale: _pressed && animate ? 0.974 : 1,
          duration: duration,
          curve: Curves.easeOutCubic,
          child: Semantics(
            button: true,
            label:
                '${profile.fullName}, member ${profile.number}, ${profile.designName}',
            onTap: _openProfile,
            child: ExcludeSemantics(
              child: Material(
                color: colors.surfaceContainerLow,
                shape: shape,
                elevation: 4,
                shadowColor: dark
                    ? Colors.black54
                    : colors.primary.withValues(alpha: 0.24),
                surfaceTintColor: Colors.transparent,
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: _openProfile,
                  onHighlightChanged: animate
                      ? (value) => setState(() => _pressed = value)
                      : null,
                  child: _MemberCardBody(profile: profile),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MemberCardBody extends StatelessWidget {
  const _MemberCardBody({required this.profile});

  final MemberProfile profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final dark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(7, 7, 7, 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: DecoratedBox(
                position: DecorationPosition.foreground,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colors.primary.withValues(alpha: dark ? 0.24 : 0.09),
                      colors.surfaceContainerHighest.withValues(
                        alpha: dark ? 0.30 : 0.09,
                      ),
                      (dark ? colors.surface : colors.primary).withValues(
                        alpha: dark ? 0.42 : 0.14,
                      ),
                    ],
                  ),
                  border: Border.all(
                    color: colors.primary.withValues(alpha: 0.16),
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: MemberPhoto(profile: profile),
              ),
            ),
          ),
        ),
        Container(
          constraints: BoxConstraints(
            minHeight: MemberCard.captionHeight(
              MediaQuery.textScalerOf(context),
            ),
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.fromLTRB(13, 11, 13, 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.fullName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${profile.number} · ${profile.designName}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                        letterSpacing: 0.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.arrow_outward_rounded,
                size: 17,
                color: colors.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
