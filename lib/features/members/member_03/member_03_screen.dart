import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../models/member_profile.dart';
import '../../../widgets/member_photo.dart';

final member03Profile = MemberProfile(
  id: 'member_03',
  fullName: 'Placeholder Member 03',
  studentId: 'To be added',
  address: 'To be added',
  email: 'To be added',
  photoAsset: 'assets/members/member_03/portrait.png',
  qualifications: const [
    'Degree or diploma to be added',
    'Additional qualification to be added',
  ],
  softSkills: const ['Soft skill 1', 'Soft skill 2', 'Soft skill 3'],
  specialTalents: const ['Special talent 1', 'Special talent 2'],
  designName: 'AURA',
);

const _ink = Color(0xff111329);
const _primaryText = Color(0xfffaf7ff);
const _secondaryText = Color(0xffd2cae8);
const _lavender = Color(0xffded0ff);
const _glassBorder = Color(0x32e9e0ff);
const _glassTint = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0x33c3b3ff), Color(0x1686a8ef)],
);

class Member03Screen extends StatefulWidget {
  const Member03Screen({super.key});

  @override
  State<Member03Screen> createState() => _Member03ScreenState();
}

class _Member03ScreenState extends State<Member03Screen>
    with SingleTickerProviderStateMixin {
  late final _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 640),
  );
  late final _float = _entrance
      .drive(CurveTween(curve: Curves.easeOutCubic))
      .drive(Tween(begin: const Offset(0, 0.075), end: Offset.zero));
  late final _portraitScale = _entrance
      .drive(
        CurveTween(curve: const Interval(0.47, 1, curve: Curves.easeOutCubic)),
      )
      .drive(Tween(begin: 0.96, end: 1.0));
  late final _identityOpacity = _entrance.drive(
    CurveTween(curve: const Interval(0.12, 0.75, curve: Curves.easeOut)),
  );
  bool _isFavourite = false;
  bool _talentsExpanded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _entrance.value = 1;
    } else if (_entrance.isDismissed) {
      _entrance.forward();
    }
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = member03Profile;
    final interactionDuration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 220);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: _ink,
        body: Stack(
          fit: StackFit.expand,
          children: [
            const _AuraBackdrop(),
            SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _AuraHeader(
                        profile: profile,
                        isFavourite: _isFavourite,
                        duration: interactionDuration,
                        onFavourite: () =>
                            setState(() => _isFavourite = !_isFavourite),
                      ),
                      Expanded(
                        child: BackdropGroup(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 32),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _AuraIntro(
                                  profile: profile,
                                  offset: _float,
                                  photoScale: _portraitScale,
                                  titleOpacity: _identityOpacity,
                                ),
                                const SizedBox(height: 28),
                                _ContactPanel(profile: profile),
                                const SizedBox(height: 26),
                                const _SectionHeading(
                                  'Academic qualifications',
                                ),
                                const SizedBox(height: 10),
                                _Qualifications(
                                  qualifications: profile.qualifications,
                                ),
                                const SizedBox(height: 26),
                                _SkillsPanel(skills: profile.softSkills),
                                const SizedBox(height: 26),
                                _TalentsPanel(
                                  talents: profile.specialTalents,
                                  expanded: _talentsExpanded,
                                  duration: interactionDuration,
                                  onToggle: () => setState(
                                    () => _talentsExpanded = !_talentsExpanded,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuraHeader extends StatelessWidget {
  const _AuraHeader({
    required this.profile,
    required this.isFavourite,
    required this.duration,
    required this.onFavourite,
  });

  final MemberProfile profile;
  final bool isFavourite;
  final Duration duration;
  final VoidCallback onFavourite;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final controlStyle = IconButton.styleFrom(
      foregroundColor: _primaryText,
      backgroundColor: const Color(0x26c9b9ff),
      side: const BorderSide(color: _glassBorder),
      minimumSize: const Size.square(48),
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Row(
        children: [
          IconButton.filledTonal(
            style: controlStyle,
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            onPressed: () => Navigator.maybePop(context),
            icon: const BackButtonIcon(),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Text(
                    profile.designName,
                    textAlign: TextAlign.center,
                    style: textTheme.titleMedium?.copyWith(
                      color: _primaryText,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 5,
                    ),
                  ),
                  Text(
                    'Member ${profile.number}',
                    textAlign: TextAlign.center,
                    style: textTheme.labelMedium?.copyWith(
                      color: _secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton.filledTonal(
            style: controlStyle,
            isSelected: isFavourite,
            tooltip: isFavourite
                ? 'Remove from favourites'
                : 'Add to favourites',
            onPressed: onFavourite,
            icon: AnimatedSwitcher(
              duration: duration,
              switchInCurve: Curves.easeOutBack,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: Icon(
                isFavourite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                key: ValueKey(isFavourite),
                color: isFavourite ? const Color(0xfff8badf) : _primaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuraIntro extends StatelessWidget {
  const _AuraIntro({
    required this.profile,
    required this.offset,
    required this.photoScale,
    required this.titleOpacity,
  });

  final MemberProfile profile;
  final Animation<Offset> offset;
  final Animation<double> photoScale;
  final Animation<double> titleOpacity;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SlideTransition(
      position: offset,
      child: Column(
        children: [
          _AuraPortrait(profile: profile, scale: photoScale),
          const SizedBox(height: 7),
          FadeTransition(
            opacity: titleOpacity,
            child: Column(
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    profile.fullName,
                    textAlign: TextAlign.center,
                    style: textTheme.displaySmall?.copyWith(
                      color: _primaryText,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1.25,
                      height: 1.08,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Student ID · ${profile.studentId}',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(color: _secondaryText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AuraBackdrop extends StatelessWidget {
  const _AuraBackdrop();

  @override
  Widget build(BuildContext context) {
    return const RepaintBoundary(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xff2c204d), _ink, Color(0xff1b2845)],
            stops: [0, 0.56, 1],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -214,
              left: -150,
              width: 540,
              height: 600,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [Color(0x908b65c8), Color(0x007958ba)],
                    stops: [0, 1],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 120,
              right: -230,
              width: 570,
              height: 540,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [Color(0x605477dc), Color(0x004465b8)],
                    stops: [0, 1],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuraPortrait extends StatelessWidget {
  const _AuraPortrait({required this.profile, required this.scale});

  final MemberProfile profile;
  final Animation<double> scale;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 188,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0x5ac7b3ff), Color(0x00c7b3ff)],
                  stops: [0.55, 1],
                ),
              ),
            ),
          ),
          const SizedBox.square(
            dimension: 172,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.fromBorderSide(BorderSide(color: _glassBorder)),
              ),
            ),
          ),
          ScaleTransition(
            scale: scale,
            child: SizedBox.square(
              dimension: 149,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xffece1ff),
                      Color(0xff8f9fe6),
                      Color(0xffb09bd9),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: ClipOval(child: MemberPhoto(profile: profile)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FrostedPanel extends StatelessWidget {
  const _FrostedPanel({required this.child});

  static final _blur = ImageFilter.blur(sigmaX: 11, sigmaY: 11);
  static const _radius = BorderRadius.all(Radius.circular(24));

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: _radius,
      child: BackdropFilter.grouped(
        filter: _blur,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            borderRadius: _radius,
            gradient: _glassTint,
            border: Border.fromBorderSide(BorderSide(color: _glassBorder)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _ContactPanel extends StatelessWidget {
  const _ContactPanel({required this.profile});

  final MemberProfile profile;

  @override
  Widget build(BuildContext context) {
    return _FrostedPanel(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        child: Column(
          children: [
            _ContactDetail(
              icon: Icons.location_on_outlined,
              label: 'Address',
              value: profile.address,
            ),
            const Divider(height: 22, color: _glassBorder),
            _ContactDetail(
              icon: Icons.mail_outline_rounded,
              label: 'Email',
              value: profile.email,
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactDetail extends StatelessWidget {
  const _ContactDetail({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(icon, size: 21, color: _lavender),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: textTheme.labelMedium?.copyWith(color: _secondaryText),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: textTheme.bodyLarge?.copyWith(color: _primaryText),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: _primaryText,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _Qualifications extends StatelessWidget {
  const _Qualifications({required this.qualifications});

  final List<String> qualifications;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
      color: _primaryText,
      fontWeight: FontWeight.w500,
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = math.min(constraints.maxWidth * 0.78, 264.0);
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 10,
              children: [
                for (final qualification in qualifications)
                  Container(
                    width: cardWidth,
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      gradient: _glassTint,
                      border: Border.fromBorderSide(
                        BorderSide(color: _glassBorder),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.school_outlined,
                          color: _lavender,
                          size: 23,
                        ),
                        const SizedBox(height: 10),
                        Text(qualification, style: textStyle),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SkillsPanel extends StatelessWidget {
  const _SkillsPanel({required this.skills});

  final List<String> skills;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
      color: _primaryText,
      fontWeight: FontWeight.w500,
    );
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Color(0x167e8dc9),
        borderRadius: BorderRadius.all(Radius.circular(24)),
        border: Border.fromBorderSide(BorderSide(color: _glassBorder)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeading('Soft skills'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final skill in skills)
                  DecoratedBox(
                    decoration: const BoxDecoration(
                      color: Color(0x22bbadfa),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.fromBorderSide(
                        BorderSide(color: _glassBorder),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 9,
                      ),
                      child: Text(skill, style: textStyle),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TalentsPanel extends StatelessWidget {
  const _TalentsPanel({
    required this.talents,
    required this.expanded,
    required this.duration,
    required this.onToggle,
  });

  final List<String> talents;
  final bool expanded;
  final Duration duration;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(
      context,
    ).textTheme.bodyLarge?.copyWith(color: _primaryText);
    final details = expanded
        ? Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                const Divider(height: 1, color: _glassBorder),
                const SizedBox(height: 12),
                for (final talent in talents)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Icon(
                            Icons.diamond_outlined,
                            size: 14,
                            color: _lavender,
                          ),
                        ),
                        const SizedBox(width: 9),
                        Expanded(child: Text(talent, style: textStyle)),
                      ],
                    ),
                  ),
              ],
            ),
          )
        : const SizedBox.shrink();

    return _FrostedPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            button: true,
            expanded: expanded,
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: onToggle,
                focusColor: const Color(0x26ded0ff),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.auto_awesome_rounded,
                        color: _lavender,
                        size: 21,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(child: _SectionHeading('Special talents')),
                      const SizedBox(width: 8),
                      AnimatedRotation(
                        turns: expanded ? 0.5 : 0,
                        duration: duration,
                        curve: Curves.easeInOutCubic,
                        child: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: _lavender,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (duration == Duration.zero)
            details
          else
            AnimatedSize(
              duration: duration,
              curve: Curves.easeInOutCubic,
              alignment: Alignment.topCenter,
              child: details,
            ),
        ],
      ),
    );
  }
}
