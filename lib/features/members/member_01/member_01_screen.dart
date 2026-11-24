import 'package:flutter/material.dart';

import '../../../models/member_profile.dart';
import '../../../widgets/member_photo.dart';

final member01Profile = MemberProfile(
  id: 'member_01',
  fullName: 'Placeholder Member 01',
  studentId: 'Student ID pending',
  address: 'Address pending',
  email: 'Email pending',
  photoAsset: 'assets/members/member_01/portrait.png',
  qualifications: const ['Qualifications pending'],
  softSkills: const ['Soft skills pending'],
  specialTalents: const ['Special talents pending'],
  designName: 'MONO',
);

class Member01Screen extends StatefulWidget {
  const Member01Screen({super.key});

  @override
  State<Member01Screen> createState() => _Member01ScreenState();
}

class _Member01ScreenState extends State<Member01Screen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final Animation<Offset> _entranceOffset;
  bool _entranceStarted = false;
  bool _qualificationsExpanded = false;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 720),
    );
    _entranceOffset = _entranceController.drive(
      Tween<Offset>(
        begin: const Offset(0, 0.1),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOutCubic)),
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

  @override
  Widget build(BuildContext context) {
    final profile = member01Profile;
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    final viewportWidth = MediaQuery.sizeOf(context).width;
    final expandedHeight = (viewportWidth * 1.08).clamp(440.0, 640.0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: expandedHeight,
              toolbarHeight: 64,
              leadingWidth: 68,
              titleSpacing: 0,
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              automaticallyImplyLeading: false,
              leading: IconButton(
                tooltip: 'Back',
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back),
              ),
              title: const Text(
                'NINE.',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              actions: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 24),
                    child: Text(
                      '${profile.number} / 09',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.3,
                      ),
                    ),
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: _PortraitHeader(
                  profile: profile,
                  entranceController: _entranceController,
                  entranceOffset: _entranceOffset,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1120),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      viewportWidth >= 760 ? 64 : 24,
                      52,
                      viewportWidth >= 760 ? 64 : 24,
                      88,
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final details = _buildDetails(profile);
                        final qualifications = _buildQualifications(
                          profile,
                          reducedMotion,
                        );
                        final skills = _buildSkills(profile);
                        final talents = _buildTalents(profile);

                        if (constraints.maxWidth < 720) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              details,
                              const SizedBox(height: 52),
                              qualifications,
                              const SizedBox(height: 52),
                              skills,
                              const SizedBox(height: 44),
                              talents,
                            ],
                          );
                        }

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 7,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  details,
                                  const SizedBox(height: 60),
                                  qualifications,
                                ],
                              ),
                            ),
                            const SizedBox(width: 72),
                            Expanded(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  skills,
                                  const SizedBox(height: 56),
                                  talents,
                                ],
                              ),
                            ),
                          ],
                        );
                      },
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

  Widget _buildDetails(MemberProfile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionHeading('01', 'DETAILS'),
        const SizedBox(height: 25),
        _detailLine('ADDRESS', profile.address),
        _detailLine('EMAIL', profile.email),
        _detailLine('STUDENT ID', profile.studentId),
      ],
    );
  }

  Widget _buildQualifications(MemberProfile profile, bool reducedMotion) {
    final duration = reducedMotion
        ? Duration.zero
        : const Duration(milliseconds: 320);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          button: true,
          expanded: _qualificationsExpanded,
          label: 'Academic qualifications',
          hint: _qualificationsExpanded
              ? 'Collapse qualifications'
              : 'Expand qualifications',
          onTap: _toggleQualifications,
          child: InkWell(
            onTap: _toggleQualifications,
            child: ExcludeSemantics(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Text('02', style: _indexStyle),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ACADEMIC QUALIFICATIONS',
                            style: _sectionTitleStyle,
                          ),
                          const SizedBox(height: 12),
                          Container(height: 1, color: _lineColor),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    AnimatedRotation(
                      turns: _qualificationsExpanded ? 0.5 : 0,
                      duration: duration,
                      child: const Icon(
                        Icons.add,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: duration,
          curve: Curves.easeInOutCubic,
          alignment: Alignment.topCenter,
          child: _qualificationsExpanded
              ? Padding(
                  padding: const EdgeInsets.only(top: 18),
                  child: Column(
                    children: [
                      for (
                        var index = 0;
                        index < profile.qualifications.length;
                        index++
                      )
                        _timelineEntry(
                          profile.qualifications[index],
                          isLast: index == profile.qualifications.length - 1,
                        ),
                    ],
                  ),
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }

  void _toggleQualifications() {
    setState(() {
      _qualificationsExpanded = !_qualificationsExpanded;
    });
  }

  Widget _buildSkills(MemberProfile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionHeading('03', 'SOFT SKILLS'),
        const SizedBox(height: 25),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final skill in profile.softSkills)
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 280),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: _lineColor),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 9,
                    ),
                    child: Text(
                      skill,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        height: 1.25,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildTalents(MemberProfile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionHeading('04', 'SPECIAL TALENTS'),
        const SizedBox(height: 18),
        for (var index = 0; index < profile.specialTalents.length; index++)
          _talentLine(index + 1, profile.specialTalents[index]),
      ],
    );
  }

  Widget _sectionHeading(String number, String title) {
    return Row(
      children: [
        Text(number, style: _indexStyle),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: _sectionTitleStyle),
              const SizedBox(height: 12),
              Container(height: 1, color: _lineColor),
            ],
          ),
        ),
      ],
    );
  }

  Widget _detailLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 19),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 90, child: Text(label, style: _metaStyle)),
          const SizedBox(width: 16),
          Expanded(child: Text(value, style: _bodyStyle)),
        ],
      ),
    );
  }

  Widget _timelineEntry(String qualification, {required bool isLast}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 9,
          child: Column(
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast) Container(width: 1, height: 34, color: _lineColor),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Text(qualification, style: _bodyStyle),
          ),
        ),
      ],
    );
  }

  Widget _talentLine(int number, String talent) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32,
            child: Text(number.toString().padLeft(2, '0'), style: _indexStyle),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(talent, style: _bodyStyle)),
        ],
      ),
    );
  }
}

