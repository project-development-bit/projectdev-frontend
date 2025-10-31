// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html' as html;

/// Web implementation for opening URLs in new tabs
Future<void> openUrlInNewTab(String url) async {
  html.window.open(url, '_blank');
}