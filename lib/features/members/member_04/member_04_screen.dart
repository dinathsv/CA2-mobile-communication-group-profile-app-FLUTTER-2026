import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_theme.dart';
import '../../../models/member_profile.dart';
import '../../../widgets/member_photo.dart';

/// Profile data for Member 04 (Umindu Dinal).
/// Update `studentId` (and home `address`, if desired) as they are not listed
/// on the CV.
final member04Profile = MemberProfile(
  id: 'member_04',
  fullName: 'Umindu Dinal',
  studentId: '23IT0470',
  address: 'Diyagama, Sri Lanka',
  email: 'umindudinal818@gmail.com',
  photoAsset: 'assets/members/member_04/portrait.png',
  qualifications: const [
    'National Diploma in Technology (NDT) – Information Technology, Institute of Technology, University of Moratuwa (2025 – Present)',
    'Front-End Web Development — University of Moratuwa (CODL)',
    'Server-side Web Programming — University of Moratuwa (CODL)',
    'Python Programming — University of Moratuwa (CODL)',
    'Introduction to Software Quality Assurance — University of Moratuwa (CODL)',
  ],
  softSkills: const [
    'Problem Solving',
    'User-Centered Design',
    'Bilingual Communication',
    'Continuous Learning',
    'Team Collaboration',
  ],
  specialTalents: const [
    'Flutter & Dart Cross-Platform Mobile Development (GuideLanka, Ape-Baas, AgriCare LK)',
    'REST APIs, Firebase FCM & Supabase Backend Integration',
    'AI-Powered Plant Disease Diagnosis (TensorFlow/Keras)',
    'Live GPS Tracking, Interactive Maps & Geofencing',
  ],
  designName: 'ZEN',
);

// ---------------------------------------------------------------------------
// ZEN. colour palette — Warm cream, muted olive, soft sand, deep charcoal.
// ---------------------------------------------------------------------------
const _cream = Color(0xFFF5F2E9);
const _sand = Color(0xFFECE7DA);
const _sandSelected = Color(0xFFE3DCCB);
const _sandBorder = Color(0xFFD5CEBE);
const _olive = Color(0xFF69765B);
const _oliveText = Color(0xFF49553D);
const _charcoal = Color(0xFF282A25);
const _charcoalMuted = Color(0xFF54564E);

const _serifFallback = <String>['Georgia', 'Noto Serif', 'Times New Roman'];

class Member04Screen extends StatefulWidget {
  const Member04Screen({super.key});

  @override
  State<Member04Screen> createState() => _Member04ScreenState();
}

