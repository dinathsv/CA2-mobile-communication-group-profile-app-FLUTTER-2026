import 'package:flutter/material.dart';

import '../../../models/member_profile.dart';
import '../../../widgets/member_photo.dart';

// ---------------------------------------------------------------------------
// Profile data — placeholders preserved per CONTRIBUTING.md contract.
// ---------------------------------------------------------------------------
final member06Profile = MemberProfile(
  id: 'member_06',
  fullName: 'Placeholder Member 06',
  studentId: 'Student ID pending',
  address: 'Address pending',
  email: 'Email pending',
  photoAsset: 'assets/members/member_06/portrait.png',
  qualifications: const ['Qualifications pending'],
  softSkills: const ['Soft skills pending'],
  specialTalents: const ['Special talents pending'],
  designName: 'VOGUE',
);

// ---------------------------------------------------------------------------
// VOGUE colour palette
// ---------------------------------------------------------------------------
const _ivory = Color(0xFFFAF7F0);
const _burgundy = Color(0xFF6B1628);
const _richBlack = Color(0xFF1A1A1A);
const _captionGrey = Color(0xFF6E6E6E);
const _ruleColor = Color(0xFFD4CFC7);

// ---------------------------------------------------------------------------
// Member 06 — VOGUE editorial magazine screen
// ---------------------------------------------------------------------------
class Member06Screen extends StatefulWidget {
  const Member06Screen({super.key});

  @override
  State<Member06Screen> createState() => _Member06ScreenState();
}

class _Member06ScreenState extends State<Member06Screen>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _fadeController;
  int _currentPage = 0;
  static const _totalPages = 3;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _fadeController.value = 1;
    } else {
      _fadeController.forward();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    if (page < 0 || page >= _totalPages) return;
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    if (reducedMotion) {
      _pageController.jumpToPage(page);
    } else {
      _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = member06Profile;
    final reducedMotion = MediaQuery.disableAnimationsOf(context);

    return Scaffold(
      backgroundColor: _ivory,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ──────────────────────────────────────────────
            _VogueAppBar(
              profile: profile,
              onBack: () => Navigator.of(context).maybePop(),
            ),

            // ── Page content ─────────────────────────────────────────
            Expanded(
              child: FadeTransition(
                opacity: reducedMotion
                    ? const AlwaysStoppedAnimation(1)
                    : _fadeController,
                child: PageView(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  children: [
                    _CoverPage(profile: profile),
                    _IdentityPage(profile: profile),
                    _BeyondPage(profile: profile),
                  ],
                ),
              ),
            ),

            // ── Bottom navigation ────────────────────────────────────
            _VogueBottomNav(
              currentPage: _currentPage,
              totalPages: _totalPages,
              onPrevious: _currentPage > 0
                  ? () => _goToPage(_currentPage - 1)
                  : null,
              onNext: _currentPage < _totalPages - 1
                  ? () => _goToPage(_currentPage + 1)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
// Top app bar — minimal magazine masthead
// ===========================================================================
class _VogueAppBar extends StatelessWidget {
  const _VogueAppBar({required this.profile, required this.onBack});

  final MemberProfile profile;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Back',
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back, color: _richBlack, size: 22),
          ),
          const Spacer(),
          Text(
            profile.designName,
            style: const TextStyle(
              color: _burgundy,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 6,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 48), // balance the back button
        ],
      ),
    );
  }
}

// ===========================================================================
// Bottom navigation — page indicator + prev / next buttons
// ===========================================================================
class _VogueBottomNav extends StatelessWidget {
  const _VogueBottomNav({
    required this.currentPage,
    required this.totalPages,
    required this.onPrevious,
    required this.onNext,
  });

