import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageHelper {
  ImageHelper._privateConstructor();
  static final ImageHelper instance = ImageHelper._privateConstructor();

  final ImagePicker _picker = ImagePicker();

  /// Pick image from gallery
  Future<File?> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  /// Pick image from camera
  Future<File?> pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  /// Compress image to reduce size
  Future<File?> compressImage(File file,
      {int quality = 75, int minWidth = 800, int minHeight = 800}) async {
    final dir = await getTemporaryDirectory();
    final targetPath = path.join(dir.path, 'compressed_${path.basename(file.path)}');

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: quality,
      minWidth: minWidth,
      minHeight: minHeight,
    );

    return result;
  }

  /// Cache image locally (returns File path)
  Future<File?> cacheImage(File file) async {
    final dir = await getApplicationDocumentsDirectory();
    final fileName = path.basename(file.path);
    final localPath = path.join(dir.path, fileName);
    final cachedFile = await file.copy(localPath);
    return cachedFile;
  }

  /// Pick, compress and cache image in one function
  Future<File?> pickCompressAndCache({bool fromCamera = false}) async {
    File? imageFile;
    if (fromCamera) {
      imageFile = await pickImageFromCamera();
    } else {
      imageFile = await pickImageFromGallery();
    }
    if (imageFile == null) return null;

    final compressedFile = await compressImage(imageFile);
    if (compressedFile == null) return null;

    final cachedFile = await cacheImage(compressedFile);
    return cachedFile;
  }
}