class _Member04ScreenState extends State<Member04Screen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entranceController;
  bool _entranceStarted = false;
  bool _qualificationsExpanded = true;
  bool _talentsExpanded = true;
  int? _selectedSkillIndex;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_entranceStarted) return;
    _entranceStarted = true;

    if (MediaQuery.disableAnimationsOf(context)) {
      _entranceController.value = 1.0;
    } else {
      _entranceController.forward();
    }
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  void _toggleQualifications() {
    setState(() {
      _qualificationsExpanded = !_qualificationsExpanded;
    });
  }

  void _toggleTalents() {
    setState(() {
      _talentsExpanded = !_talentsExpanded;
    });
  }

  void _toggleSkill(int index) {
    setState(() {
      _selectedSkillIndex = _selectedSkillIndex == index ? null : index;
    });
  }

  Animation<double> _fadeInterval(
    double begin,
    double end,
    bool reducedMotion,
  ) {
    if (reducedMotion) return const AlwaysStoppedAnimation<double>(1.0);
    return CurvedAnimation(
      parent: _entranceController,
      curve: Interval(begin, end, curve: Curves.easeOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = member04Profile;
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    final viewportWidth = MediaQuery.sizeOf(context).width;
    final motionDuration = reducedMotion
        ? Duration.zero
        : const Duration(milliseconds: 340);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: _cream,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ZenTopBar(
                    designName: profile.designName,
                    memberNumber: profile.number,
                    onBack: () => Navigator.of(context).maybePop(),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 56),
                      children: [
                        // Asymmetric arch portrait framed with negative space.
                        Align(
                          alignment: Alignment.centerRight,
                          child: _ArchPortrait(
                            profile: profile,
                            width: (viewportWidth * 0.62).clamp(185.0, 276.0),
                          ),
                        ),
                        const SizedBox(height: 36),

                        // Identity block: large serif name & quiet contact info.
                        FadeTransition(
                          opacity: _fadeInterval(0.0, 0.58, reducedMotion),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: _IdentitySection(profile: profile),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Asymmetric botanical hairline divider.
                        FadeTransition(
                          opacity: _fadeInterval(0.14, 0.7, reducedMotion),
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: _BotanicalRule(widthFactor: 0.72),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // 01 — Collapsible botanical-inspired academic timeline.
                        FadeTransition(
                          opacity: _fadeInterval(0.22, 0.8, reducedMotion),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: _CollapsibleSection(
                              indexLabel: '01',
                              title: 'Academic Qualifications',
                              expanded: _qualificationsExpanded,
                              duration: motionDuration,
                              onToggle: _toggleQualifications,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 18),
                                child: _BotanicalTimeline(
                                  qualifications: profile.qualifications,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        FadeTransition(
                          opacity: _fadeInterval(0.32, 0.86, reducedMotion),
                          child: const Align(
                            alignment: Alignment.centerRight,
                            child: _ThinDivider(widthFactor: 0.64),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // 02 — Organic pill-shaped soft skills (asymmetric right).
                        FadeTransition(
                          opacity: _fadeInterval(0.4, 0.92, reducedMotion),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 460),
                              child: _SoftSkillsSection(
                                skills: profile.softSkills,
                                selectedIndex: _selectedSkillIndex,
                                duration: motionDuration,
                                onSelect: _toggleSkill,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        FadeTransition(
                          opacity: _fadeInterval(0.48, 0.96, reducedMotion),
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: _ThinDivider(widthFactor: 0.58),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // 03 — Clean expandable special talents list.
                        FadeTransition(
                          opacity: _fadeInterval(0.55, 1.0, reducedMotion),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: _CollapsibleSection(
                              indexLabel: '03',
                              title: 'Special Talents',
                              expanded: _talentsExpanded,
                              duration: motionDuration,
                              onToggle: _toggleTalents,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 14),
                                child: _TalentsList(
                                  talents: profile.specialTalents,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 44),

                        // Quiet editorial colophon.
                        FadeTransition(
                          opacity: _fadeInterval(0.65, 1.0, reducedMotion),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: _ZenColophon(
                              designName: profile.designName,
                              memberNumber: profile.number,
                            ),
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

// ---------------------------------------------------------------------------
// Top navigation bar — understated back action and design mark
// ---------------------------------------------------------------------------
class _ZenTopBar extends StatelessWidget {
  const _ZenTopBar({
    required this.designName,
    required this.memberNumber,
    required this.onBack,
  });

  final String designName;
  final String memberNumber;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 24, 4),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Back',
            onPressed: onBack,
            color: _charcoal,
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: const Icon(Icons.arrow_back_rounded, size: 22),
          ),
          const Spacer(),
          Text(
            '$designName.',
            style: const TextStyle(
              fontFamily: 'serif',
              fontFamilyFallback: _serifFallback,
              color: _charcoal,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              letterSpacing: 2.8,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$memberNumber / 09',
            style: const TextStyle(
              color: _oliveText,
              fontSize: 11,
              fontWeight: FontWeight.w400,
              letterSpacing: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Arch-shaped portrait frame using ClipPath and MemberPhoto
// ---------------------------------------------------------------------------
class _ArchPortrait extends StatelessWidget {
  const _ArchPortrait({required this.profile, required this.width});

  final MemberProfile profile;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Subtle soft sand backing offset gently for organic depth.
          Positioned.fill(
            child: Transform.translate(
              offset: const Offset(-10, 10),
              child: ClipPath(
                clipper: const _ArchClipper(),
                child: const ColoredBox(color: _sand),
              ),
            ),
          ),
          // Primary portrait inside arch ClipPath with a hairline olive border.
          CustomPaint(
            foregroundPainter: const _ArchOutlinePainter(),
            child: ClipPath(
              clipper: const _ArchClipper(),
              child: AspectRatio(
                aspectRatio: 3.6 / 4.6,
                child: MemberPhoto(profile: profile),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArchClipper extends CustomClipper<Path> {
  const _ArchClipper();

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final archRadius = w / 2;
    const bottomRadius = 18.0;

    return Path()
      ..moveTo(0, archRadius)
      ..arcToPoint(Offset(w, archRadius), radius: Radius.circular(archRadius))
      ..lineTo(w, h - bottomRadius)
      ..quadraticBezierTo(w, h, w - bottomRadius, h)
      ..lineTo(bottomRadius, h)
      ..quadraticBezierTo(0, h, 0, h - bottomRadius)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _ArchOutlinePainter extends CustomPainter {
  const _ArchOutlinePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final path = const _ArchClipper().getClip(size);
    final paint = Paint()
      ..color = _olive.withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ---------------------------------------------------------------------------
// Identity block — Large serif name + quiet address, email, and student ID
// ---------------------------------------------------------------------------
class _IdentitySection extends StatelessWidget {
  const _IdentitySection({required this.profile});

  final MemberProfile profile;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final nameSize = (screenWidth * 0.088).clamp(28.0, 38.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MEMBER ${profile.number}  ·  ${profile.designName}.',
          style: const TextStyle(
            color: _oliveText,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 2.2,
          ),
        ),
        const SizedBox(height: 10),
        Semantics(
          header: true,
          child: Text(
            profile.fullName,
            style: TextStyle(
              fontFamily: 'serif',
              fontFamilyFallback: _serifFallback,
              color: _charcoal,
              fontSize: nameSize,
              fontWeight: FontWeight.w400,
              height: 1.15,
              letterSpacing: -0.3,
            ),
          ),
        ),
        const SizedBox(height: 20),
        _MetaLine(icon: Icons.badge_outlined, text: profile.studentId),
        const SizedBox(height: 9),
        _MetaLine(icon: Icons.place_outlined, text: profile.address),
        const SizedBox(height: 9),
        _MetaLine(icon: Icons.mail_outline_rounded, text: profile.email),
      ],
    );
  }
}

class _MetaLine extends StatelessWidget {
  const _MetaLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(icon, size: 15, color: _oliveText),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: _charcoalMuted,
              fontSize: 13.5,
              fontWeight: FontWeight.w300,
              height: 1.45,
              letterSpacing: 0.15,
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Understated organic dividers
// ---------------------------------------------------------------------------
class _BotanicalRule extends StatelessWidget {
  const _BotanicalRule({required this.widthFactor});

  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Row(
        children: [
          Expanded(child: Container(height: 0.8, color: _sandBorder)),
          const SizedBox(width: 10),
          const SizedBox(
            width: 12,
            height: 12,
            child: CustomPaint(painter: _LeafMarkPainter()),
          ),
        ],
      ),
    );
  }
}

class _ThinDivider extends StatelessWidget {
  const _ThinDivider({required this.widthFactor});

  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Container(height: 0.8, color: _sandBorder),
    );
  }
}

class _LeafMarkPainter extends CustomPainter {
  const _LeafMarkPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(1, size.height - 1)
      ..quadraticBezierTo(1, 2, size.width - 1, 1)
      ..quadraticBezierTo(size.width - 2, size.height - 2, 1, size.height - 1);

    final fillPaint = Paint()
      ..color = _olive.withValues(alpha: 0.25)
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = _olive
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ---------------------------------------------------------------------------
// Collapsible editorial section using AnimatedSize
// ---------------------------------------------------------------------------
class _CollapsibleSection extends StatelessWidget {
  const _CollapsibleSection({
    required this.indexLabel,
    required this.title,
    required this.expanded,
    required this.duration,
    required this.onToggle,
    required this.child,
  });

  final String indexLabel;
  final String title;
  final bool expanded;
  final Duration duration;
  final VoidCallback onToggle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          button: true,
          expanded: expanded,
          label: title,
          hint: expanded ? 'Collapse $title' : 'Expand $title',
          onTap: onToggle,
          child: InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(12),
            splashColor: _olive.withValues(alpha: 0.08),
            highlightColor: _sand.withValues(alpha: 0.65),
            child: ExcludeSemantics(
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 48),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Text(
                        indexLabel,
                        style: const TextStyle(
                          color: _oliveText,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.8,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontFamily: 'serif',
                            fontFamilyFallback: _serifFallback,
                            color: _charcoal,
                            fontSize: 21,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      AnimatedRotation(
                        turns: expanded ? 0.125 : 0.0,
                        duration: duration,
                        curve: Curves.easeOutCubic,
                        child: const Icon(
                          Icons.add_rounded,
                          size: 20,
                          color: _oliveText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: duration,
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          clipBehavior: Clip.hardEdge,
          child: expanded ? child : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Minimal botanical-inspired academic timeline
// ---------------------------------------------------------------------------
class _BotanicalTimeline extends StatelessWidget {
  const _BotanicalTimeline({required this.qualifications});

  final List<String> qualifications;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < qualifications.length; i++)
          _BotanicalTimelineEntry(
            text: qualifications[i],
            isFirst: i == 0,
            isLast: i == qualifications.length - 1,
          ),
      ],
    );
  }
}

class _BotanicalTimelineEntry extends StatelessWidget {
  const _BotanicalTimelineEntry({
    required this.text,
    required this.isFirst,
    required this.isLast,
  });

  final String text;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 24,
            child: CustomPaint(
              painter: _TimelineStemPainter(isFirst: isFirst, isLast: isLast),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 4 : 20),
              child: Text(
                text,
                style: const TextStyle(
                  color: _charcoal,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w300,
                  height: 1.55,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineStemPainter extends CustomPainter {
  const _TimelineStemPainter({required this.isFirst, required this.isLast});

  final bool isFirst;
  final bool isLast;

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    const nodeY = 10.0;

    final stemPaint = Paint()
      ..color = _olive.withValues(alpha: 0.42)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    if (!isFirst) {
      canvas.drawLine(
        Offset(centerX, 0),
        const Offset(12, nodeY - 5),
        stemPaint,
      );
    }
    if (!isLast) {
      canvas.drawLine(
        Offset(centerX, nodeY + 5),
        Offset(centerX, size.height),
        stemPaint,
      );
    }

    // Organic seed / leaf bud node.
    final budPath = Path()
      ..moveTo(centerX - 4, nodeY + 2)
      ..quadraticBezierTo(centerX - 4, nodeY - 5, centerX + 4, nodeY - 4)
      ..quadraticBezierTo(centerX + 4, nodeY + 4, centerX - 4, nodeY + 2);

    canvas.drawPath(
      budPath,
      Paint()
        ..color = _olive.withValues(alpha: 0.28)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      budPath,
      Paint()
        ..color = _olive
        ..strokeWidth = 1.1
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant _TimelineStemPainter oldDelegate) =>
      oldDelegate.isFirst != isFirst || oldDelegate.isLast != isLast;
}

// ---------------------------------------------------------------------------
// Organic pill-shaped soft skills
// ---------------------------------------------------------------------------
class _SoftSkillsSection extends StatelessWidget {
  const _SoftSkillsSection({
    required this.skills,
    required this.selectedIndex,
    required this.duration,
    required this.onSelect,
  });

  final List<String> skills;
  final int? selectedIndex;
  final Duration duration;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text(
              '02',
              style: TextStyle(
                color: _oliveText,
                fontSize: 11,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.8,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Soft Skills',
                style: TextStyle(
                  fontFamily: 'serif',
                  fontFamilyFallback: _serifFallback,
                  color: _charcoal,
                  fontSize: 21,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.1,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (var i = 0; i < skills.length; i++)
              _OrganicSkillPill(
                label: skills[i],
                selected: selectedIndex == i,
                duration: duration,
                onTap: () => onSelect(i),
              ),
          ],
        ),
      ],
    );
  }
}

class _OrganicSkillPill extends StatelessWidget {
  const _OrganicSkillPill({
    required this.label,
    required this.selected,
    required this.duration,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Duration duration;
  final VoidCallback onTap;

  static const _organicRadius = BorderRadius.only(
    topLeft: Radius.circular(20),
    topRight: Radius.circular(13),
    bottomLeft: Radius.circular(13),
    bottomRight: Radius.circular(20),
  );

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: _organicRadius,
          splashColor: _olive.withValues(alpha: 0.10),
          highlightColor: _sandSelected,
          child: AnimatedContainer(
            duration: duration,
            curve: Curves.easeOut,
            constraints: const BoxConstraints(minHeight: 40),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: selected ? _sandSelected : _sand,
              borderRadius: _organicRadius,
              border: Border.all(
                color: selected ? _olive : _sandBorder,
                width: selected ? 1.1 : 0.9,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: duration,
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: selected ? _olive : _olive.withValues(alpha: 0.55),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 9),
                Flexible(
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: _charcoal,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w400,
                      height: 1.3,
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

// ---------------------------------------------------------------------------
// Clean expandable special talents list
// ---------------------------------------------------------------------------
class _TalentsList extends StatelessWidget {
  const _TalentsList({required this.talents});

  final List<String> talents;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < talents.length; i++) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 30,
                  child: Text(
                    '${i + 1}'.padLeft(2, '0'),
                    style: const TextStyle(
                      color: _oliveText,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    talents[i],
                    style: const TextStyle(
                      color: _charcoal,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w300,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (i < talents.length - 1)
            Container(height: 0.75, color: _sandBorder),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Quiet colophon at the end of the editorial scroll
// ---------------------------------------------------------------------------
class _ZenColophon extends StatelessWidget {
  const _ZenColophon({required this.designName, required this.memberNumber});

  final String designName;
  final String memberNumber;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: 10,
          height: 10,
          child: CustomPaint(painter: _LeafMarkPainter()),
        ),
        const SizedBox(width: 10),
        Text(
          '${AppTheme.appName}  ·  $designName  ·  $memberNumber',
          style: const TextStyle(
            color: _oliveText,
            fontSize: 10.5,
            fontWeight: FontWeight.w400,
            letterSpacing: 2.0,
          ),
        ),
      ],
    );
  }
}