  final int currentPage;
  final int totalPages;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final reducedMotion = MediaQuery.disableAnimationsOf(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Row(
        children: [
          // Previous button
          _NavButton(
            label: 'PREV',
            icon: Icons.chevron_left,
            onPressed: onPrevious,
            iconFirst: true,
          ),

          const Spacer(),

          // Page indicators
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(totalPages, (index) {
              final isActive = index == currentPage;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Semantics(
                  label: 'Page ${index + 1} of $totalPages',
                  selected: isActive,
                  child: AnimatedContainer(
                    duration: reducedMotion
                        ? Duration.zero
                        : const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: isActive ? 24 : 8,
                    height: 3,
                    decoration: BoxDecoration(
                      color: isActive ? _burgundy : _ruleColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              );
            }),
          ),

          const Spacer(),

          // Next button
          _NavButton(
            label: 'NEXT',
            icon: Icons.chevron_right,
            onPressed: onNext,
            iconFirst: false,
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.iconFirst,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool iconFirst;

  @override
  Widget build(BuildContext context) {
    final color = onPressed != null ? _burgundy : _ruleColor;
    final children = [
      Icon(icon, size: 18, color: color),
      Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
      ),
    ];

    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Semantics(
        button: true,
        label: '$label page',
        enabled: onPressed != null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: iconFirst ? children : children.reversed.toList(),
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// PAGE 1 — COVER
// ===========================================================================
class _CoverPage extends StatelessWidget {
  const _CoverPage({required this.profile});

  final MemberProfile profile;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final nameSize = (screenWidth * 0.09).clamp(28.0, 52.0);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Caption above portrait
              const _EditorialCaption(text: '06 / PROFILE'),
              const SizedBox(height: 16),

              // Portrait — single Hero-enabled instance
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: MemberPhoto(profile: member06Profile),
                ),
              ),
              const SizedBox(height: 24),

              // Fine rule
              const _HorizontalRule(),
              const SizedBox(height: 20),

              // Oversized full name
              Semantics(
                header: true,
                child: Text(
                  profile.fullName.toUpperCase(),
                  style: TextStyle(
                    color: _richBlack,
                    fontSize: nameSize,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    height: 1.05,
                    fontFamily: 'Georgia',
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Design tagline
              Text(
                profile.designName,
                style: const TextStyle(
                  color: _burgundy,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 8,
                ),
              ),
              const SizedBox(height: 24),
              const _HorizontalRule(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// PAGE 2 — IDENTITY
// ===========================================================================
class _IdentityPage extends StatelessWidget {
  const _IdentityPage({required this.profile});

  final MemberProfile profile;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final headingSize = (screenWidth * 0.07).clamp(22.0, 36.0);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page number
              const _PageNumber(number: '02'),
              const SizedBox(height: 8),

              // Section heading
              Semantics(
                header: true,
                child: Text(
                  'IDENTITY',
                  style: TextStyle(
                    color: _richBlack,
                    fontSize: headingSize,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4,
                    fontFamily: 'Georgia',
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const _HorizontalRule(),
              const SizedBox(height: 28),

              // Full name
              _EditorialField(label: 'FULL NAME', value: profile.fullName),
              const SizedBox(height: 20),

              // Student ID
              _EditorialField(label: 'STUDENT ID', value: profile.studentId),
              const SizedBox(height: 20),

              // Address
              _EditorialField(label: 'ADDRESS', value: profile.address),
              const SizedBox(height: 20),

              // Email
              _EditorialField(label: 'EMAIL', value: profile.email),
              const SizedBox(height: 32),

              // Qualifications sub-section
              const _HorizontalRule(),
              const SizedBox(height: 24),
              const Text(
                'ACADEMIC QUALIFICATIONS',
                style: TextStyle(
                  color: _burgundy,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 20),

              for (var i = 0; i < profile.qualifications.length; i++) ...[
                _QualificationEntry(
                  index: i + 1,
                  text: profile.qualifications[i],
                ),
                if (i < profile.qualifications.length - 1)
                  const SizedBox(height: 14),
              ],

              const SizedBox(height: 32),
              const _HorizontalRule(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// PAGE 3 — BEYOND
// ===========================================================================
class _BeyondPage extends StatelessWidget {
  const _BeyondPage({required this.profile});

  final MemberProfile profile;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final headingSize = (screenWidth * 0.07).clamp(22.0, 36.0);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page number
              const _PageNumber(number: '03'),
              const SizedBox(height: 8),

              // Section heading
              Semantics(
                header: true,
                child: Text(
                  'BEYOND',
                  style: TextStyle(
                    color: _richBlack,
                    fontSize: headingSize,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4,
                    fontFamily: 'Georgia',
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const _HorizontalRule(),
              const SizedBox(height: 28),

              // Soft Skills
              const Text(
                'SOFT SKILLS',
                style: TextStyle(
                  color: _burgundy,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 20),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final skill in profile.softSkills)
                    _SkillChip(label: skill),
                ],
              ),

              const SizedBox(height: 36),
              const _HorizontalRule(),
              const SizedBox(height: 28),

              // Special Talents
              const Text(
                'SPECIAL TALENTS',
                style: TextStyle(
                  color: _burgundy,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 20),

              for (var i = 0; i < profile.specialTalents.length; i++) ...[
                _TalentEntry(index: i + 1, text: profile.specialTalents[i]),
                if (i < profile.specialTalents.length - 1)
                  const SizedBox(height: 16),
              ],

              const SizedBox(height: 36),
              const _HorizontalRule(),
              const SizedBox(height: 20),

              // Closing editorial mark
              Center(
                child: Text(
                  '— ${member06Profile.designName} —',
                  style: const TextStyle(
                    color: _captionGrey,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 6,
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// Shared editorial components
// ===========================================================================

/// Fine horizontal rule — magazine divider
class _HorizontalRule extends StatelessWidget {
  const _HorizontalRule();

  @override
  Widget build(BuildContext context) {
    return Container(height: 0.5, color: _ruleColor);
  }
}

/// Small page number caption
class _PageNumber extends StatelessWidget {
  const _PageNumber({required this.number});

  final String number;

  @override
  Widget build(BuildContext context) {
    return Text(
      number,
      style: const TextStyle(
        color: _captionGrey,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 2,
      ),
    );
  }
}

/// Editorial-style caption text
class _EditorialCaption extends StatelessWidget {
  const _EditorialCaption({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: _captionGrey,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 4,
      ),
    );
  }
}

/// Label-value field for identity details
class _EditorialField extends StatelessWidget {
  const _EditorialField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _captionGrey,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: _richBlack,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.5,
            fontFamily: 'Georgia',
          ),
        ),
      ],
    );
  }
}

/// Numbered qualification entry
class _QualificationEntry extends StatelessWidget {
  const _QualificationEntry({required this.index, required this.text});

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 28,
          child: Text(
            index.toString().padLeft(2, '0'),
            style: const TextStyle(
              color: _burgundy,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: _richBlack,
              fontSize: 15,
              fontWeight: FontWeight.w400,
              height: 1.6,
              fontFamily: 'Georgia',
            ),
          ),
        ),
      ],
    );
  }
}

/// Soft-skill chip with burgundy outline
class _SkillChip extends StatelessWidget {
  const _SkillChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: _burgundy, width: 0.5),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        child: Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: _richBlack,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}

/// Numbered talent entry with editorial dash
class _TalentEntry extends StatelessWidget {
  const _TalentEntry({required this.index, required this.text});

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 28,
          child: Text(
            index.toString().padLeft(2, '0'),
            style: const TextStyle(
              color: _burgundy,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(right: 10, top: 2),
          child: Text('—', style: TextStyle(color: _ruleColor, fontSize: 14)),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: _richBlack,
              fontSize: 15,
              fontWeight: FontWeight.w400,
              height: 1.6,
              fontFamily: 'Georgia',
            ),
          ),
        ),
      ],
    );
  }
}
