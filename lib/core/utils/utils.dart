import 'dart:developer' show log;
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;

Future<File> compressImage(PlatformFile file, {int quality = 70}) async {
  // Web platform doesn't support File operations
  if (kIsWeb) {
    log('Web platform detected - using bytes-based compression');
    // For web, compress to bytes and throw meaningful error
    // Callers should use compressImageToBytes() instead on web
    throw UnsupportedError(
        'compressImage() returns File which is not supported on web. '
        'Use compressImageToBytes() instead for web platform.');
  }

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
  if (await outFile.exists()) {
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

/// Compress image and return bytes (preferred for web platform)
/// Only compresses if file size is greater than 1MB
Future<List<int>> compressImageToBytes(PlatformFile file,
    {int quality = 70}) async {
  const int oneMB = 1024 * 1024; // 1MB in bytes

  if (kIsWeb) {
    if (file.bytes == null) {
      throw Exception('No bytes available for web compression');
    }

    final originalSize = file.bytes!.length;
    final fileName = file.name;

    // Check if file is less than 1MB - no compression needed
    if (originalSize < oneMB) {
      log('File $fileName is ${(originalSize / 1024 / 1024).toStringAsFixed(2)} MB - skipping compression');
      return file.bytes!;
    }

    final extension = p.extension(fileName).toLowerCase();

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
        format = CompressFormat.jpeg;
        break;
      case '.webp':
        format = CompressFormat.webp;
        break;
      default:
        format = CompressFormat.jpeg;
    }

    log('File size ${(originalSize / 1024 / 1024).toStringAsFixed(2)} MB > 1MB - compressing image: $fileName with format $format');

    try {
      final result = await FlutterImageCompress.compressWithList(
        file.bytes!,
        quality: quality,
        format: format,
        minWidth: 500,
        minHeight: 500,
        keepExif: false,
      );

      final compressedSize = result.length;

      log('Original size: ${(originalSize / 1024 / 1024).toStringAsFixed(2)} MB');
      log('Compressed size: ${(compressedSize / 1024 / 1024).toStringAsFixed(2)} MB');
      log('Compression ratio: ${(compressedSize / originalSize * 100).toStringAsFixed(1)}%');

      return result;
    } catch (e) {
      log('Error compressing image to bytes: $e');
      // Return original bytes if compression fails
      return file.bytes!;
    }
  } else {
    // For non-web platforms, read file and compress
    final filePath = file.path;
    if (filePath == null) {
      throw Exception('No file path available for compression');
    }

    final fileBytes = await File(filePath).readAsBytes();
    final originalSize = fileBytes.length;

    // Check if file is less than 1MB - no compression needed
    if (originalSize < oneMB) {
      log('File ${p.basename(filePath)} is ${(originalSize / 1024 / 1024).toStringAsFixed(2)} MB - skipping compression');
      return fileBytes;
    }

    final extension = p.extension(filePath).toLowerCase();

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
        format = CompressFormat.jpeg;
        break;
      case '.webp':
        format = CompressFormat.webp;
        break;
      default:
        format = CompressFormat.jpeg;
    }

    log('File size ${(originalSize / 1024 / 1024).toStringAsFixed(2)} MB > 1MB - compressing image from file: ${p.basename(filePath)}');

    try {
      final result = await FlutterImageCompress.compressWithList(
        fileBytes,
        quality: quality,
        format: format,
        minWidth: 500,
        minHeight: 500,
        keepExif: false,
      );

      final compressedSize = result.length;
      log('Original size: ${(originalSize / 1024 / 1024).toStringAsFixed(2)} MB');
      log('Compressed size: ${(compressedSize / 1024 / 1024).toStringAsFixed(2)} MB');
      log('Compression ratio: ${(compressedSize / originalSize * 100).toStringAsFixed(1)}%');

      return result;
    } catch (e) {
      log('Error compressing image to bytes: $e');
      return fileBytes;
    }
  }
}
