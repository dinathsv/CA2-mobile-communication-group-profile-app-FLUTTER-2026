import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../models/member_profile.dart';
import '../../../widgets/member_photo.dart';

final member09Profile = MemberProfile(
  id: 'member_09',
  fullName: 'D.M.S.A.K. Dissanayaka',
  studentId: '23IT0472',
  address: 'Agarathenna Road, Palgahathenna, Passara',
  email: 'sandalialoka011@gmail.com',
  photoAsset: 'assets/members/member_09/portrait.png',
  qualifications: const [
    'IT Diploma — Institute of Technology, University of Moratuwa (2024–2027)',
    'G.C.E. A/L Physical Science — 2C, 1S | Badulla Central College',
  ],
  softSkills: const [
    'Communication',
    'Time Management',
    'Problem Solving',
    'Team Work',
  ],
  specialTalents: const ['Art & Craft', 'Drawing'],
  designName: 'CINEMA',
);

// ---------------------------------------------------------------------------
// CINEMA palette — Midnight navy, near-black surfaces, muted gold accents.
// ---------------------------------------------------------------------------
const _midnightNavy = Color(0xFF0D1420);
const _nearBlack = Color(0xFF070B12);
const _deepSlate = Color(0xFF131D2E);
const _mutedGold = Color(0xFFC9A66B);
const _ivoryText = Color(0xFFF4F1EA);
const _mutedSilver = Color(0xFFB3BAC6);

class Member09Screen extends StatefulWidget {
  const Member09Screen({super.key});

  @override
  State<Member09Screen> createState() => _Member09ScreenState();
}

class _Member09ScreenState extends State<Member09Screen>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final AnimationController _titleFadeController;
  late final Animation<double> _titleFade;

  bool _identityExpanded = true;
  bool _journeyExpanded = true;
  bool _beyondExpanded = true;
  double _collapseProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_handleScroll);
    _titleFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _titleFade = CurvedAnimation(
      parent: _titleFadeController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _titleFadeController.value = 1.0;
    } else if (_titleFadeController.status == AnimationStatus.dismissed) {
      _titleFadeController.forward();
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    _titleFadeController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (!mounted || !_scrollController.hasClients) return;
    final expandedHeight = _computeExpandedHeight(context);
    final collapseRange = (expandedHeight - kToolbarHeight).clamp(
      1.0,
      double.infinity,
    );
    final nextProgress = (_scrollController.offset / collapseRange).clamp(
      0.0,
      1.0,
    );
    if ((nextProgress - _collapseProgress).abs() > 0.01) {
      setState(() {
        _collapseProgress = nextProgress;
      });
    }
  }

  double _computeExpandedHeight(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    // Cover roughly 60-70% of the initial viewport while adapting to compact screens.
    final target = size.height * 0.65;
    return target.clamp(320.0, 620.0);
  }

  @override
  Widget build(BuildContext context) {
    final profile = member09Profile;
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    final expandedHeight = _computeExpandedHeight(context);
    final topPadding = MediaQuery.paddingOf(context).top;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final collapsedTitleOpacity = ((_collapseProgress - 0.55) / 0.35).clamp(
      0.0,
      1.0,
    );
    final heroTitleOpacity = (1.0 - (_collapseProgress / 0.5)).clamp(0.0, 1.0);

    return Theme(
      data: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: _midnightNavy,
        colorScheme: const ColorScheme.dark(
          surface: _midnightNavy,
          surfaceContainerLow: _nearBlack,
          surfaceContainerHighest: _deepSlate,
          primary: _mutedGold,
          onPrimary: _nearBlack,
          onSurface: _ivoryText,
          onSurfaceVariant: _mutedSilver,
          outline: _mutedGold,
        ),
      ),
      child: Scaffold(
        backgroundColor: _midnightNavy,
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              expandedHeight: expandedHeight,
              pinned: true,
              stretch: true,
              elevation: 0,
              scrolledUnderElevation: 0,
              backgroundColor: _nearBlack,
              surfaceTintColor: Colors.transparent,
              leadingWidth: 64,
              leading: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Center(
                  child: _CinemaBackButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                ),
              ),
              title: IgnorePointer(
                ignoring: collapsedTitleOpacity < 0.2,
                child: Opacity(
                  opacity: collapsedTitleOpacity,
                  child: Row(
                    children: [
                      Text(
                        profile.number,
                        style: const TextStyle(
                          color: _mutedGold,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2.2,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          profile.fullName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _ivoryText,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                stretchModes: reducedMotion
                    ? const <StretchMode>[]
                    : const <StretchMode>[StretchMode.zoomBackground],
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    MemberPhoto(profile: profile),
                    // Top scrim for back button legibility over bright portraits.
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xB8070B12),
                            Color(0x22070B12),
                            Color(0x440D1420),
                            Color(0xF20D1420),
                          ],
                          stops: [0.0, 0.28, 0.58, 1.0],
                        ),
                      ),
                    ),
                    // Subtle side vignette for theatrical framing.
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0x55070B12),
                            Colors.transparent,
                            Color(0x55070B12),
                          ],
                          stops: [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 24,
                      right: 24,
                      bottom: 24,
                      top: topPadding + kToolbarHeight,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: FadeTransition(
                          opacity: _titleFade,
                          child: Opacity(
                            opacity: heroTitleOpacity,
                            child: _HeroTitleBlock(profile: profile),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [_midnightNavy, _nearBlack],
                    stops: [0.0, 0.42],
                  ),
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 640),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        24,
                        20,
                        24,
                        36 + bottomPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _PrologueStrip(profile: profile),
                          const SizedBox(height: 28),
                          _ChapterSection(
                            chapterNumber: '01',
                            title: 'Identity',
                            subtitle: 'CAST & CREDENTIALS',
                            isExpanded: _identityExpanded,
                            reducedMotion: reducedMotion,
                            onToggle: () {
                              setState(() {
                                _identityExpanded = !_identityExpanded;
                              });
                            },
                            child: _IdentityChapterBody(profile: profile),
                          ),
                          const SizedBox(height: 32),
                          _ChapterSection(
                            chapterNumber: '02',
                            title: 'The journey',
                            subtitle: 'ACADEMIC TIMELINE',
                            isExpanded: _journeyExpanded,
                            reducedMotion: reducedMotion,
                            onToggle: () {
                              setState(() {
                                _journeyExpanded = !_journeyExpanded;
                              });
                            },
                            child: _JourneyTimelineBody(
                              qualifications: profile.qualifications,
                            ),
                          ),
                          const SizedBox(height: 32),
                          _ChapterSection(
                            chapterNumber: '03',
                            title: 'Beyond',
                            subtitle: 'CRAFT & PRESENCE',
                            isExpanded: _beyondExpanded,
                            reducedMotion: reducedMotion,
                            onToggle: () {
                              setState(() {
                                _beyondExpanded = !_beyondExpanded;
                              });
                            },
                            child: _BeyondChapterBody(
                              softSkills: profile.softSkills,
                              specialTalents: profile.specialTalents,
                            ),
                          ),
                          const SizedBox(height: 40),
                          _EndCreditsFooter(profile: profile),
                        ],
                      ),
                    ),
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

