# Contributing to NINE.

Each member owns their own profile screen directory and matching asset directory. For member 01 these are `lib/features/members/member_01/` and `assets/members/member_01/`. The same pattern applies to members 02 through 09.

## Member contract

- Keep the existing ID `member_XX`, the exported data name `memberXXProfile`, and the screen class `MemberXXScreen` with its `const MemberXXScreen({super.key})` constructor. Use the exported profile in your screen.
- Populate the string fields `id`, `fullName`, `studentId`, `address`, `email`, `photoAsset`, and `designName`. Provide `List<String>` values for `qualifications`, `softSkills`, and `specialTalents`. Use details you have permission to include in the assessment app.
- Replace `assets/members/member_XX/portrait.png` with your portrait, keeping the filename. Asset registration and routing are already in place.
- Build your assigned design inside your screen directory. Keep a visible back action, test the layout on a small Android screen, and check readable text and tap targets.

### Portrait widget

```dart
ClipRRect(
  borderRadius: BorderRadius.circular(20),
  child: AspectRatio(
    aspectRatio: 4 / 5,
    child: MemberPhoto(profile: member01Profile),
  ),
)
```

`MemberPhoto` takes a required `profile`, an optional `hero` defaulting to `true`, and an optional `fit` defaulting to `BoxFit.cover`. Give it bounded dimensions with a sizing widget such as `AspectRatio`. Use exactly one enabled photo Hero per profile screen. For additional displays of the portrait, use `MemberPhoto(profile: member01Profile, hero: false)`. The directory and profile share the tag `member-${profile.id}`.

## Git workflow

1. Branch from the latest `main` using a name such as `member-01/mono-profile`.
2. Modify only your own screen directory and corresponding asset directory. Ask the group leader for approval before changing shared code, dependencies, configuration, or another contributor's files.
3. Run `dart format lib/features/members/member_XX`, `flutter analyze`, and `flutter test`. Use a configured Android build to check your portrait, Hero transition, and back navigation.
4. Open a pull request to `main` with a short description and a screenshot of your profile. Recheck your files after merging updates from `main`.
