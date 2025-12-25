// /// Stub file for dart:js_interop when running on non-web platforms
// /// This prevents compilation errors when web-only packages are imported on mobile

// // Stub classes for JS interop
// class JSObject {
//   dynamic callMethod(dynamic method, List<dynamic> args) {
//     throw UnsupportedError('JS interop not available on non-web platforms');
//   }
// }

// class JSPromise {
//   Future<dynamic> get toDart async {
//     throw UnsupportedError('JS interop not available on non-web platforms');
//   }
// }

// extension JSObjectExtension on Object {
//   JSObject get jsify =>
//       throw UnsupportedError('JS interop not available on non-web platforms');
// }

// extension StringToJS on String {
//   dynamic get toJS =>
//       throw UnsupportedError('JS interop not available on non-web platforms');
// }

// extension BoolToJS on bool {
//   dynamic get toJS =>
//       throw UnsupportedError('JS interop not available on non-web platforms');
// }
