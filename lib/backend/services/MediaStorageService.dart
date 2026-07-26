import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class MediaStorageService {
  /// Завантажує зображення за URL і зберігає локально в Documents/anilist_covers
  static Future<String> saveCoverImage(String imageUrl, int anilistId) async {
    final docsDir = await getApplicationDocumentsDirectory();
    final coversDir = Directory(p.join(docsDir.path, 'anilist_covers'));

    if (!await coversDir.exists()) {
      await coversDir.create(recursive: true);
    }

    final ext = p.extension(imageUrl).isNotEmpty ? p.extension(imageUrl) : '.jpg';
    final localPath = p.join(coversDir.path, '$anilistId$ext');
    final file = File(localPath);

    // Якщо вже завантажено раніше - не качаємо повторно
    if (await file.exists()) {
      return localPath;
    }

    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode != 200) {
      throw Exception('Не вдалося завантажити постер: ${response.statusCode}');
    }

    await file.writeAsBytes(response.bodyBytes);
    return localPath;
  }
}