import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../models/member_profile.dart';
import '../../../widgets/member_photo.dart';

final member08Profile = MemberProfile(
  id: 'member_08',
  fullName: 'M. G. Dulan',
  studentId: '23IT0473',
  address: 'Bathalahena, Mulgirigala, Sri Lanka',
  email: 'gehandulan2001@gmail.com',
  photoAsset: 'assets/members/member_08/portrait.png',
  qualifications: const [
    'National Diploma in Technology – Information Technology (2025–Present)\n'
        'Institute of Technology, University of Moratuwa (ITUM), Sri Lanka',
    'GCE Advanced Level Examination (20XX)\nYour School Name, Sri Lanka',
  ],
  softSkills: const [
    'Languages: Python, Dart, Java, JavaScript, SQL, HTML/CSS',
    'AI & Data: Recommendation systems, data preprocessing, location-based ranking',
    'Backend: FastAPI, RESTful APIs, Microservices, API Gateway, PostgreSQL, Redis',
    'Mobile: Flutter (integration with backend services)',
    'Tools & Practices: Git, GitHub, GitHub Actions (CI), Docker, Docker Compose, '
        'Postman, VS Code, Agile Teamwork',
  ],
  specialTalents: const [
    'Recommendation engine\n'
        'Developed the AI recommendation engine of MicroLink, a platform that helps '
        'users discover, navigate to and order from nearby small and micro '
        'businesses through a Flutter mobile app.',
    'Service architecture\n'
        'Built the recommendation service as an independent Python FastAPI '
        'microservice, one of seven services (user, shop, recommendation, '
        'navigation, delivery, crowdsource, admin) behind a single API Gateway.',
    'Personalised ranking\n'
        'Generated personalised shop suggestions using user preferences, shop data '
        'and GPS location, served to the mobile app through REST APIs.',
    'Data and deployment\n'
        'Worked with PostgreSQL for persistent data and Redis for caching, with '
        'all services containerised using Docker and Docker Compose.',
    'Team workflow\n'
        'Followed a team workflow of feature branches, pull requests with peer '
        'review, and GitHub Actions CI checks on every change.',
  ],
  designName: 'BRUTAL',
);

const _careerObjective =
    'Information Technology student with a strong interest in artificial '
    'intelligence and backend development, with hands-on experience building '
    'the AI recommendation engine of a location-based micro-business discovery '
    'platform as a Python FastAPI microservice. Comfortable working in a team '
    'using Git-based workflows, code reviews and containerised development. '
    'Seeking an internship or industrial training placement as an AI/ML or '
    'backend developer to build intelligent, data-driven applications.';

class Member08Screen extends StatefulWidget {
  const Member08Screen({super.key});

  @override
  State<Member08Screen> createState() => _Member08ScreenState();
}

class _Member08ScreenState extends State<Member08Screen> {
  int? _expandedQualification = 0;
  int _selectedSkill = 0;

