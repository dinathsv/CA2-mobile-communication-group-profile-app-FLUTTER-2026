import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../models/member_profile.dart';
import '../../../widgets/member_photo.dart';

final member02Profile = MemberProfile(
  id: 'member_02',
  fullName: 'Hamas Akram',
  studentId: '23IT0479',
  address: 'Colombo, Sri Lanka',
  email: 'hamasakram2003@gmail.com',
  photoAsset: 'assets/members/member_02/portrait.png',
  qualifications: const [
    'NDT in Information Technology - Institute of Technology, University of Moratuwa (2025-2027)',
    'GCE Advanced Level - Combined Mathematics, Chemistry and Physics (2020-2023)',
  ],
  softSkills: const [
    'Problem Solving',
    'Attention to Detail',
    'Logical Thinking',
    'Creativity',
    'Teamwork & Communication',
    'Quick Learner',
    'Adaptability',
    'Time Management',
    'Independent Working',
    'Meeting Deadlines',
  ],
  specialTalents: const [
    'Full-stack development across frontend and backend',
    'Building practical, real-world software applications',
    'Debugging and finding practical solutions',
    'User-focused UI/UX design',
    'Care for code quality, data accuracy, and validation',
    'Learning new tools and frameworks quickly',
  ],
  designName: 'TERMINAL',
);

class Member02Screen extends StatefulWidget {
  const Member02Screen({super.key});

  @override
  State<Member02Screen> createState() => _Member02ScreenState();
}

