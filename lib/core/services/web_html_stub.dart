// /// Stub file for dart:html when running on non-web platforms
// /// This prevents compilation errors when web-only packages are imported on mobile

// class Window {
//   Location get location => Location();

//   bool hasProperty(dynamic property) {
//     throw UnsupportedError('HTML API not available on non-web platforms');
//   }

//   dynamic getProperty(dynamic property) {
//     throw UnsupportedError('HTML API not available on non-web platforms');
//   }

//   dynamic callMethod(dynamic method, List<dynamic> args) {
//     throw UnsupportedError('HTML API not available on non-web platforms');
//   }
// }

// class Location {
//   String get hostname =>
//       throw UnsupportedError('HTML API not available on non-web platforms');
// }

// class Document {
//   HeadElement? get head => HeadElement();

//   Element? querySelector(String selector) {
//     throw UnsupportedError('HTML API not available on non-web platforms');
//   }

//   Element createElement(String tagName) {
//     throw UnsupportedError('HTML API not available on non-web platforms');
//   }
// }

// class HeadElement {
//   void appendChild(Element element) {
//     throw UnsupportedError('HTML API not available on non-web platforms');
//   }
// }

// class Element {
//   String? src;
//   bool? async;

//   void remove() {
//     throw UnsupportedError('HTML API not available on non-web platforms');
//   }

//   void addEventListener(String type, dynamic listener) {
//     throw UnsupportedError('HTML API not available on non-web platforms');
//   }
// }

// class HTMLScriptElement extends Element {
//   // Inherits properties from Element
// }

// // Global objects
// final window = Window();
// final document = Document();
