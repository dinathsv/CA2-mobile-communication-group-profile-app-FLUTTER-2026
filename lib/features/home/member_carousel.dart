import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/member_registry.dart';
import '../../widgets/member_card.dart';

class MemberCarousel extends StatefulWidget {
  const MemberCarousel({
    super.key,
    required this.members,
    required this.cardHeight,
    required this.initialIndex,
    required this.onMemberChanged,
    required this.onOpen,
  });

  final List<MemberDirectoryEntry> members;
  final double cardHeight;
  final int initialIndex;
  final ValueChanged<int> onMemberChanged;
  final Future<void> Function(MemberDirectoryEntry) onOpen;

  @override
  State<MemberCarousel> createState() => _MemberCarouselState();
}

class _MemberCarouselState extends State<MemberCarousel>
    with SingleTickerProviderStateMixin {
  late final _turn = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 480),
    value: 1,
  );
  late int _index = widget.initialIndex;
  late int _previousIndex = _index;
  int _direction = 1;
  double _dragDistance = 0;
  bool _opening = false;

  bool get _canBrowse => widget.members.length > 1;
  int get _readingDirection =>
      Directionality.of(context) == TextDirection.ltr ? 1 : -1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context) && _turn.isAnimating) {
      _turn.value = 1;
    }
    _preloadNeighbors();
  }

  @override
  void dispose() {
    _turn.dispose();
    super.dispose();
  }

  int _indexAfter(int step) => (_index + step) % widget.members.length;

  void _preloadNeighbors() {
    if (!_canBrowse) return;
    for (final neighbor in {_indexAfter(-1), _indexAfter(1)}) {
      final asset = widget.members[neighbor].profile.photoAsset;
      precacheImage(AssetImage(asset), context, onError: (_, _) {});
    }
  }

  void _browse(int step) {
    if (!_canBrowse || _turn.isAnimating || _opening) return;

    setState(() {
      _previousIndex = _index;
      _index = _indexAfter(step);
      _direction = step * _readingDirection;
    });
    widget.onMemberChanged(_index);
    if (!MediaQuery.disableAnimationsOf(context)) {
      _turn.forward(from: 0);
    }
    _preloadNeighbors();
  }

  void _endSwipe(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    final isFlick = velocity.abs() >= 350;
    if (!isFlick && _dragDistance.abs() < 38) return;

    final movement = isFlick ? velocity : _dragDistance;
    _browse((movement < 0 ? 1 : -1) * _readingDirection);
  }

  Future<void> _open(MemberDirectoryEntry member) async {
    if (_opening || _turn.isAnimating) return;
    setState(() => _opening = true);
    try {
      await widget.onOpen(member);
    } finally {
      if (mounted) setState(() => _opening = false);
    }
  }

  Matrix4 _cardTransform(double progress, bool incoming) {
    if (!_turn.isAnimating) return Matrix4.identity();
    final turn = incoming ? 2 * (1 - progress) : 2 * progress;
    final direction = incoming ? -_direction : _direction;
    final angle = turn * math.pi / 2;
    final popScale = incoming
        ? 0.86 + 0.14 * Curves.easeOutBack.transform(1 - turn)
        : 1 - 0.14 * turn;
    // Compensate for the closer edge growing under perspective.
    final scale = popScale / (1 + 0.175 * popScale * math.sin(angle));

    return Matrix4.identity()
      ..setEntry(3, 2, 0.0008)
      ..rotateY(direction * angle)
      ..scaleByDouble(scale, scale, 1, 1);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final controlStyle = IconButton.styleFrom(
      minimumSize: const Size.square(48),
      foregroundColor: colors.primary,
      backgroundColor: colors.surfaceContainerLow,
      side: BorderSide(color: colors.outlineVariant),
    );

    return CallbackShortcuts(
      bindings: {
        if (_canBrowse) ...{
          const SingleActivator(LogicalKeyboardKey.arrowLeft): () =>
              _browse(-_readingDirection),
          const SingleActivator(LogicalKeyboardKey.arrowRight): () =>
              _browse(_readingDirection),
        },
      },
      child: AnimatedBuilder(
        animation: _turn,
        builder: (context, _) {
          // Swap faces while the card is edge-on.
          final progress = Curves.easeInOutCubic.transform(_turn.value);
          final incoming = progress >= 0.5;
          final index = incoming ? _index : _previousIndex;
          final member = widget.members[index];
          final canOpen = !_turn.isAnimating && !_opening;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                excludeFromSemantics: true,
                onHorizontalDragStart: _canBrowse
                    ? (_) => _dragDistance = 0
                    : null,
                onHorizontalDragUpdate: _canBrowse
                    ? (details) => _dragDistance += details.delta.dx
                    : null,
                onHorizontalDragEnd: _canBrowse ? _endSwipe : null,
                child: Transform(
                  alignment: Alignment.center,
                  transform: _cardTransform(progress, incoming),
                  child: RepaintBoundary(
                    child: MemberCard(
                      key: ValueKey(member.profile.id),
                      profile: member.profile,
                      minimumHeight: widget.cardHeight,
                      onTap: canOpen ? () => _open(member) : null,
                    ),
                  ),
                ),
              ),
              if (_canBrowse) ...[
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton.outlined(
                      style: controlStyle,
                      tooltip: 'Previous member',
                      onPressed: () => _browse(-1),
                      icon: const Icon(Icons.arrow_back_rounded, size: 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Semantics(
                        liveRegion: true,
                        child: Text(
                          '${index + 1} / ${widget.members.length}',
                          semanticsLabel:
                              'Member ${index + 1} of ${widget.members.length}',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                    IconButton.outlined(
                      style: controlStyle,
                      tooltip: 'Next member',
                      onPressed: () => _browse(1),
                      icon: const Icon(Icons.arrow_forward_rounded, size: 20),
                    ),
                  ],
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