  @override
  Widget build(BuildContext context) {
    final profile = member08Profile;

    return Scaffold(
      backgroundColor: _paper,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: _paper,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: SafeArea(
          child: DefaultTextStyle(
            style: _copy,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DecoratedBox(
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: _ink, width: 3)),
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1080),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          spacing: 14,
                          children: [
                            Tooltip(
                              message: 'Back',
                              excludeFromSemantics: true,
                              child: _PressSurface(
                                label: 'Back',
                                color: _yellow,
                                onPressed: () =>
                                    Navigator.of(context).maybePop(),
                                padding: EdgeInsets.zero,
                                child: const Center(
                                  child: Icon(Icons.arrow_back, color: _ink),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                profile.designName,
                                style: _display.copyWith(fontSize: 23),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, viewport) {
                      final gutter = viewport.maxWidth >= 600 ? 28.0 : 16.0;
                      return SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(gutter, 18, gutter, 40),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1024),
                            child: LayoutBuilder(
                              builder: (context, available) {
                                final wide = available.maxWidth >= 760;
                                final background = Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  spacing: 24,
                                  children: [
                                    _ContactPanel(profile: profile),
                                    const _CareerPanel(),
                                    _buildEducation(profile),
                                  ],
                                );
                                final work = Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  spacing: 24,
                                  children: [
                                    _buildSkills(profile),
                                    _ProjectPanels(profile: profile),
                                  ],
                                );

                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  spacing: 24,
                                  children: [
                                    _Poster(profile: profile, wide: wide),
                                    if (wide)
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        spacing: 24,
                                        children: [
                                          Expanded(child: background),
                                          Expanded(child: work),
                                        ],
                                      )
                                    else ...[
                                      background,
                                      work,
                                    ],
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEducation(MemberProfile profile) {
    final duration = _motion(context, 210);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 10,
      children: [
        const _Heading('Academic qualifications'),
        for (final (index, qualification) in profile.qualifications.indexed)
          _qualificationBlock(qualification, index, duration),
      ],
    );
  }

  Widget _qualificationBlock(
    String qualification,
    int index,
    Duration duration,
  ) {
    final (title, detail) = _split(qualification, '\n');
    final expanded = _expandedQualification == index;
    final detailPanel = expanded
        ? Padding(
            padding: const EdgeInsets.only(top: 6, right: 5),
            child: _Sheet(
              color: _paper,
              offset: 0,
              padding: const EdgeInsets.all(14),
              child: Text(detail),
            ),
          )
        : const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PressSurface(
          label: title,
          color: expanded ? _yellow : _paper,
          expanded: expanded,
          onPressed: () {
            setState(() => _expandedQualification = expanded ? null : index);
          },
          child: Row(
            spacing: 12,
            children: [
              Expanded(child: Text(title, style: _strong)),
              AnimatedRotation(
                turns: expanded ? .5 : 0,
                duration: duration,
                child: const Icon(Icons.expand_more, color: _ink, size: 22),
              ),
            ],
          ),
        ),
        if (duration == Duration.zero)
          detailPanel
        else
          AnimatedSize(
            duration: duration,
            alignment: Alignment.topCenter,
            curve: Curves.easeOutCubic,
            child: detailPanel,
          ),
      ],
    );
  }

  Widget _buildSkills(MemberProfile profile) {
    final groups = [
      for (final skill in profile.softSkills) _split(skill, ': '),
    ];
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final selectedSkill = Text(
      groups[_selectedSkill].$2,
      key: ValueKey(_selectedSkill),
    );
    final detailPanel = _Sheet(
      color: _paper,
      offset: 0,
      padding: const EdgeInsets.all(13),
      child: Semantics(
        liveRegion: true,
        child: reduceMotion
            ? selectedSkill
            : AnimatedSwitcher(
                duration: const Duration(milliseconds: 160),
                layoutBuilder: (current, previous) => Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    for (final child in previous)
                      ExcludeSemantics(child: child),
                    ?current,
                  ],
                ),
                child: selectedSkill,
              ),
      ),
    );

    return _Sheet(
      color: _blue,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 14,
        children: [
          const _Heading('Technical skills', color: _paper),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final (index, (label, _)) in groups.indexed)
                _PressSurface(
                  label: label,
                  color: index == _selectedSkill ? _yellow : _paper,
                  selected: index == _selectedSkill,
                  onPressed: () => setState(() => _selectedSkill = index),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 6,
                    children: [
                      Flexible(child: Text(label, style: _strong)),
                      Icon(
                        index == _selectedSkill
                            ? Icons.check
                            : Icons.chevron_right,
                        color: _ink,
                        size: 18,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          if (reduceMotion)
            detailPanel
          else
            AnimatedSize(
              alignment: Alignment.topLeft,
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              child: detailPanel,
            ),
        ],
      ),
    );
  }
}

class _Poster extends StatelessWidget {
  const _Poster({required this.profile, required this.wide});

