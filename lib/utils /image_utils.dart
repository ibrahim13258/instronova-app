import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

class ImageUtils {
  static final ImagePicker _picker = ImagePicker();

  /// Pick image from gallery or camera
  static Future<File?> pickImage({required ImageSource source}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      debugPrint("Image pick error: $e");
      return null;
    }
  }

  /// Resize image to given width and height
  static Future<File?> resizeImage(File file, {int width = 1080, int height = 1080}) async {
    try {
      final bytes = await file.readAsBytes();
      img.Image? image = img.decodeImage(bytes);
      if (image == null) return null;

      img.Image resized = img.copyResize(image, width: width, height: height);

      final tempDir = await getTemporaryDirectory();
      final targetPath = '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final resizedFile = File(targetPath)..writeAsBytesSync(img.encodeJpg(resized, quality: 90));

      return resizedFile;
    } catch (e) {
      debugPrint("Resize error: $e");
      return null;
    }
  }

  /// Compress image to reduce file size
  static Future<File?> compressImage(File file, {int quality = 75}) async {
    try {
      final bytes = await file.readAsBytes();
      img.Image? image = img.decodeImage(bytes);
      if (image == null) return null;

      final tempDir = await getTemporaryDirectory();
      final targetPath = '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}_compressed.jpg';
      final compressedFile = File(targetPath)..writeAsBytesSync(img.encodeJpg(image, quality: quality));

      return compressedFile;
    } catch (e) {
      debugPrint("Compression error: $e");
      return null;
    }
  }

  /// Pick, resize, and compress image in one step
  static Future<File?> pickResizeCompressImage({
    required ImageSource source,
    int width = 1080,
    int height = 1080,
    int quality = 75,
  }) async {
    File? picked = await pickImage(source: source);
    if (picked == null) return null;

    File? resized = await resizeImage(picked, width: width, height: height);
    if (resized == null) return null;

    File? compressed = await compressImage(resized, quality: quality);
    return compressed;
  }
}
