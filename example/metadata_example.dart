import 'dart:convert';
import 'package:metadata/metadata.dart';
import 'dart:io';

const path = '/Users/kawal/Desktop/metadata/example/testdata/';
const images = [
  'test1',
  'test2',
];
void main() {
  withCallBack();
  withNormalUsage();
}

void withNormalUsage() {
  images.forEach((image) {
    var file = File('${path}$image.jpg');
    var bytes = file.readAsBytesSync();
    var callBack = MetaData.exifData(bytes);
    if (callBack.error == null) {
      var content = callBack.exifData;
      saveFile(image, content);
    } else {
      print('File: $image.jpg, Error: ${callBack.error}');
    }
  });
}

void withCallBack() {
  images.forEach((image) {
    var file = File('${path}$image.jpg');
    var bytes = file.readAsBytesSync();
    MetaData.exifData(bytes, onValue: (CallBack result) {
      if (result.error == null) {
        var content = result.exifData;
        saveFile(image, content);
      } else {
        print('File: $image.jpg, Error: ${result.error}');
      }
    });
  });
}

void saveFile(String fileName, dynamic contents) =>
    File('${path}$fileName.json').writeAsStringSync(jsonEncode(contents));
