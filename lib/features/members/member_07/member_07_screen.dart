import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../models/member_profile.dart';
import '../../../widgets/member_photo.dart';

final member07Profile = MemberProfile(
  id: 'member_07',
  fullName: 'Manusha Ginige',
  studentId: '23IT0477',
  address: 'Ambalangoda, Sri Lanka',
  email: 'manushaginige@gmail.com',
  photoAsset: 'assets/members/member_07/portrait.png',
  qualifications: const [
    'National Diploma in Technology (Information Technology) — Institute of Technology, University of Moratuwa (expected 2027)',
    'G.C.E. Advanced Level, Physical Science — Dharmasoka College (2022)',
    'Cisco Python Essentials 1 — Certificate of Completion',
  ],
  softSkills: const ['Motivated', 'Problem-solving', 'User-focused'],
  specialTalents: const [
    'Full-stack development',
    'Backend architecture',
    'UI/UX design',
    'REST API integration',
  ],
  designName: 'PULSE',
);

class Member07Screen extends StatefulWidget {
  const Member07Screen({super.key});

  @override
  State<Member07Screen> createState() => _Member07ScreenState();
}

class _Member07ScreenState extends State<Member07Screen>
    with SingleTickerProviderStateMixin {
  static const _background = Color(0xff080808);
  static const _surface = Color(0xff121212);
  static const _orange = Color(0xffff5c00);
  static const _white = Color(0xfff7f5f2);
  static const _muted = Color(0xffa19d99);

  late final AnimationController _entranceController;
  final Set<String> _selectedSkills = {};
  final Set<int> _revealedTalents = {};
  bool _timelineExpanded = false;
  bool _entranceStarted = false;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 720),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _entranceController.value = 1;
    } else if (!_entranceStarted) {
      _entranceStarted = true;
      _entranceController.forward();
    }
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = member07Profile;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final sectionMotion = reduceMotion
        ? Duration.zero
        : const Duration(milliseconds: 220);
    final headerHeight = (MediaQuery.sizeOf(context).height * 0.49)
        .clamp(340.0, 480.0)
        .toDouble();

    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _background,
        foregroundColor: _white,
        elevation: 0,
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back),
        ),
        titleSpacing: 0,
        title: const Text(
          'NINE.  /  07',
          style: TextStyle(
            color: _white,
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Center(
              child: Text(
                'PULSE',
                style: TextStyle(
                  color: _orange,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 52),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildPortraitHeader(
                    profile: profile,
                    height: headerHeight,
                  ),
                  const SizedBox(height: 34),
                  _SectionHeading(number: '01', title: 'Identity'),
                  const SizedBox(height: 18),
                  _IdentityDetails(profile: profile),
                  const SizedBox(height: 42),
                  _SectionHeading(number: '02', title: 'Journey'),
                  const SizedBox(height: 18),
                  _buildJourney(profile, sectionMotion),
                  const SizedBox(height: 42),
                  _SectionHeading(number: '03', title: 'Strengths'),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 9,
                    runSpacing: 10,
                    children: [
                      for (final skill in profile.softSkills)
                        _SkillChip(
                          label: skill,
                          selected: _selectedSkills.contains(skill),
                          duration: sectionMotion,
                          onTap: () {
                            setState(() {
                              if (!_selectedSkills.add(skill)) {
                                _selectedSkills.remove(skill);
                              }
                            });
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 42),
                  _SectionHeading(number: '04', title: 'Beyond'),
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 170,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(right: 4),
                      itemCount: profile.specialTalents.length,
                      itemBuilder: (context, index) {
                        final isRevealed = _revealedTalents.contains(index);
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: _TalentCard(
                            index: index,
                            talent: profile.specialTalents[index],
                            revealed: isRevealed,
                            duration: sectionMotion,
                            onTap: () {
                              setState(() {
                                if (!_revealedTalents.add(index)) {
                                  _revealedTalents.remove(index);
                                }
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 28),
                  const _FooterMark(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPortraitHeader({
    required MemberProfile profile,
    required double height,
  }) {
    return SizedBox(
      height: height,
      child: AnimatedBuilder(
        animation: _entranceController,
        builder: (context, child) {
          final progress = Curves.easeOutCubic.transform(
            _entranceController.value,
          );
          return Stack(
            fit: StackFit.expand,
            children: [
              const ColoredBox(color: _surface),
              ClipPath(
                clipper: const _AngularPortraitClipper(),
                child: MemberPhoto(profile: profile),
              ),
              Positioned.fill(
                child: CustomPaint(
                  painter: _DiagonalLinesPainter(progress: progress),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        _background.withValues(alpha: 0.02),
                        _background.withValues(alpha: 0.02),
                        _background.withValues(alpha: 0.88),
                      ],
                      stops: const [0, 0.47, 1],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 18,
                top: 20,
                child: _CornerLabel(number: '07', accent: _orange),
              ),
              Positioned(
                left: 18,
                right: 12,
                bottom: 20,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 7,
                      child: Semantics(
                        header: true,
                        child: Text(
                          profile.fullName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _white,
                            fontSize: 34,
                            height: 0.98,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1.6,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      flex: 4,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.bottomRight,
                        child: Text(
                          profile.number,
                          style: const TextStyle(
                            color: _orange,
                            fontSize: 112,
                            height: 0.78,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 17,
                top: 20,
                child: Transform.translate(
                  offset: Offset((1 - progress) * 18, 0),
                  child: Text(
                    profile.designName,
                    style: const TextStyle(
                      color: _white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2.4,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 18,
                bottom: 107,
                child: Text(
                  'PERSONAL PROFILE  /  NINE.',
                  style: TextStyle(
                    color: _white.withValues(alpha: 0.78),
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildJourney(MemberProfile profile, Duration duration) {
    final visibleQualifications = _timelineExpanded
        ? profile.qualifications
        : profile.qualifications.take(2).toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AnimatedSize(
          duration: duration,
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              for (var index = 0;
                  index < visibleQualifications.length;
                  index++)
                _Milestone(
                  qualification: visibleQualifications[index],
                  last: index == visibleQualifications.length - 1 &&
                      (!_timelineExpanded ||
                          profile.qualifications.length <=
                              visibleQualifications.length),
                ),
              if (_timelineExpanded && profile.qualifications.length <= 2)
                const Padding(
                  padding: EdgeInsets.only(left: 32, bottom: 12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'No additional qualifications listed.',
                      style: TextStyle(
                        color: _muted,
                        fontSize: 12,
                        height: 1.45,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () => setState(() {
              _timelineExpanded = !_timelineExpanded;
            }),
            style: TextButton.styleFrom(
              foregroundColor: _orange,
              minimumSize: const Size(44, 44),
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _timelineExpanded ? 'COLLAPSE TIMELINE' : 'EXPAND TIMELINE',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(_timelineExpanded ? Icons.remove : Icons.add, size: 15),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AngularPortraitClipper extends CustomClipper<Path> {
  const _AngularPortraitClipper();

  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.82, 0)
      ..lineTo(size.width, size.height * 0.14)
      ..lineTo(size.width, size.height * 0.84)
      ..lineTo(size.width * 0.85, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant _AngularPortraitClipper oldClipper) => false;
}

class _DiagonalLinesPainter extends CustomPainter {
  const _DiagonalLinesPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    canvas.save();
    canvas.clipRect(Offset.zero & size);
    final paint = Paint()
      ..color = const Color(0xffff5c00).withValues(alpha: 0.62)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    final slide = (1 - progress) * 28;
    final lineCount = 5;

    for (var index = 0; index < lineCount; index++) {
      final startX = size.width * 0.58 + index * 19 + slide;
      final endX = startX - size.height * 0.22 * progress;
      canvas.drawLine(
        Offset(startX, 0),
        Offset(endX, size.height * 0.31 * progress),
        paint,
      );
    }

    final markerPaint = Paint()
      ..color = const Color(0xffff5c00).withValues(alpha: 0.9 * progress)
      ..style = PaintingStyle.fill;
    final marker = Path()
      ..moveTo(size.width * 0.91, size.height * 0.4)
      ..lineTo(size.width * 0.98, size.height * 0.4)
      ..lineTo(size.width * 0.91, size.height * 0.45)
      ..close();
    canvas.drawPath(marker, markerPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _DiagonalLinesPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.number, required this.title});

  final String number;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          number,
          style: const TextStyle(
            color: Color(0xffff5c00),
            fontSize: 28,
            height: 0.95,
            fontWeight: FontWeight.w900,
            letterSpacing: -1.5,
          ),
        ),
        const SizedBox(width: 13),
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: Color(0xfff7f5f2),
            fontSize: 15,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.8,
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Divider(height: 1, thickness: 1, color: Color(0xff34312f)),
        ),
      ],
    );
  }
}

class _IdentityDetails extends StatelessWidget {
  const _IdentityDetails({required this.profile});

  final MemberProfile profile;

  @override
  Widget build(BuildContext context) {
    final details = [
      ('FULL NAME', profile.fullName),
      ('STUDENT ID', profile.studentId),
      ('ADDRESS', profile.address),
      ('EMAIL', profile.email),
    ];

    return Column(
      children: [
        for (var index = 0; index < details.length; index++) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 13),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 104,
                  child: Text(
                    details[index].$1,
                    style: const TextStyle(
                      color: Color(0xffa19d99),
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.15,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    details[index].$2,
                    style: const TextStyle(
                      color: Color(0xfff7f5f2),
                      fontSize: 14,
                      height: 1.35,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (index != details.length - 1)
            const Divider(height: 1, thickness: 1, color: Color(0xff262422)),
        ],
      ],
    );
  }
}

class _Milestone extends StatelessWidget {
  const _Milestone({required this.qualification, required this.last});

  final String qualification;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.only(top: 5),
                  decoration: const BoxDecoration(
                    color: Color(0xffff5c00),
                    shape: BoxShape.circle,
                  ),
                ),
                if (!last)
                  const Expanded(
                    child: SizedBox(
                      width: 1,
                      child: ColoredBox(color: Color(0xff49413c)),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: last ? 8 : 22),
              child: Text(
                qualification,
                style: const TextStyle(
                  color: Color(0xfff7f5f2),
                  fontSize: 14,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillChip extends StatelessWidget {
  const _SkillChip({
    required this.label,
    required this.selected,
    required this.duration,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Duration duration;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: ClipPath(
          clipper: const _ChamferClipper(),
          child: AnimatedContainer(
            duration: duration,
            curve: Curves.easeOutCubic,
            constraints: const BoxConstraints(minHeight: 44),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: selected ? const Color(0xffff5c00) : Colors.transparent,
              border: Border.all(
                color: selected
                    ? const Color(0xffff5c00)
                    : const Color(0xff5d5149),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selected) ...[
                  const Icon(Icons.check, color: Color(0xff080808), size: 14),
                  const SizedBox(width: 6),
                ],
                Text(
                  label,
                  style: TextStyle(
                    color: selected
                        ? const Color(0xff080808)
                        : const Color(0xfff7f5f2),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TalentCard extends StatelessWidget {
  const _TalentCard({
    required this.index,
    required this.talent,
    required this.revealed,
    required this.duration,
    required this.onTap,
  });

  final int index;
  final String talent;
  final bool revealed;
  final Duration duration;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      expanded: revealed,
      label: revealed ? talent : 'Reveal talent ${index + 1}',
      child: GestureDetector(
        onTap: onTap,
        child: ClipPath(
          clipper: const _ChamferClipper(),
          child: AnimatedContainer(
            duration: duration,
            curve: Curves.easeOutCubic,
            width: 212,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: revealed
                  ? const Color(0xff26160e)
                  : const Color(0xff121212),
              border: Border.all(
                color: revealed
                    ? const Color(0xffff5c00)
                    : const Color(0xff393330),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TALENT  ${(index + 1).toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        color: Color(0xffff5c00),
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.3,
                      ),
                    ),
                    Icon(
                      revealed ? Icons.close : Icons.north_east,
                      color: const Color(0xffff5c00),
                      size: 16,
                    ),
                  ],
                ),
                const Spacer(),
                AnimatedSize(
                  duration: duration,
                  curve: Curves.easeOutCubic,
                  alignment: Alignment.topLeft,
                  child: Text(
                    revealed ? talent : 'TAP TO REVEAL',
                    maxLines: revealed ? 3 : 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: revealed
                          ? const Color(0xfff7f5f2)
                          : const Color(0xffa19d99),
                      fontSize: revealed ? 16 : 10,
                      height: 1.22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: revealed ? 0 : 1.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CornerLabel extends StatelessWidget {
  const _CornerLabel({required this.number, required this.accent});

  final String number;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 3, height: 22, color: accent),
        const SizedBox(width: 7),
        Text(
          'MEMBER $number',
          style: const TextStyle(
            color: Color(0xfff7f5f2),
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.6,
          ),
        ),
      ],
    );
  }
}

class _FooterMark extends StatelessWidget {
  const _FooterMark();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(height: 1, thickness: 1, color: Color(0xff34312f)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Transform.rotate(
            angle: -math.pi / 4,
            child: const Icon(
              Icons.bolt,
              color: Color(0xffff5c00),
              size: 16,
            ),
          ),
        ),
        const Expanded(
          child: Divider(height: 1, thickness: 1, color: Color(0xff34312f)),
        ),
      ],
    );
  }
}

class _ChamferClipper extends CustomClipper<Path> {
  const _ChamferClipper();

  @override
  Path getClip(Size size) {
    const cut = 9.0;
    return Path()
      ..moveTo(cut, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height - cut)
      ..lineTo(size.width - cut, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, cut)
      ..close();
  }

  @override
  bool shouldReclip(covariant _ChamferClipper oldClipper) => false;
}
