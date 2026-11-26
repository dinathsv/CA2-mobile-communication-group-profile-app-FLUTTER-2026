import 'package:flutter/material.dart';

import '../../../models/member_profile.dart';
import '../../../widgets/member_photo.dart';

const _blue = Color(0xFF315EF4);
const _ink = Color(0xFF1F2633);
const _mutedInk = Color(0xFF687181);
const _canvas = Color(0xFFF4F6F9);
const _mint = Color(0xFFE2F5ED);
const _lavender = Color(0xFFEDE9FB);
const _yellow = Color(0xFFFFF3D1);
const _educationCount = 5;

const _phoneNumber = '078-7409052';
const _linkedin = 'linkedin.com/in/Jinathma-Edirisinghe';

const _profileSummary =
    'Motivated Information Technology student currently pursuing the '
    'National Diploma in Technology (NDT) in Information Technology at the '
    'Institute of Technology, University of Moratuwa. Gained a strong '
    'interest in project management through academic projects and the final '
    'year project, and through that, is currently following a few project '
    'management courses. Highly interested in technology-driven project '
    'delivery, software solutions, stakeholder communication, and team '
    'coordination. Seeking an opportunity to apply technical knowledge and '
    'project management skills while contributing to innovative software and '
    'technology projects.';

final member05Profile = MemberProfile(
  id: 'member_05',
  fullName: 'EDIRISINGHE ARACHCHILAGE SACHINI JINATHMA EDIRISINGHE',
  studentId: '23IT0474',
  address: 'No: 136, Track 09, Katiyawa',
  email: 'jinathma19cmps@gmail.com',
  photoAsset: 'assets/members/member_05/portrait.png',
  qualifications: [
    'National Diploma in Technology (NDT) - Information Technology | Institute of Technology, University of Moratuwa | 2025-2027 (currently following)',
    'Foundations of Project Management | Coursera | currently following',
    'Agile Project Management | CODL, University of Moratuwa | currently following',
    'G.C.E. Advanced Level (A/L) | Central College, Anuradhapura, Sri Lanka | 2022',
    'G.C.E. Ordinary Level (O/L) | Central College, Anuradhapura, Sri Lanka | 2017',
    'Project Communication and Stakeholder Management | CODL, University of Moratuwa',
    'Project Scope and Schedule Management | CODL, University of Moratuwa',
    'Foundations of Project Management | CODL, University of Moratuwa',
    'Python for Beginners | CODL, University of Moratuwa',
    'Python Programming | CODL, University of Moratuwa',
    'Frontend Web Development | CODL, University of Moratuwa',
    'Server Side Web Programming | CODL, University of Moratuwa',
    'Introduction to Software Quality Assurance | CODL, University of Moratuwa',
  ],
  softSkills: [
    'Project planning',
    'Task coordination',
    'Scheduling',
    'Documentation',
    'Progress monitoring',
    'Team coordination',
    'Stakeholder communication',
  ],
  specialTalents: ['Add your special talents here'],
  designName: 'BENTO',
);

class Member05Screen extends StatefulWidget {
  const Member05Screen({super.key});

  @override
  State<Member05Screen> createState() => _Member05ScreenState();
}