class _CinemaBackButton extends StatelessWidget {
  const _CinemaBackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Back',
      child: Material(
        color: _nearBlack.withValues(alpha: 0.68),
        shape: CircleBorder(
          side: BorderSide(color: _mutedGold.withValues(alpha: 0.45)),
        ),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: const SizedBox(
            width: 44,
            height: 44,
            child: Icon(
              Icons.arrow_back_rounded,
              color: _ivoryText,
              size: 20,
              semanticLabel: 'Back',
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroTitleBlock extends StatelessWidget {
  const _HeroTitleBlock({required this.profile});

  final MemberProfile profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              profile.number,
              style: const TextStyle(
                color: _mutedGold,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 3.2,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 28,
              height: 1,
              color: _mutedGold.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 12),
            Text(
              profile.designName,
              style: const TextStyle(
                color: _mutedSilver,
                fontSize: 11,
                fontWeight: FontWeight.w500,
                letterSpacing: 3.6,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Semantics(
          header: true,
          child: Text(
            profile.fullName,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _ivoryText,
              fontSize: 34,
              height: 1.08,
              fontWeight: FontWeight.w300,
              letterSpacing: -0.6,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          profile.studentId,
          style: const TextStyle(
            color: _mutedSilver,
            fontSize: 13,
            letterSpacing: 1.4,
          ),
        ),
      ],
    );
  }
}

class _PrologueStrip extends StatelessWidget {
  const _PrologueStrip({required this.profile});

  final MemberProfile profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _mutedGold.withValues(alpha: 0.85),
                _mutedGold.withValues(alpha: 0.15),
                Colors.transparent,
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '${AppTheme.appName} COLLECTIVE',
              style: TextStyle(
                color: _mutedGold,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 2.8,
              ),
            ),
            Text(
              'REEL ${profile.number}',
              style: const TextStyle(
                color: _mutedSilver,
                fontSize: 11,
                fontWeight: FontWeight.w500,
                letterSpacing: 2.4,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ChapterSection extends StatelessWidget {
  const _ChapterSection({
    required this.chapterNumber,
    required this.title,
    required this.subtitle,
    required this.isExpanded,
    required this.reducedMotion,
    required this.onToggle,
    required this.child,
  });

  final String chapterNumber;
  final String title;
  final String subtitle;
  final bool isExpanded;
  final bool reducedMotion;
  final VoidCallback onToggle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  chapterNumber,
                  style: const TextStyle(
                    color: _mutedGold,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2.4,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: _mutedSilver,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2.4,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Semantics(
                        header: true,
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: _ivoryText,
                            fontSize: 24,
                            fontWeight: FontWeight.w300,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  isExpanded ? Icons.remove_rounded : Icons.add_rounded,
                  color: _mutedGold,
                  size: 20,
                  semanticLabel: isExpanded
                      ? 'Collapse $title'
                      : 'Expand $title',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Container(height: 1, color: _mutedGold.withValues(alpha: 0.32)),
        AnimatedCrossFade(
          firstChild: Padding(
            padding: const EdgeInsets.only(top: 18),
            child: child,
          ),
          secondChild: const SizedBox.shrink(),
          crossFadeState: isExpanded
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: reducedMotion
              ? Duration.zero
              : const Duration(milliseconds: 240),
          sizeCurve: Curves.easeOutCubic,
        ),
      ],
    );
  }
}

class _IdentityChapterBody extends StatelessWidget {
  const _IdentityChapterBody({required this.profile});

  final MemberProfile profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _CreditLine(
          label: 'FULL NAME',
          value: profile.fullName,
          icon: Icons.person_outline_rounded,
        ),
        _CreditDivider(),
        _CreditLine(
          label: 'STUDENT ID',
          value: profile.studentId,
          icon: Icons.badge_outlined,
        ),
        _CreditDivider(),
        _CreditLine(
          label: 'ADDRESS',
          value: profile.address,
          icon: Icons.place_outlined,
        ),
        _CreditDivider(),
        _CreditLine(
          label: 'EMAIL',
          value: profile.email,
          icon: Icons.mail_outline_rounded,
        ),
      ],
    );
  }
}

class _CreditLine extends StatelessWidget {
  const _CreditLine({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(
              icon,
              size: 16,
              color: _mutedGold.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: _mutedSilver,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: _ivoryText,
                    fontSize: 16,
                    height: 1.45,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CreditDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: _ivoryText.withValues(alpha: 0.08),
    );
  }
}

class _JourneyTimelineBody extends StatelessWidget {
  const _JourneyTimelineBody({required this.qualifications});

  final List<String> qualifications;

  @override
  Widget build(BuildContext context) {
    if (qualifications.isEmpty) {
      return const Text(
        'Qualifications pending',
        style: TextStyle(color: _mutedSilver, fontSize: 15),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < qualifications.length; i++)
          _TimelineEntry(
            indexLabel: '${i + 1}'.padLeft(2, '0'),
            text: qualifications[i],
            isLast: i == qualifications.length - 1,
          ),
      ],
    );
  }
}

class _TimelineEntry extends StatelessWidget {
  const _TimelineEntry({
    required this.indexLabel,
    required this.text,
    required this.isLast,
  });

  final String indexLabel;
  final String text;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 28,
            child: Column(
              children: [
                const SizedBox(height: 6),
                Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _midnightNavy,
                    border: Border.all(color: _mutedGold, width: 1.6),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      color: _mutedGold.withValues(alpha: 0.35),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 4 : 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MILESTONE $indexLabel',
                    style: const TextStyle(
                      color: _mutedGold,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.2,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    text,
                    style: const TextStyle(
                      color: _ivoryText,
                      fontSize: 16,
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BeyondChapterBody extends StatelessWidget {
  const _BeyondChapterBody({
    required this.softSkills,
    required this.specialTalents,
  });

  final List<String> softSkills;
  final List<String> specialTalents;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _TraitColumn(
          heading: 'SOFT SKILLS',
          items: softSkills,
          marker: Icons.auto_awesome_outlined,
        ),
        const SizedBox(height: 24),
        Container(height: 1, color: _ivoryText.withValues(alpha: 0.08)),
        const SizedBox(height: 24),
        _TraitColumn(
          heading: 'SPECIAL TALENTS',
          items: specialTalents,
          marker: Icons.star_outline_rounded,
        ),
      ],
    );
  }
}

class _TraitColumn extends StatelessWidget {
  const _TraitColumn({
    required this.heading,
    required this.items,
    required this.marker,
  });

  final String heading;
  final List<String> items;
  final IconData marker;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(marker, size: 15, color: _mutedGold),
            const SizedBox(width: 8),
            Text(
              heading,
              style: const TextStyle(
                color: _mutedGold,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 2.4,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (items.isEmpty)
          const Text(
            'Details pending',
            style: TextStyle(color: _mutedSilver, fontSize: 15),
          )
        else
          for (var i = 0; i < items.length; i++) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 14,
                    height: 1,
                    margin: const EdgeInsets.only(top: 11, right: 12),
                    color: _mutedGold.withValues(alpha: 0.65),
                  ),
                  Expanded(
                    child: Text(
                      items[i],
                      style: const TextStyle(
                        color: _ivoryText,
                        fontSize: 16,
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
      ],
    );
  }
}

class _EndCreditsFooter extends StatelessWidget {
  const _EndCreditsFooter({required this.profile});

  final MemberProfile profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 48,
          height: 1,
          color: _mutedGold.withValues(alpha: 0.6),
        ),
        const SizedBox(height: 16),
        Text(
          '${profile.designName}  •  MEMBER ${profile.number}',
          style: const TextStyle(
            color: _mutedSilver,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 3.0,
          ),
        ),
      ],
    );
  }
}