  final MemberProfile profile;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    return _Sheet(
      color: _yellow,
      borderWidth: 4,
      offset: 7,
      padding: const EdgeInsets.all(12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final art = AspectRatio(
            aspectRatio: wide ? 1.45 : 1.24,
            child: LayoutBuilder(
              builder: (context, artwork) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    const CustomPaint(painter: _PosterGrid()),
                    Positioned(
                      left: 0,
                      top: artwork.maxHeight * .13,
                      bottom: artwork.maxHeight * .16,
                      width: artwork.maxWidth * .55,
                      child: Semantics(
                        label: 'Member ${profile.number}',
                        excludeSemantics: true,
                        child: _Sheet(
                          color: _blue,
                          borderWidth: 4,
                          padding: EdgeInsets.only(
                            left: 4,
                            right: artwork.maxWidth * .085,
                          ),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              profile.number,
                              textScaler: TextScaler.noScaling,
                              style: _display.copyWith(
                                color: _paper,
                                fontSize: 180,
                                letterSpacing: -12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 5,
                      top: 8,
                      bottom: 8,
                      width: artwork.maxWidth * .52,
                      child: _Sheet(
                        color: _paper,
                        borderWidth: 4,
                        offset: 5,
                        padding: const EdgeInsets.all(3),
                        child: ClipRect(child: MemberPhoto(profile: profile)),
                      ),
                    ),
                  ],
                );
              },
            ),
          );

          final name = TweenAnimationBuilder<double>(
            duration: _motion(context, 420),
            curve: Curves.easeOutCubic,
            tween: Tween(begin: 0, end: 1),
            builder: (context, progress, child) {
              return Transform.translate(
                offset: Offset(0, 8 * (1 - progress)),
                child: Opacity(opacity: .72 + .28 * progress, child: child),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  Semantics(
                    header: true,
                    child: Text(
                      profile.fullName,
                      style: _display.copyWith(
                        fontSize: wide
                            ? 76
                            : (constraints.maxWidth * .16).clamp(34.0, 70.0),
                      ),
                    ),
                  ),
                  ColoredBox(
                    color: _ink,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      child: Text(
                        'AI/ML & BACKEND DEVELOPER',
                        style: _label.copyWith(color: _paper),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );

          if (wide) {
            return Row(
              spacing: 18,
              children: [
                Expanded(flex: 5, child: name),
                Expanded(flex: 6, child: art),
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 12,
            children: [art, name],
          );
        },
      ),
    );
  }
}

class _PosterGrid extends CustomPainter {
  const _PosterGrid();

  @override
  void paint(Canvas canvas, Size size) {
    const step = 22.0;
    final paint = Paint()..color = const Color(0x24000000);
    for (var x = 0.0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_PosterGrid oldDelegate) => false;
}

class _ContactPanel extends StatelessWidget {
  const _ContactPanel({required this.profile});

  final MemberProfile profile;

  @override
  Widget build(BuildContext context) {
    final details = [
      ('INDEX NO.', profile.studentId),
      ('ADDRESS', profile.address),
      ('PHONE', '+94 72 281 1725'),
      ('EMAIL', profile.email),
      ('GITHUB', 'github.com/managedulan'),
    ];

    return _Sheet(
      color: _paper,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ColoredBox(
            color: _ink,
            child: Padding(
              padding: EdgeInsets.fromLTRB(14, 8, 14, 11),
              child: _Heading('Contact', color: _paper),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: SelectionArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final (index, (label, value)) in details.indexed) ...[
                    if (index > 0)
                      const Divider(color: _ink, height: 19, thickness: 1),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 2,
                      children: [
                        Text(label, style: _label),
                        Text(value, style: _strong),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CareerPanel extends StatelessWidget {
  const _CareerPanel();

  @override
  Widget build(BuildContext context) {
    return const _Sheet(
      color: _yellow,
      padding: EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [_Heading('Career objective'), Text(_careerObjective)],
      ),
    );
  }
}

class _ProjectPanels extends StatelessWidget {
  const _ProjectPanels({required this.profile});

  final MemberProfile profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 11,
      children: [
        const _Heading('Projects'),
        _Sheet(
          color: _ink,
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5,
            children: [
              Text(
                'MicroLink',
                style: _display.copyWith(color: _yellow, fontSize: 40),
              ),
              Text(
                'AI & GPS Powered Smart Micro Business Discovery, '
                'Navigation and Delivery Support System',
                style: _strong.copyWith(color: _paper),
              ),
              Text(
                'AI/ML Engineer (University Group Project) · 2026',
                style: _copy.copyWith(color: _paper),
              ),
            ],
          ),
        ),
        for (final (index, contribution) in profile.specialTalents.indexed)
          _buildContribution(contribution, featured: index == 0),
      ],
    );
  }

  Widget _buildContribution(String contribution, {required bool featured}) {
    final (title, detail) = _split(contribution, '\n');

    return _Sheet(
      color: featured ? _yellow : _paper,
      offset: 4,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(left: BorderSide(color: _blue, width: 8)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(19, 12, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5,
            children: [
              Semantics(
                header: true,
                child: Text(title, style: _display.copyWith(fontSize: 22)),
              ),
              Text(detail),
            ],
          ),
        ),
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.title, {this.color = _ink});

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Text(title, style: _display.copyWith(fontSize: 26, color: color)),
    );
  }
}

class _Sheet extends StatelessWidget {
  const _Sheet({
    required this.color,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.borderWidth = 3,
    this.offset = 5,
  });

  final Color color;
  final Widget child;
  final EdgeInsets padding;
  final double borderWidth;
  final double offset;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: offset, bottom: offset),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: _ink, width: borderWidth),
          boxShadow: [
            if (offset > 0)
              BoxShadow(color: _ink, offset: Offset(offset, offset)),
          ],
        ),
        child: child,
      ),
    );
  }
}

class _PressSurface extends StatefulWidget {
  const _PressSurface({
    required this.label,
    required this.color,
    required this.onPressed,
    required this.child,
    this.selected,
    this.expanded,
    this.padding = const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
  });

