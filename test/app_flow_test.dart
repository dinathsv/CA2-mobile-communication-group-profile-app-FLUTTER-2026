import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nine/app.dart';
import 'package:nine/data/member_registry.dart';
import 'package:nine/features/members/member_09/member_09_screen.dart';
import 'package:nine/services/auth_service.dart';
import 'package:nine/widgets/member_card.dart';

class _TestAuth implements AuthService {
  _TestAuth(this.userId);

  final _events = StreamController<String?>.broadcast();
  String? userId;
  Future<void> Function()? attempt;
  final signIns = <({String email, String password})>[];

  @override
  Stream<String?> authStateChanges() async* {
    yield userId;
    yield* _events.stream;
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    signIns.add((email: email, password: password));
    await attempt?.call();
    setUser('assessment-user');
  }

  @override
  Future<void> signOut() async => setUser(null);

  void setUser(String? value) {
    userId = value;
    _events.add(value);
  }

  Future<void> dispose() => _events.close();
}

Future<_TestAuth> _start(WidgetTester tester, {bool signedIn = false}) async {
  final auth = _TestAuth(signedIn ? 'assessment-user' : null);
  addTearDown(auth.dispose);
  await tester.pumpWidget(NineApp(auth: auth));
  await tester.pumpAndSettle();
  return auth;
}

void main() {
  testWidgets(
    'login validates, toggles visibility, and prevents repeat submissions',
    (tester) async {
      final auth = await _start(tester);
      final submit = find.widgetWithText(FilledButton, 'Sign in');
      expect(tester.widget<MaterialApp>(find.byType(MaterialApp)).title, 'IX');
      expect(find.text('IX'), findsOneWidget);
      expect(find.text('The collective'), findsNothing);

      await tester.tap(submit);
      await tester.pumpAndSettle();
      expect(find.text('Enter your email address.'), findsOneWidget);
      expect(find.text('Enter your password.'), findsOneWidget);
      expect(auth.signIns, isEmpty);

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.first, ' member@example.com ');
      await tester.enterText(fields.last, ' test password ');
      await tester.tap(find.byTooltip('Show password'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<EditableText>(find.byType(EditableText).last).obscureText,
        isFalse,
      );

      final pending = Completer<void>();
      auth.attempt = () => pending.future;
      await tester.tap(submit);
      await tester.pump();
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
      expect(auth.signIns.single, (
        email: 'member@example.com',
        password: ' test password ',
      ));

      pending.completeError(AuthFailure.fromCode('network-request-failed'));
      await tester.pumpAndSettle();
      expect(
        find.text('Check your internet connection and try again.'),
        findsOneWidget,
      );
      expect(tester.widget<FilledButton>(submit).onPressed, isNotNull);

      auth.attempt = null;
      await tester.tap(submit);
      await tester.pumpAndSettle();
      expect(find.text('The collective'), findsOneWidget);
      expect(find.text('IX'), findsOneWidget);
    },
  );

  testWidgets('directory searches and clears the empty state', (tester) async {
    await _start(tester, signedIn: true);
    final search = find.byType(TextField);
    final member = MemberRegistry.entries[2].profile;

    await tester.enterText(search, '  ${member.fullName.toUpperCase()}  ');
    await tester.pumpAndSettle();
    expect(find.byKey(ValueKey(member.id)), findsOneWidget);

    await tester.enterText(search, 'does-not-match-any-member-404');
    await tester.pumpAndSettle();
    expect(find.byType(MemberCard), findsNothing);
    expect(find.text('No members found'), findsOneWidget);

    await tester.tap(find.byTooltip('Clear search'));
    await tester.pumpAndSettle();
    expect(find.text('No members found'), findsNothing);
    expect(find.byKey(const ValueKey('member_01')), findsOneWidget);
    expect(tester.widget<TextField>(search).controller!.text, isEmpty);
  });

  testWidgets('sign-in stays scrollable with a keyboard on a small display', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    tester.view.viewInsets = const FakeViewPadding(bottom: 265);
    addTearDown(tester.view.reset);

    await _start(tester);
    final submit = find.widgetWithText(FilledButton, 'Sign in');
    await tester.ensureVisible(submit);
    await tester.pumpAndSettle();
    expect(submit.hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'profile fades in, preserves search, and clears routes at sign-out',
    (tester) async {
      final auth = await _start(tester, signedIn: true);
      final search = find.byType(TextField);
      final member = MemberRegistry.entries.last.profile;
      final card = find.byKey(ValueKey(member.id));
      final screen = find.byType(Member09Screen);
      await tester.enterText(search, member.fullName);
      await tester.pumpAndSettle();

      await tester.tap(card);
      await tester.pump();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 120));
      expect(
        find.ancestor(
          of: screen,
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is FadeTransition &&
                widget.opacity.value > 0 &&
                widget.opacity.value < 1,
          ),
        ),
        findsOneWidget,
      );
      await tester.pumpAndSettle();
      expect(screen, findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (widget) => widget is Hero && widget.tag == 'member-member_09',
        ),
        findsOneWidget,
      );

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(
        tester.widget<TextField>(search).controller!.text,
        member.fullName,
      );
      expect(card, findsOneWidget);

      await tester.tap(card);
      await tester.pumpAndSettle();
      auth.setUser(null);
      await tester.idle();
      await tester.pump();
      expect(find.byType(Member09Screen, skipOffstage: false), findsNothing);
      await tester.pumpAndSettle();
      expect(find.widgetWithText(FilledButton, 'Sign in'), findsOneWidget);

      auth.setUser('assessment-user');
      await tester.pumpAndSettle();
      expect(find.text('The collective'), findsOneWidget);
      expect(tester.widget<TextField>(search).controller!.text, isEmpty);
    },
  );

  testWidgets(
    'reduced motion disables the portrait flight and route animation',
    (tester) async {
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
      await _start(tester, signedIn: true);
      await tester.enterText(
        find.byType(TextField),
        MemberRegistry.entries.last.profile.fullName,
      );
      await tester.pumpAndSettle();
      expect(find.byType(Hero), findsNothing);

      await tester.tap(find.byKey(const ValueKey('member_09')));
      await tester.pumpAndSettle();
      final screen = find.byType(Member09Screen);
      expect(screen, findsOneWidget);
      expect(find.byType(Hero), findsNothing);
      final route = ModalRoute.of(tester.element(screen))!;
      expect(route.transitionDuration, Duration.zero);
      expect(route.reverseTransitionDuration, Duration.zero);
    },
  );

  testWidgets(
    'theme toggle and sign-out confirmation work from the directory',
    (tester) async {
      await _start(tester, signedIn: true);
      await tester.tap(find.byTooltip('Use dark theme'));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Use light theme'), findsOneWidget);

      await tester.tap(find.byTooltip('Sign out'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.text('The collective'), findsOneWidget);

      await tester.tap(find.byTooltip('Sign out'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'Sign out'));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(FilledButton, 'Sign in'), findsOneWidget);
      expect(find.text('The collective'), findsNothing);
    },
  );
}
