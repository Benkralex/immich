import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immich_mobile/providers/infrastructure/current_album.provider.dart';
import 'package:immich_mobile/providers/infrastructure/remote_album.provider.dart';
import 'package:immich_mobile/widgets/common/drift_user_circle_avatar.dart';

class RemoteAlbumSharedUserIcons extends ConsumerWidget {
  const RemoteAlbumSharedUserIcons({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentAlbum = ref.watch(currentRemoteAlbumProvider);
    if (currentAlbum == null) {
      return const SizedBox();
    }

    final sharedUsersAsync = ref.watch(remoteAlbumSharedUsersProvider(currentAlbum.id));

    return sharedUsersAsync.maybeWhen(
      data: (sharedUsers) {
        if (sharedUsers.isEmpty) {
          return const SizedBox();
        }

        return SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: ((context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: DriftUserCircleAvatar(
                  user: sharedUsers[index],
                  radius: 18,
                  size: 36,
                  hasBorder: true,
                ),
              );
            }),
            itemCount: sharedUsers.length,
          ),
        );
      },
      orElse: () => const SizedBox(),
    );
  }
}