  final String label;
  final Color color;
  final VoidCallback onPressed;
  final Widget child;
  final bool? selected;
  final bool? expanded;
  final EdgeInsets padding;

  @override
  State<_PressSurface> createState() => _PressSurfaceState();
}

class _PressSurfaceState extends State<_PressSurface> {
  bool _pressed = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    const offset = 5.0;
    return Semantics(
      button: true,
      label: widget.label,
      selected: widget.selected,
      expanded: widget.expanded,
      onTap: widget.onPressed,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: widget.onPressed,
          onHighlightChanged: (pressed) => setState(() => _pressed = pressed),
          onFocusChange: (focused) => setState(() => _focused = focused),
          excludeFromSemantics: true,
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          splashFactory: NoSplash.splashFactory,
          child: Stack(
            children: [
              const Positioned.fill(
                left: offset,
                top: offset,
                child: ColoredBox(color: _ink),
              ),
              AnimatedPadding(
                padding: _pressed
                    ? const EdgeInsets.only(left: offset, top: offset)
                    : const EdgeInsets.only(right: offset, bottom: offset),
                duration: _motion(context, 95),
                curve: Curves.easeOutCubic,
                child: AnimatedContainer(
                  duration: _motion(context, 160),
                  curve: Curves.easeOutCubic,
                  color: widget.color,
                  foregroundDecoration: BoxDecoration(
                    border: Border.all(color: _ink, width: _focused ? 5 : 3),
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 48,
                      minHeight: 48,
                    ),
                    child: Padding(
                      padding: widget.padding,
                      child: ExcludeSemantics(child: widget.child),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

(String, String) _split(String value, String separator) {
  final index = value.indexOf(separator);
  if (index == -1) return (value, '');
  return (value.substring(0, index), value.substring(index + separator.length));
}

Duration _motion(BuildContext context, int milliseconds) =>
    MediaQuery.disableAnimationsOf(context)
    ? Duration.zero
    : Duration(milliseconds: milliseconds);

const _paper = Color(0xFFFFFDF2);
const _yellow = Color(0xFFFFE34D);
const _blue = Color(0xFF3155FF);
const _ink = Colors.black;

const _display = TextStyle(
  color: _ink,
  fontSize: 34,
  fontWeight: FontWeight.w900,
  height: 1.04,
  letterSpacing: -1.0,
);
const _copy = TextStyle(color: _ink, fontSize: 15, height: 1.45);
const _strong = TextStyle(
  color: _ink,
  fontSize: 15,
  height: 1.28,
  fontWeight: FontWeight.w800,
);
const _label = TextStyle(
  color: _ink,
  fontSize: 12,
  letterSpacing: 1,
  fontWeight: FontWeight.w800,
);