class _PortraitHeader extends StatelessWidget {
  const _PortraitHeader({
    required this.profile,
    required this.entranceController,
    required this.entranceOffset,
  });

  final MemberProfile profile;
  final Animation<double> entranceController;
  final Animation<Offset> entranceOffset;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final numberSize = (width * 0.52).clamp(170.0, 330.0);
    final nameSize = (width * 0.11).clamp(40.0, 76.0);
    final safeTop = MediaQuery.paddingOf(context).top;

    return Stack(
      fit: StackFit.expand,
      children: [
        ColorFiltered(
          colorFilter: const ColorFilter.matrix([
            0.2126,
            0.7152,
            0.0722,
            0,
            0,
            0.2126,
            0.7152,
            0.0722,
            0,
            0,
            0.2126,
            0.7152,
            0.0722,
            0,
            0,
            0,
            0,
            0,
            1,
            0,
          ]),
          child: MemberPhoto(profile: profile),
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0x66000000),
                Color(0x00000000),
                Color(0x08000000),
                Color(0xE6000000),
              ],
              stops: [0, 0.34, 0.58, 1],
            ),
          ),
        ),
        Positioned(
          right: 20,
          top: safeTop + 72,
          child: ExcludeSemantics(
            child: Text(
              profile.number,
              style: TextStyle(
                color: const Color(0x55FFFFFF),
                fontSize: numberSize,
                fontWeight: FontWeight.w900,
                height: 0.85,
                letterSpacing: -12,
              ),
            ),
          ),
        ),
        Positioned(
          left: width >= 760 ? 64 : 24,
          right: width >= 760 ? 64 : 24,
          bottom: 42,
          child: FadeTransition(
            opacity: entranceController,
            child: SlideTransition(
              position: entranceOffset,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'MEMBER ${profile.number}  /  ${profile.designName}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 13),
                  Semantics(
                    header: true,
                    child: Text(
                      profile.fullName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: nameSize,
                        fontWeight: FontWeight.w900,
                        height: 0.96,
                        letterSpacing: -2.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

const Color _lineColor = Color(0xFFD8D8D8);

const TextStyle _indexStyle = TextStyle(
  color: Color(0xFF777777),
  fontSize: 11,
  fontWeight: FontWeight.w600,
  letterSpacing: 1.2,
);

const TextStyle _sectionTitleStyle = TextStyle(
  color: Colors.black,
  fontSize: 12,
  fontWeight: FontWeight.w800,
  letterSpacing: 1.3,
);

const TextStyle _metaStyle = TextStyle(
  color: Color(0xFF777777),
  fontSize: 10,
  fontWeight: FontWeight.w700,
  letterSpacing: 1.1,
);

const TextStyle _bodyStyle = TextStyle(
  color: Colors.black,
  fontSize: 14,
  height: 1.5,
);
