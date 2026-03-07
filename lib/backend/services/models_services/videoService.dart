

import 'package:eiga/backend/data/models/videoObject.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

class VideoService extends StateNotifier<List<VideoObject>> {
  final Isar db;

  VideoService(this.db) : super([]) {
    getAllVideos();
  }

  Future<void> getAllVideos() async {
    final videos = await db.videoObjects.where().findAll();
    state = videos;
  }

  Future<VideoObject> addVideo(VideoObject videoObject) async {
    videoObject.createdAt = DateTime.now();
    final createdVideoObject = await db.writeTxn(() async {
      await db.videoObjects.put(videoObject);
    });
    await getAllVideos();
    return createdVideoObject;
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

}