class _Member05ScreenState extends State<Member05Screen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entranceController;
  bool _entranceStarted = false;

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
      _entranceController.value = 1;
    } else {
      _entranceController.forward();
    }
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  Animation<double> _entrance(int index) {
    final start = index * 0.075;
    final end = (start + 0.48).clamp(0.0, 1.0).toDouble();
    return _entranceController.drive(
      CurveTween(curve: Interval(start, end, curve: Curves.easeOutCubic)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = member05Profile;
    final textScale = MediaQuery.textScalerOf(context).scale(1);

    return Scaffold(
      backgroundColor: _canvas,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(
              profile: profile,
              onBack: () => Navigator.of(context).maybePop(),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final compact =
                      constraints.maxWidth < 820 || textScale > 1.25;
                  return SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      compact ? 16 : 28,
                      12,
                      compact ? 16 : 28,
                      36,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1120),
                        child: compact
                            ? _compactLayout(context, profile, constraints)
                            : _wideLayout(context, profile),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _compactLayout(
    BuildContext context,
    MemberProfile profile,
    BoxConstraints constraints,
  ) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final portraitHeight = (constraints.maxWidth * 0.88)
        .clamp(300.0, 450.0)
        .toDouble();
    final contactRow = constraints.maxWidth >= 520 && textScale <= 1.25;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _portraitTile(profile, height: portraitHeight, index: 0),
        const SizedBox(height: 14),
        _identityTile(profile, index: 1),
        const SizedBox(height: 14),
        if (contactRow)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(child: _emailTile(profile, index: 2)),
              const SizedBox(width: 12),
              Flexible(child: _addressTile(profile, index: 3)),
            ],
          )
        else ...[
          _emailTile(profile, index: 2),
          const SizedBox(height: 12),
          _addressTile(profile, index: 3),
        ],
        const SizedBox(height: 14),
        _qualificationTile(context, profile, index: 4),
        const SizedBox(height: 14),
        _aboutTile(index: 5),
        const SizedBox(height: 14),
        _softSkillsTile(profile, index: 6),
        const SizedBox(height: 14),
        _toolboxTile(index: 7),
        const SizedBox(height: 14),
        _specialTalentsTile(profile, index: 8),
        const SizedBox(height: 14),
        _projectTile(index: 9),
      ],
    );
  }

  Widget _wideLayout(BuildContext context, MemberProfile profile) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _portraitTile(profile, height: 510, index: 0),
              const SizedBox(height: 14),
              _identityTile(profile, index: 1),
              const SizedBox(height: 14),
              _specialTalentsTile(profile, index: 8),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Flexible(
          flex: 7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(child: _emailTile(profile, index: 2)),
                  const SizedBox(width: 12),
                  Flexible(child: _addressTile(profile, index: 3)),
                ],
              ),
              const SizedBox(height: 14),
              _qualificationTile(context, profile, index: 4),
              const SizedBox(height: 14),
              _aboutTile(index: 5),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(child: _softSkillsTile(profile, index: 6)),
                  const SizedBox(width: 12),
                  Flexible(child: _toolboxTile(index: 7)),
                ],
              ),
              const SizedBox(height: 14),
              _projectTile(index: 9),
            ],
          ),
        ),
      ],
    );
  }

  Widget _portraitTile(
    MemberProfile profile, {
    required double height,
    required int index,
  }) {
    return _entranceTile(
      index: index,
      child: _BentoSurface(
        padding: EdgeInsets.zero,
        child: SizedBox(
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              MemberPhoto(profile: profile),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.48, 1],
                    colors: [Colors.transparent, Color(0xA6000000)],
                  ),
                ),
              ),
              Positioned(
                left: 18,
                right: 18,
                bottom: 18,
                child: Row(
                  children: [
                    const Icon(
                      Icons.school_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'INFORMATION TECHNOLOGY',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    _Pill(
                      label: profile.studentId,
                      background: Colors.white.withValues(alpha: 0.2),
                      foreground: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _identityTile(MemberProfile profile, {required int index}) {
    return _entranceTile(
      index: index,
      child: _BentoSurface(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Eyebrow(label: 'MEMBER 05  /  NINE.'),
            const SizedBox(height: 12),
            Text(
              profile.fullName,
              style: const TextStyle(
                color: _ink,
                fontSize: 27,
                height: 1.12,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.8,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'IT Undergraduate  ·  Project Management  ·  Software Development',
              style: TextStyle(
                color: _mutedInk,
                fontSize: 14,
                height: 1.45,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emailTile(MemberProfile profile, {required int index}) {
    return _entranceTile(
      index: index,
      child: _BentoSurface(
        color: _lavender,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _TileHeading(
              icon: Icons.mail_outline_rounded,
              label: 'EMAIL',
              iconColor: _blue,
            ),
            const SizedBox(height: 18),
            SelectableText(
              profile.email,
              style: const TextStyle(
                color: _ink,
                fontSize: 15,
                height: 1.35,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'PHONE',
              style: TextStyle(
                color: _mutedInk,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 3),
            const SelectableText(
              _phoneNumber,
              style: TextStyle(
                color: _ink,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addressTile(MemberProfile profile, {required int index}) {
    return _entranceTile(
      index: index,
      child: _BentoSurface(
        color: _mint,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _TileHeading(
              icon: Icons.place_outlined,
              label: 'ADDRESS',
              iconColor: Color(0xFF25805B),
            ),
            const SizedBox(height: 18),
            Text(
              profile.address,
              style: const TextStyle(
                color: _ink,
                fontSize: 16,
                height: 1.4,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'LINKEDIN',
              style: TextStyle(
                color: _mutedInk,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 3),
            const SelectableText(
              _linkedin,
              style: TextStyle(
                color: _blue,
                fontSize: 12,
                height: 1.35,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _qualificationTile(
    BuildContext context,
    MemberProfile profile, {
    required int index,
  }) {
    return _entranceTile(
      index: index,
      child: _BentoSurface(
        color: _yellow,
        onTap: () => _showQualifications(context, profile),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.72),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.auto_stories_rounded,
                color: Color(0xFF88600E),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ACADEMICS',
                    style: TextStyle(
                      color: _mutedInk,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Learning in progress',
                    style: TextStyle(
                      color: _ink,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profile.qualifications.first,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _mutedInk,
                      fontSize: 13,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      Text(
                        'View all education & certificates',
                        style: TextStyle(
                          color: _blue,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_rounded, color: _blue, size: 15),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _aboutTile({required int index}) {
    return _entranceTile(
      index: index,
      child: _BentoSurface(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _TileHeading(
              icon: Icons.notes_rounded,
              label: 'A LITTLE ABOUT ME',
              iconColor: _blue,
            ),
            const SizedBox(height: 14),
            const Text(
              _profileSummary,
              style: TextStyle(color: _mutedInk, fontSize: 14, height: 1.55),
            ),
          ],
        ),
      ),
    );
  }

  Widget _softSkillsTile(MemberProfile profile, {required int index}) {
    return _entranceTile(
      index: index,
      child: _SoftSkillsTile(skills: profile.softSkills),
    );
  }

  Widget _toolboxTile({required int index}) {
    const tools = [
      'HTML',
      'CSS',
      'JavaScript fundamentals',
      'Java',
      'Web development',
      'Software development',
      'GitHub',
      'Jira',
      'MySQL',
      'Git',
    ];

    return _entranceTile(
      index: index,
      child: _BentoSurface(
        color: _lavender,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _TileHeading(
              icon: Icons.terminal_rounded,
              label: 'TOOLBOX',
              iconColor: _blue,
            ),
            const SizedBox(height: 15),
            Wrap(
              spacing: 7,
              runSpacing: 7,
              children: [
                for (final tool in tools)
                  _Pill(
                    label: tool,
                    background: Colors.white.withValues(alpha: 0.8),
                    foreground: _ink,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _specialTalentsTile(MemberProfile profile, {required int index}) {
    return _entranceTile(
      index: index,
      child: _BentoSurface(
        color: _yellow,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _TileHeading(
              icon: Icons.auto_awesome_rounded,
              label: 'SPECIAL TALENTS',
              iconColor: Color(0xFF88600E),
            ),
            const SizedBox(height: 14),
            Text(
              profile.specialTalents.first,
              style: const TextStyle(
                color: _ink,
                fontSize: 16,
                height: 1.4,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'This placeholder is ready to be replaced with your details.',
              style: TextStyle(color: _mutedInk, fontSize: 13, height: 1.45),
            ),
          ],
        ),
      ),
    );
  }

  Widget _projectTile({required int index}) {
    return _entranceTile(
      index: index,
      child: _BentoSurface(
        color: _mint,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _TileHeading(
              icon: Icons.science_outlined,
              label: 'FEATURED PROJECT  /  FINAL YEAR RESEARCH',
              iconColor: Color(0xFF25805B),
            ),
            const SizedBox(height: 13),
            const Text(
              'Smart Agricultural Machinery Testing & Planning System',
              style: TextStyle(
                color: _ink,
                fontSize: 19,
                height: 1.25,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Developed the end-to-end Technical Assistant Resource '
              'Management module, independently handling frontend and backend '
              'development to streamline staff allocation and scheduling for '
              'agricultural machinery testing. Designed interactive interfaces '
              'and backend workflows for evaluating, scheduling, and tracking '
              'technical assistant workflows at the Farm Machinery Research '
              'Centre (FMRC). Integrated MySQL database operations and API '
              'endpoints to manage resource availability, task assignments, '
              'and operational data logging.',
              style: TextStyle(color: _mutedInk, fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 13),
            Wrap(
              spacing: 7,
              runSpacing: 7,
              children: [
                _Pill(
                  label: 'Full-stack development',
                  background: Colors.white.withValues(alpha: 0.8),
                  foreground: _ink,
                ),
                _Pill(
                  label: 'MySQL',
                  background: Colors.white.withValues(alpha: 0.8),
                  foreground: _ink,
                ),
                _Pill(
                  label: 'Git',
                  background: Colors.white.withValues(alpha: 0.8),
                  foreground: _ink,
                ),
              ],
            ),
            const SizedBox(height: 12),
            const SelectableText(
              'GitHub: github.com/thanusha-bandara/fmrc',
              style: TextStyle(
                color: _blue,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _entranceTile({required int index, required Widget child}) {
    final animation = _entrance(index);
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: animation.drive(
          Tween<Offset>(begin: const Offset(0, 0.045), end: Offset.zero),
        ),
        child: child,
      ),
    );
  }

  Future<void> _showQualifications(
    BuildContext context,
    MemberProfile profile,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.88,
        child: _QualificationsSheet(profile: profile),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.profile, required this.onBack});

  final MemberProfile profile;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 20, 4),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Back',
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded),
            color: _ink,
          ),
          const SizedBox(width: 4),
          const Text(
            'NINE.',
            style: TextStyle(
              color: _ink,
              fontSize: 17,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.7,
            ),
          ),
          const SizedBox(width: 9),
          const Text(
            '/',
            style: TextStyle(color: Color(0xFFB6BCC6), fontSize: 18),
          ),
          const SizedBox(width: 9),
          Text(
            'MEMBER ${profile.number}',
            style: const TextStyle(
              color: _mutedInk,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          const Spacer(),
          _Pill(
            label: profile.designName,
            background: _blue,
            foreground: Colors.white,
          ),
        ],
      ),
    );
  }
}

class _BentoSurface extends StatefulWidget {
  const _BentoSurface({
    required this.child,
    this.color = Colors.white,
    this.padding = const EdgeInsets.all(20),
    this.onTap,
  });

  final Widget child;
  final Color color;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  State<_BentoSurface> createState() => _BentoSurfaceState();
}

class _BentoSurfaceState extends State<_BentoSurface> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _pressed ? 0.985 : 1,
      duration: const Duration(milliseconds: 130),
      curve: Curves.easeOut,
      child: Material(
        color: widget.color,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: widget.onTap,
          onHighlightChanged: (pressed) {
            if (widget.onTap == null || _pressed == pressed) return;
            setState(() => _pressed = pressed);
          },
          child: Padding(padding: widget.padding, child: widget.child),
        ),
      ),
    );
  }
}

class _SoftSkillsTile extends StatefulWidget {
  const _SoftSkillsTile({required this.skills});

  final List<String> skills;

  @override
  State<_SoftSkillsTile> createState() => _SoftSkillsTileState();
}

class _SoftSkillsTileState extends State<_SoftSkillsTile> {
  final Set<String> _selectedSkills = {};

  @override
  Widget build(BuildContext context) {
    return _BentoSurface(
      color: _mint,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TileHeading(
            icon: Icons.groups_2_outlined,
            label: 'SOFT SKILLS',
            iconColor: Color(0xFF25805B),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap to highlight',
            style: TextStyle(color: _mutedInk, fontSize: 12),
          ),
          const SizedBox(height: 13),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final skill in widget.skills)
                _SkillChip(
                  label: skill,
                  selected: _selectedSkills.contains(skill),
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
        ],
      ),
    );
  }
}

class _SkillChip extends StatelessWidget {
  const _SkillChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      toggled: selected,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: selected ? _blue : Colors.white.withValues(alpha: 0.78),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: selected ? _blue : const Color(0xFFDCE4E0),
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : _ink,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _QualificationsSheet extends StatelessWidget {
  const _QualificationsSheet({required this.profile});

  final MemberProfile profile;

  @override
  Widget build(BuildContext context) {
    final education = profile.qualifications.take(_educationCount);
    final certifications = profile.qualifications.skip(_educationCount);

    return Container(
      decoration: const BoxDecoration(
        color: _canvas,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 18, 14, 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'LEARNING JOURNEY',
                        style: TextStyle(
                          color: _blue,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Education & certificates',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: _ink,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Close',
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E6EC)),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Eyebrow(label: 'EDUCATION'),
                  const SizedBox(height: 12),
                  for (final qualification in education)
                    _QualificationEntry(text: qualification),
                  const SizedBox(height: 20),
                  const _Eyebrow(label: 'CERTIFICATIONS'),
                  const SizedBox(height: 12),
                  for (final qualification in certifications)
                    _QualificationEntry(text: qualification),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QualificationEntry extends StatelessWidget {
  const _QualificationEntry({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Icon(Icons.check_circle_outline, color: _blue, size: 18),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: _ink,
                  fontSize: 14,
                  height: 1.45,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Eyebrow extends StatelessWidget {
  const _Eyebrow({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: _mutedInk,
        fontSize: 10,
        fontWeight: FontWeight.w800,
        letterSpacing: 1,
      ),
    );
  }
}

class _TileHeading extends StatelessWidget {
  const _TileHeading({
    required this.icon,
    required this.label,
    required this.iconColor,
  });

  final IconData icon;
  final String label;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 17, color: iconColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: _mutedInk,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.9,
            ),
          ),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: foreground,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
