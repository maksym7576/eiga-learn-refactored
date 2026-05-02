

import 'package:eiga/backend/data/models/videoObject.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar_community/isar.dart';

class VideoService extends StateNotifier<List<VideoObject>> {
  final Isar db;

  VideoService(this.db) : super([]) {
    _watchVideos();
  }

  void _watchVideos() {
    db.videoObjects.where().watch(fireImmediately: true).listen((videos) {
      state = videos;
    });
  }

  Future<void> getAllVideos() async {
    final videos = await db.videoObjects.where().findAll();
    state = videos;
  }

  Future<void> addVideo(VideoObject videoObject) async {
    videoObject.createdAt = DateTime.now();
    await db.writeTxn(() async {
      await db.videoObjects.put(videoObject);
    });
  }

  Future<void> updateVideo(VideoObject newVideoObject) async {
    await db.writeTxn(() async {
      await db.videoObjects.put(newVideoObject);
    });
    await getAllVideos();
  }

  Future<VideoObject?> getVideoById(int id) async {
    return await db.videoObjects.get(id);
  }

  Future<void> deleteVideoById(int id) async {
    await db.writeTxn(() async {
      await db.videoObjects.delete(id);
    });
  }

}