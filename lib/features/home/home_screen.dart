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

  Future<void> _openMember(MemberDirectoryEntry member) async {
    FocusScope.of(context).unfocus();
    final route = memberProfileRoute(context, member.builder);
    await Navigator.of(context).push(route);
    await route.completed;
  }

  Future<void> _confirmSignOut(BuildContext portalContext) async {
    if (_signingOut) return;
    FocusScope.of(context).unfocus();

    final confirmed = await showDialog<bool>(
      context: portalContext,
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
    final theme = AppTheme.portal(Theme.of(context));

    return Theme(
      data: theme,
      child: Scaffold(
        body: DecoratedBox(
          decoration: BoxDecoration(
            gradient: AppTheme.portalBackdrop(theme.brightness),
          ),
          child: SafeArea(child: LayoutBuilder(builder: _buildDirectory)),
        ),
      ),
    );
  }

  Widget _buildDirectory(BuildContext context, BoxConstraints constraints) {
    const gap = 16.0;
    const maxContentWidth = 980.0;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final dark = theme.brightness == Brightness.dark;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final results = MemberRegistry.search(_query);
    final gutter = math.max(18.0, (constraints.maxWidth - maxContentWidth) / 2);
    final width = constraints.maxWidth - 2 * gutter;
    final columns = width >= 750 ? 3 : (width >= 260 ? 2 : 1);
    final cardWidth = (width - (columns - 1) * gap) / columns;
    final textScale = MediaQuery.textScalerOf(context);
    final cardHeight = cardWidth * 0.9 + MemberCard.captionHeight(textScale);
    final toolStyle = IconButton.styleFrom(
      foregroundColor: colors.primary,
      backgroundColor: colors.surfaceContainerLow.withValues(alpha: 0.76),
      side: BorderSide(color: colors.outlineVariant),
    );

    return CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(gutter, 20, gutter, 22),
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
                        child: Text.rich(
                          TextSpan(
                            text: 'NINE',
                            children: [
                              TextSpan(
                                text: '.',
                                style: TextStyle(color: colors.primary),
                              ),
                            ],
                          ),
                          style: AppTheme.wordmark.copyWith(
                            color: colors.onSurface,
                            fontSize: 44,
                            letterSpacing: -3.6,
                          ),
                        ),
                      ),
                    ),
                    IconButton.outlined(
                      style: toolStyle,
                      tooltip: dark ? 'Use light theme' : 'Use dark theme',
                      onPressed: () => widget.onToggleTheme(theme.brightness),
                      icon: Icon(
                        dark
                            ? Icons.light_mode_outlined
                            : Icons.dark_mode_outlined,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.outlined(
                      style: toolStyle,
                      tooltip: 'Sign out',
                      onPressed: _signingOut
                          ? null
                          : () => _confirmSignOut(context),
                      icon: const Icon(Icons.logout_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    spacing: 18,
                    runSpacing: 6,
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Semantics(
                        header: true,
                        child: Text(
                          'The collective',
                          style: theme.textTheme.headlineLarge?.copyWith(
                            color: colors.onSurface,
                          ),
                        ),
                      ),
                      if (results.isNotEmpty)
                        Text(
                          results.length == 1
                              ? '1 member'
                              : '${results.length} members',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
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
            padding: EdgeInsets.fromLTRB(gutter, 34, gutter, 28),
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
                      style: TextStyle(color: colors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          SliverPadding(
            padding: EdgeInsets.fromLTRB(gutter, 0, gutter, 30),
            sliver: SliverGrid.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: gap,
                mainAxisSpacing: gap,
                mainAxisExtent: cardHeight,
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
                      Tween(begin: const Offset(0, 0.04), end: Offset.zero),
                    ),
                    child: card,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
