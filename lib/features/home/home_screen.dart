import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/navigation/app_transitions.dart';
import '../../core/theme/app_theme.dart';
import '../../data/member_registry.dart';
import '../../services/auth_service.dart';
import 'member_carousel.dart';
import 'member_list.dart';

enum _DirectoryView { carousel, list }

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

class _HomeScreenState extends State<HomeScreen> {
  final _search = TextEditingController();
  String _query = '';
  _DirectoryView _view = _DirectoryView.carousel;
  int _carouselIndex = 0;
  bool _openingMember = false;
  bool _signingOut = false;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _updateSearch(String value) => setState(() {
    _query = value;
    _carouselIndex = 0;
  });

  Future<void> _openMember(MemberDirectoryEntry member) async {
    if (_openingMember) return;
    _openingMember = true;
    try {
      FocusScope.of(context).unfocus();
      final route = memberProfileRoute(context, member.builder);
      await Navigator.of(context).push(route);
      await route.completed;
    } finally {
      _openingMember = false;
    }
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
    const gutter = 20.0;
    const maxContentWidth = 432.0;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final dark = theme.brightness == Brightness.dark;
    final results = MemberRegistry.search(_query);
    final width = (constraints.maxWidth - 2 * gutter).clamp(
      0.0,
      maxContentWidth,
    );
    final cardHeight = math.min(
      width * 1.1,
      math.max(220.0, constraints.maxHeight - 282),
    );
    final toolStyle = IconButton.styleFrom(
      foregroundColor: colors.primary,
      backgroundColor: colors.surfaceContainerLow.withValues(alpha: 0.76),
      side: BorderSide(color: colors.outlineVariant),
    );

    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(gutter, 18, gutter, 18),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: maxContentWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        AppTheme.appName,
                        style: AppTheme.wordmark.copyWith(
                          color: colors.onSurface,
                          fontSize: 40,
                          letterSpacing: -3,
                        ),
                      ),
                    ),
                  ),
                  SegmentedButton<_DirectoryView>(
                    style: SegmentedButton.styleFrom(
                      foregroundColor: colors.onSurfaceVariant,
                      selectedForegroundColor: colors.primary,
                      selectedBackgroundColor: colors.surfaceContainerHighest,
                      side: BorderSide(color: colors.outlineVariant),
                      minimumSize: const Size(40, 40),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    showSelectedIcon: false,
                    segments: const [
                      ButtonSegment(
                        value: _DirectoryView.carousel,
                        icon: Icon(Icons.view_carousel_outlined, size: 20),
                        tooltip: 'Carousel view',
                      ),
                      ButtonSegment(
                        value: _DirectoryView.list,
                        icon: Icon(
                          Icons.format_list_bulleted_rounded,
                          size: 20,
                        ),
                        tooltip: 'List view',
                      ),
                    ],
                    selected: {_view},
                    onSelectionChanged: (selection) =>
                        setState(() => _view = selection.single),
                  ),
                  const SizedBox(width: 12),
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
              const SizedBox(height: 22),
              Semantics(
                header: true,
                child: Text(
                  'The collective',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: colors.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 12),
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
              const SizedBox(height: 20),
              if (results.isEmpty)
                Semantics(
                  liveRegion: true,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
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
                )
              else if (_view == _DirectoryView.carousel)
                MemberCarousel(
                  key: ValueKey(_query),
                  members: results,
                  cardHeight: cardHeight,
                  initialIndex: _carouselIndex,
                  onMemberChanged: (index) => _carouselIndex = index,
                  onOpen: _openMember,
                )
              else
                MemberList(members: results, onOpen: _openMember),
            ],
          ),
        ),
      ),
    );
  }
}
