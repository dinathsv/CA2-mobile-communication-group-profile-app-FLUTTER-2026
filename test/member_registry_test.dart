import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nine/data/member_registry.dart';
import 'package:nine/models/member_profile.dart';

void main() {
  testWidgets(
    'the registry links all nine IDs to their own screens and assets',
    (tester) async {
      const designs = [
        'MONO',
        'TERMINAL',
        'AURA',
        'ZEN',
        'BENTO',
        'VOGUE',
        'PULSE',
        'BRUTAL',
        'CINEMA',
      ];
      late BuildContext context;
      await tester.pumpWidget(
        Builder(
          builder: (value) {
            context = value;
            return const SizedBox();
          },
        ),
      );

      final assets = await AssetManifest.loadFromAssetBundle(rootBundle);
      final bundledPaths = assets.listAssets().toSet();
      expect(MemberRegistry.entries, hasLength(designs.length));
      for (final (index, entry) in MemberRegistry.entries.indexed) {
        final number = '${index + 1}'.padLeft(2, '0');
        expect(entry.profile.id, 'member_$number');
        expect(
          entry.profile.photoAsset,
          startsWith('assets/members/member_$number/'),
        );
        expect(bundledPaths, contains(entry.profile.photoAsset));
        expect(entry.profile.designName, designs[index]);
        expect(
          entry.builder(context).runtimeType.toString(),
          'Member${number}Screen',
        );
      }
    },
  );

  test(
    'search matches names case-insensitively and ignores surrounding spaces',
    () {
      final member = MemberRegistry.entries[2].profile;
      expect(MemberRegistry.search('   '), MemberRegistry.entries);
      expect(
        MemberRegistry.search(
          '  ${member.fullName.toUpperCase()}  ',
        ).map((entry) => entry.profile),
        contains(member),
      );
      expect(MemberRegistry.search('does-not-match-any-member-404'), isEmpty);
    },
  );

  test('profile lists cannot be modified through either reference', () {
    final qualifications = ['Example'];
    final profile = MemberProfile(
      id: 'member_01',
      fullName: 'Example',
      studentId: '',
      address: '',
      email: '',
      photoAsset: '',
      qualifications: qualifications,
      softSkills: [],
      specialTalents: [],
      designName: 'MONO',
    );

    qualifications.clear();
    expect(profile.qualifications, ['Example']);
    expect(() => profile.qualifications.add('Another'), throwsUnsupportedError);
    expect(() => profile.softSkills.add('Another'), throwsUnsupportedError);
    expect(() => profile.specialTalents.add('Another'), throwsUnsupportedError);
  });
}
