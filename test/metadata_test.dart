import 'dart:convert';
import 'dart:io';
import 'package:metadata/metadata.dart';
import 'package:test/test.dart';

const path = './test/test_resources/';
void main() {
  testFile('test1');
  testFile('test2');
}

void testFile(String fileName) {
  test('Test file: $fileName', () {
    final file = File('${path}$fileName.jpg');
    final bytes = file.readAsBytesSync();
    final metadata = MetaData.exifData(bytes);
    final content = metadata.exifData;
    final didMatched = match(fileName, jsonEncode(content));
    expect(didMatched, true);
  });
}

bool match(String fileName, dynamic object) {
  final file_original = File('${path}$fileName-original.json');

  if (file_original.existsSync()) {
    final generated = jsonDecode(object);
    final original = jsonDecode(file_original.readAsStringSync());

    if (generated.toString() == original.toString()) {
      return true;
    }
  } else {
    throw Exception('Original file does not exist');
  }
  return false;
}
