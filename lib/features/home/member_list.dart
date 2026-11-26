import 'package:flutter/material.dart';

import '../../data/member_registry.dart';
import '../../widgets/member_photo.dart';

class MemberList extends StatelessWidget {
  const MemberList({super.key, required this.members, required this.onOpen});

  final List<MemberDirectoryEntry> members;
  final Future<void> Function(MemberDirectoryEntry) onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final captionStyle = theme.textTheme.labelMedium?.copyWith(
      color: colors.onSurfaceVariant,
    );

    return Material(
      color: colors.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: colors.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (final (index, member) in members.indexed) ...[
            if (index > 0)
              Divider(
                height: 1,
                indent: 14,
                endIndent: 14,
                color: colors.outlineVariant,
              ),
            ListTile(
              key: ValueKey(member.profile.id),
              minTileHeight: 72,
              contentPadding: const EdgeInsetsDirectional.fromSTEB(
                14,
                8,
                14,
                8,
              ),
              leading: ExcludeSemantics(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox.square(
                    dimension: 48,
                    child: MemberPhoto(profile: member.profile),
                  ),
                ),
              ),
              title: Text(
                member.profile.fullName,
                style: theme.textTheme.titleMedium,
              ),
              subtitle: Text(
                '${member.profile.number} · ${member.profile.designName}',
                style: captionStyle,
              ),
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: colors.primary,
              ),
              onTap: () => onOpen(member),
            ),
          ],
        ],
      ),
    );
  }
}
