import 'dart:developer' show log;
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;

Future<File> compressImage(PlatformFile file, {int quality = 70}) async {
  // Get file info
  final filePath = file.path ?? '';
  final fileName = p.basename(filePath);
  final extension = p.extension(filePath).toLowerCase();
  final directory = p.dirname(filePath);

  // Create output path with original extension
  final compressedFileName =
      '${p.basenameWithoutExtension(filePath)}_compressed$extension';
  final outPath = p.join(directory, compressedFileName);

  // Delete existing compressed file if it exists
  final outFile = File(outPath);
  if (!kIsWeb && await outFile.exists()) {
    await outFile.delete();
  }

  // Determine appropriate compression format based on extension
  CompressFormat format;
  switch (extension) {
    case '.jpg':
    case '.jpeg':
      format = CompressFormat.jpeg;
      break;
    case '.png':
      format = CompressFormat.png;
      break;
    case '.heic':
      // Convert HEIC to JPEG since compression may not support it directly
      format = CompressFormat.jpeg;
      break;
    case '.webp':
      format = CompressFormat.webp;
      break;
    default:
      // Default to JPEG for unsupported formats
      format = CompressFormat.jpeg;
  }

  log('Compressing image: $fileName with format $format');

  try {
    final result = await FlutterImageCompress.compressAndGetFile(
      filePath,
      outPath,
      quality: quality,
      format: format,
      minWidth: 100,
      minHeight: 100,
      // Keep EXIF metadata if needed
      keepExif: false,
    );

    if (result == null) {
      throw Exception('Image compression failed');
    }

    final compressedFile = File(result.path);
    final originalSize = file.size;
    final compressedSize = await compressedFile.length();

    log('Original size: ${(originalSize / 1024 / 1024).toStringAsFixed(2)} MB');
    log('Compressed size: ${(compressedSize / 1024 / 1024).toStringAsFixed(2)} MB');
    log('Compression ratio: ${(compressedSize / originalSize * 100).toStringAsFixed(1)}%');

    return compressedFile;
  } catch (e) {
    log('Error compressing image: $e');
    // If compression fails, return the original file
    return File(filePath);
  }
}
