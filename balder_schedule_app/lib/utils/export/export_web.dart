// export_web.dart
import 'dart:convert';
import 'dart:js_interop';
import 'dart:typed_data';
import 'package:web/web.dart';

extension type Blob._(JSObject _) implements JSObject {
  external factory Blob(JSArray<JSAny> blobParts, JSObject? options);

  factory Blob.fromBytes(List<int> bytes) {
    final data = Uint8List.fromList(bytes).buffer.toJS;
    return Blob([data].toJS, null);
  }

  external JSArray<JSAny>? get blobParts;
  external JSObject? get options;
}

void exportData(List<Map<String, dynamic>> data) {
  final jsonData = jsonEncode(data);

  final jsString = [jsonData.toJS];

  final blob = Blob(jsString.toJS, null);

  final url = URL.createObjectURL(blob);

  HTMLAnchorElement anchor = document.createElement('a') as HTMLAnchorElement
    ..href = url
    ..download = 'lesson_data.json';

  anchor.click();

  URL.revokeObjectURL(url);
}
