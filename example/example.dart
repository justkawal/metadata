import 'dart:convert';
import 'dart:io';

import 'package:metadata/metadata.dart';

const path = './example/testdata/';
const images = [
  'test1',
  'test2',
];
void main() {
  withCallBack();
  withNormalUsage();
}

void matchTwoFiles() {
  images.forEach((imageName) {
    final file_generated = File('${path}$imageName-generated.json');
    final file_original = File('${path}$imageName.json');

    // match the 2 json files
    if (file_generated.existsSync() && file_original.existsSync()) {
      final generated = jsonDecode(file_generated.readAsStringSync());
      final original = jsonDecode(file_original.readAsStringSync());

      if (generated.toString() == original.toString()) {
        print('The files are the same');
      } else {
        print('The files are different');
      }
    } else {
      print('One of the files does not exist');
    }
  });
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

void saveFile(String fileName, dynamic contents) {
  File('${path}$fileName-generated.json')
      .writeAsStringSync(jsonEncode(contents));
}