class _Member02ScreenState extends State<Member02Screen>
    with TickerProviderStateMixin {
  static const _background = Color(0xFF0B0F0D);
  static const _panel = Color(0xFF111713);
  static const _panelRaised = Color(0xFF151D18);
  static const _accent = Color(0xFF39FF88);
  static const _text = Color(0xFFE7F0E9);
  static const _muted = Color(0xFF89968D);
  static const _border = Color(0xFF27352C);
  static const _mono = 'monospace';
  static const _professionalTitle =
      'IT Undergraduate | Software Engineering & Full-Stack Developer | AI/ML Enthusiast';
  static const _profileSummary =
      'Motivated IT undergraduate passionate about software development and practical applications. '
      'Experienced with Python, Java, JavaScript, React.js, Spring Boot, MySQL, and MongoDB, '
      'with foundational UI/UX design knowledge. Seeking a Software Engineering internship '
      'to grow technical expertise and contribute to a development team.';
  static const _phone = '+94 77 0795463';
  static const _contactLinks = <(String, String)>[
    ('LINKEDIN', 'linkedin.com/in/hamas-akram-379a78241/'),
    ('GITHUB', 'github.com/HamasAkram03'),
    ('PORTFOLIO', 'hamas-akram-portfolio.vercel.app'),
  ];
  static const _certifications = <(String, String)>[
    ('AI/ML Engineer - Stage 1', 'SLIIT Uni | 2026'),
    ('Python Programming', 'CODL, University of Moratuwa | 2025'),
    ('Version Control', 'Coursera | 2026'),
    ('JavaScript Essentials 1', 'Cisco Networking Academy | 2026'),
  ];
  static const _technicalSkillGroups = <(String, String)>[
    ('LANGUAGES', 'Java, JavaScript, Python, PHP, HTML, CSS'),
    ('FRONTEND', 'React.js, HTML5, CSS3, JavaScript, Bootstrap, Tailwind CSS'),
    ('BACKEND', 'Spring Boot, Node.js, Express.js, PHP'),
    ('DATABASE', 'MySQL, MongoDB'),
    ('DESIGN', 'Figma, Canva, UI/UX Design, Wireframing, Prototyping'),
    ('TOOLS', 'Git, GitHub, VS Code, NetBeans, Postman'),
    (
      'CONCEPTS',
      'OOP, REST APIs, Full-Stack Development, Responsive Design, SDLC, Database Management',
    ),
  ];
  static const _spokenLanguages =
      'English - Professional\nSinhala - Professional\nTamil - Native';
  static const _projects = <(String, String, String, String)>[
    (
      'SeettuManager',
      'Java, Spring Boot, React, MySQL',
      'Rotating savings management for groups, members, contributions, payments, and financial records, with role-based access.',
      'github.com/AJRaaef/seetu_manager',
    ),
    (
      'Pharmacy Management System',
      'HTML, PHP, JavaScript, MySQL',
      'Medicine tracking, inventory and supplier management, sales processing, and stock availability.',
      'github.com/Mohamed-Asriff/Pharmacy-Management-System',
    ),
    (
      'UniVerse Events Management System',
      'HTML, CSS, PHP, JavaScript, MySQL',
      'Responsive university event discovery, event details, registrations, and participant management.',
      'github.com/HamasAkram03/event-management-system-',
    ),
    (
      'Inventory Management System',
      'Spring Boot, React, MySQL',
      'Full-stack inventory tracking with stock monitoring, transactions, product catalog, and low-stock alerts.',
      'github.com/reezmahanan/SCM-IMS',
    ),
    (
      'Portfolio Website',
      'React, Vite, Tailwind CSS',
      'Responsive portfolio presenting profile, skills, services, projects, and contact information.',
      'Portfolio: hamas-akram-portfolio.vercel.app\nGitHub: github.com/HamasAkram03/Hamas_Akram_Portfolio',
    ),
  ];

  static const _tabs = ['ABOUT', 'EDUCATION', 'SKILLS'];

  late final AnimationController _entranceController;
  late final AnimationController _cursorController;
  late final Animation<double> _entranceOpacity;
  late final Animation<Offset> _entranceOffset;
  int _selectedTab = 0;
  final Set<String> _selectedSkills = {};

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    _entranceOpacity = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOut,
    );
    _entranceOffset =
        Tween<Offset>(begin: const Offset(0, 0.035), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: Curves.easeOutCubic,
          ),
        );
    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _cursorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = member02Profile;
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Column(
          children: [
            _buildNavigationHeader(context, profile),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: FadeTransition(
                      opacity: _entranceOpacity,
                      child: SlideTransition(
                        position: _entranceOffset,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildIdentityCard(profile),
                            const SizedBox(height: 24),
                            _buildTabs(),
                            const SizedBox(height: 18),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 260),
                              reverseDuration: const Duration(
                                milliseconds: 180,
                              ),
                              switchInCurve: Curves.easeOutCubic,
                              switchOutCurve: Curves.easeInCubic,
                              transitionBuilder: (child, animation) {
                                final slide = Tween<Offset>(
                                  begin: const Offset(0, 0.025),
                                  end: Offset.zero,
                                ).animate(animation);
                                return FadeTransition(
                                  opacity: animation,
                                  child: SlideTransition(
                                    position: slide,
                                    child: child,
                                  ),
                                );
                              },
                              child: KeyedSubtree(
                                key: ValueKey(_selectedTab),
                                child: _buildTabContent(profile),
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildFooter(profile),
                          ],
                        ),
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

  Widget _buildNavigationHeader(BuildContext context, MemberProfile profile) {
    return Container(
      height: 62,
      decoration: const BoxDecoration(
        color: _panel,
        border: Border(bottom: BorderSide(color: _border)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Go back',
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back_rounded),
            color: _text,
            iconSize: 20,
          ),
          const SizedBox(width: 4),
          const Text(
            AppTheme.appName,
            style: TextStyle(
              color: _accent,
              fontFamily: _mono,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(width: 14),
          Container(width: 1, height: 18, color: _border),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'MEMBERS / ${profile.id.toUpperCase()}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _muted,
                fontFamily: _mono,
                fontSize: 11,
                letterSpacing: 0.7,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'TERMINAL',
            style: TextStyle(
              color: _muted,
              fontFamily: _mono,
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdentityCard(MemberProfile profile) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _panel,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final portraitSize = constraints.maxWidth < 400 ? 88.0 : 112.0;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: portraitSize + 6,
                height: portraitSize + 6,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: _accent.withValues(alpha: 0.55)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(11),
                  child: MemberPhoto(profile: profile, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          r'$ whoami',
                          style: TextStyle(
                            color: _accent,
                            fontFamily: _mono,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 6),
                        FadeTransition(
                          opacity: _cursorController,
                          child: Container(
                            width: 7,
                            height: 14,
                            color: _accent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Semantics(
                      header: true,
                      child: Text(
                        profile.fullName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _text,
                          fontSize: 25,
                          height: 1.1,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      _professionalTitle,
                      softWrap: true,
                      style: const TextStyle(
                        color: _text,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      'MEMBER ${profile.number}  /  ${profile.designName}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _muted,
                        fontFamily: _mono,
                        fontSize: 10,
                        letterSpacing: 0.65,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTabs() {
    return Semantics(
      label: 'Profile sections',
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: _panel,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _border),
        ),
        child: Row(
          children: List.generate(_tabs.length, (index) {
            final selected = _selectedTab == index;
            return Expanded(
              child: Semantics(
                button: true,
                selected: selected,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: TextButton(
                    onPressed: () => setState(() => _selectedTab = index),
                    style: TextButton.styleFrom(
                      minimumSize: const Size(0, 42),
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      foregroundColor: selected ? _accent : _muted,
                      backgroundColor: selected
                          ? _accent.withValues(alpha: 0.09)
                          : Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                        side: BorderSide(
                          color: selected
                              ? _accent.withValues(alpha: 0.25)
                              : Colors.transparent,
                        ),
                      ),
                    ),
                    child: Text(
                      _tabs[index],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: _mono,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.55,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildTabContent(MemberProfile profile) {
    switch (_selectedTab) {
      case 0:
        return _buildAbout(profile);
      case 1:
        return _buildEducation(profile);
      default:
        return _buildSkills(profile);
    }
  }

  Widget _buildAbout(MemberProfile profile) {
    final details = <(String, String, IconData)>[
      ('FULL NAME', profile.fullName, Icons.badge_outlined),
      ('STUDENT ID', profile.studentId, Icons.fingerprint_rounded),
      ('ADDRESS', profile.address, Icons.location_on_outlined),
      ('EMAIL', profile.email, Icons.alternate_email_rounded),
      ('PHONE', _phone, Icons.phone_outlined),
    ];

    return Column(
      key: const ValueKey('about-content'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionLabel('IDENTITY / DETAILS'),
        const SizedBox(height: 10),
        _panelCard(
          child: Column(
            children: [
              for (var index = 0; index < details.length; index++) ...[
                _detailRow(
                  details[index].$1,
                  details[index].$2,
                  details[index].$3,
                ),
                if (index != details.length - 1)
                  const Divider(height: 22, color: _border),
              ],
            ],
          ),
        ),
        const SizedBox(height: 22),
        _sectionLabel('PROFILE / SUMMARY'),
        const SizedBox(height: 10),
        _panelCard(
          child: Text(
            _profileSummary,
            style: const TextStyle(color: _text, fontSize: 14, height: 1.55),
          ),
        ),
        const SizedBox(height: 22),
        _sectionLabel('ONLINE / CONTACT'),
        const SizedBox(height: 10),
        _panelCard(
          child: Column(
            children: [
              for (var index = 0; index < _contactLinks.length; index++) ...[
                _detailRow(
                  _contactLinks[index].$1,
                  _contactLinks[index].$2,
                  Icons.open_in_new_rounded,
                ),
                if (index != _contactLinks.length - 1)
                  const Divider(height: 22, color: _border),
              ],
            ],
          ),
        ),
        const SizedBox(height: 22),
        _sectionLabel('SPECIAL TALENTS / STRENGTHS'),
        const SizedBox(height: 10),
        _panelCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final talent in profile.specialTalents)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 2, right: 10),
                        child: Icon(
                          Icons.chevron_right_rounded,
                          size: 18,
                          color: _accent,
                        ),
                      ),
                      Expanded(child: _valueText(talent)),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        _sectionLabel('PROJECTS / SELECTED WORK'),
        const SizedBox(height: 10),
        for (var index = 0; index < _projects.length; index++) ...[
          _projectCard(_projects[index]),
          if (index != _projects.length - 1) const SizedBox(height: 10),
        ],
      ],
    );
  }

  Widget _buildEducation(MemberProfile profile) {
    return Column(
      key: const ValueKey('education-content'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionLabel('ACADEMIC RECORD / OUTPUT'),
        const SizedBox(height: 10),
        _panelCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (
                var index = 0;
                index < profile.qualifications.length;
                index++
              )
                _qualificationRow(
                  index + 1,
                  profile.qualifications[index],
                  isLast: index == profile.qualifications.length - 1,
                ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        _sectionLabel('CERTIFICATIONS / PROFESSIONAL DEVELOPMENT'),
        const SizedBox(height: 10),
        _panelCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var index = 0; index < _certifications.length; index++)
                _qualificationRow(
                  index + 1,
                  '${_certifications[index].$1}\n${_certifications[index].$2}',
                  isLast: index == _certifications.length - 1,
                  kind: 'CERTIFICATION',
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSkills(MemberProfile profile) {
    return Column(
      key: const ValueKey('skills-content'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionLabel('SOFT SKILLS / SELECT TO PIN'),
        const SizedBox(height: 10),
        _panelCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 9,
                runSpacing: 9,
                children: profile.softSkills.map((skill) {
                  final selected = _selectedSkills.contains(skill);
                  return FilterChip(
                    label: Text(skill),
                    selected: selected,
                    showCheckmark: false,
                    onSelected: (value) {
                      setState(() {
                        if (value) {
                          _selectedSkills.add(skill);
                        } else {
                          _selectedSkills.remove(skill);
                        }
                      });
                    },
                    backgroundColor: _panelRaised,
                    selectedColor: _accent.withValues(alpha: 0.12),
                    side: BorderSide(color: selected ? _accent : _border),
                    labelStyle: TextStyle(
                      color: selected ? _accent : _text,
                      fontFamily: _mono,
                      fontSize: 12,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              const Text(
                'Tap a chip to toggle its selection.',
                style: TextStyle(
                  color: _muted,
                  fontFamily: _mono,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        _sectionLabel('TECHNICAL SKILLS'),
        const SizedBox(height: 10),
        _panelCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (
                var index = 0;
                index < _technicalSkillGroups.length;
                index++
              ) ...[
                _detailRow(
                  _technicalSkillGroups[index].$1,
                  _technicalSkillGroups[index].$2,
                  Icons.code_rounded,
                ),
                if (index != _technicalSkillGroups.length - 1)
                  const Divider(height: 22, color: _border),
              ],
            ],
          ),
        ),
        const SizedBox(height: 22),
        _sectionLabel('LANGUAGES'),
        const SizedBox(height: 10),
        _panelCard(
          child: Text(
            _spokenLanguages,
            style: const TextStyle(color: _text, fontSize: 14, height: 1.8),
          ),
        ),
      ],
    );
  }

  Widget _detailRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: _muted),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: _muted,
                  fontFamily: _mono,
                  fontSize: 10,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 5),
              _valueText(value),
            ],
          ),
        ),
      ],
    );
  }

  Widget _projectCard((String, String, String, String) project) {
    return _panelCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            project.$1,
            style: const TextStyle(
              color: _text,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            project.$2,
            style: const TextStyle(
              color: _accent,
              fontFamily: _mono,
              fontSize: 10,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            project.$3,
            style: const TextStyle(color: _text, fontSize: 13, height: 1.5),
          ),
          const Divider(height: 22, color: _border),
          SelectableText(
            project.$4,
            style: const TextStyle(
              color: _muted,
              fontFamily: _mono,
              fontSize: 10,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _qualificationRow(
    int number,
    String qualification, {
    required bool isLast,
    String kind = 'QUALIFICATION',
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 30,
            child: Column(
              children: [
                Container(
                  width: 9,
                  height: 9,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: _accent,
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: [
                      BoxShadow(
                        color: _accent.withValues(alpha: 0.2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      color: _border,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '0$number  /  $kind',
                    style: const TextStyle(
                      color: _muted,
                      fontFamily: _mono,
                      fontSize: 10,
                      letterSpacing: 0.55,
                    ),
                  ),
                  const SizedBox(height: 7),
                  _valueText(qualification),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: _accent,
        fontFamily: _mono,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.7,
      ),
    );
  }

  Widget _valueText(String value) {
    final placeholder = value.toLowerCase().contains('pending');
    return Text(
      value,
      softWrap: true,
      style: TextStyle(
        color: placeholder ? _muted : _text,
        fontSize: 14,
        height: 1.45,
        fontStyle: placeholder ? FontStyle.italic : FontStyle.normal,
      ),
    );
  }

  Widget _panelCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _panel,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: child,
    );
  }

  Widget _buildFooter(MemberProfile profile) {
    return Row(
      children: [
        const Icon(Icons.terminal_rounded, size: 15, color: _muted),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '${profile.designName}  /  MEMBER ${profile.number}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _muted,
              fontFamily: _mono,
              fontSize: 10,
              letterSpacing: 0.45,
            ),
          ),
        ),
        Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: _accent,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}
