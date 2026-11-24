import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/navigation/app_transitions.dart';
import '../../core/theme/app_theme.dart';
import '../../data/member_registry.dart';
import '../../services/auth_service.dart';
import '../../widgets/member_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.auth,
    required this.onToggleTheme,
  });

  final AuthService auth;
  final ValueChanged<Brightness> onToggleTheme;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final _search = TextEditingController();
  late final _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 680),
  );
  String _query = '';
  bool _signingOut = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _entrance.value = 1;
    } else if (_entrance.isDismissed) {
      _entrance.forward();
    }
  }

  @override
  void dispose() {
    _search.dispose();
    _entrance.dispose();
    super.dispose();
  }

  void _updateSearch(String value) => setState(() => _query = value);

  void _openMember(MemberDirectoryEntry member) {
    FocusScope.of(context).unfocus();
    Navigator.of(context).push(memberProfileRoute(context, member.builder));
  }

  Future<void> _confirmSignOut() async {
    if (_signingOut) return;
    FocusScope.of(context).unfocus();

    final confirmed = await showDialog<bool>(
      context: context,
      useRootNavigator: false,
      animationStyle: MediaQuery.disableAnimationsOf(context)
          ? AnimationStyle.noAnimation
          : null,
      builder: (context) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text(
          'You’ll need to sign in again to view the directory.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;

    setState(() => _signingOut = true);
    try {
      await widget.auth.signOut();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not sign out. Please try again.')),
      );
    } finally {
      if (mounted) setState(() => _signingOut = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final results = MemberRegistry.search(_query);
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            const maxContentWidth = 744.0;
            const gap = 14.0;
            final gutter = math.max(
              20.0,
              (constraints.maxWidth - maxContentWidth) / 2,
            );
            final cardWidth = (constraints.maxWidth - 2 * gutter - gap) / 2;
            final labelHeight =
                40 + MediaQuery.textScalerOf(context).scale(18) * 2.2;

            return CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(gutter, 18, gutter, 18),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'NINE.',
                                  style: AppTheme.wordmark.copyWith(
                                    fontSize: 44,
                                    letterSpacing: -3.6,
                                  ),
                                ),
                              ),
                            ),
                            IconButton.outlined(
                              tooltip: dark
                                  ? 'Use light theme'
                                  : 'Use dark theme',
                              onPressed: () =>
                                  widget.onToggleTheme(theme.brightness),
                              icon: Icon(
                                dark
                                    ? Icons.light_mode_outlined
                                    : Icons.dark_mode_outlined,
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton.outlined(
                              tooltip: 'Sign out',
                              onPressed: _signingOut ? null : _confirmSignOut,
                              icon: const Icon(Icons.logout_rounded),
                            ),
                          ],
                        ),
                        const SizedBox(height: 29),
                        Semantics(
                          header: true,
                          child: Text(
                            'The collective',
                            style: theme.textTheme.headlineSmall,
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: _search,
                          onChanged: _updateSearch,
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            labelText: 'Search members',
                            prefixIcon: const Icon(Icons.search_rounded),
                            suffixIcon: _query.isEmpty
                                ? null
                                : IconButton(
                                    tooltip: 'Clear search',
                                    onPressed: () {
                                      _search.clear();
                                      _updateSearch('');
                                    },
                                    icon: const Icon(Icons.close_rounded),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (results.isEmpty)
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(gutter, 40, gutter, 28),
                    sliver: SliverToBoxAdapter(
                      child: Semantics(
                        liveRegion: true,
                        child: Column(
                          children: [
                            Text(
                              'No members found',
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Try a different name.',
                              style: TextStyle(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(gutter, 0, gutter, 24),
                    sliver: SliverGrid.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: gap,
                        mainAxisSpacing: gap,
                        mainAxisExtent: cardWidth * 1.08 + labelHeight,
                      ),
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final member = results[index];
                        final card = MemberCard(
                          key: ValueKey(member.profile.id),
                          profile: member.profile,
                          onTap: () => _openMember(member),
                        );
                        if (reduceMotion || _entrance.isCompleted) return card;

                        final start = index * 0.055;
                        final progress = _entrance.drive(
                          CurveTween(
                            curve: Interval(
                              start,
                              start + 0.54,
                              curve: Curves.easeOutCubic,
                            ),
                          ),
                        );
                        return FadeTransition(
                          opacity: progress,
                          child: SlideTransition(
                            position: progress.drive(
                              Tween(
                                begin: const Offset(0, 0.055),
                                end: Offset.zero,
                              ),
                            ),
                            child: card,
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
