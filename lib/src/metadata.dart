part of metadata;

class MetaData {
  ///
  ///
  ///Reading image file
  ///````
  ///var image_file = '/my_path_to_image_file/image.png'; // image path
  ///var file = File(image_file);
  ///var imageBytes = file.readAsBytesSync();
  ///````
  ///
  ///Normal Usage (Without Callback)
  ///
  ///````
  /// CallBack result = MetaData.exifData(bytes);
  /// if (result.error == null) {
  ///   var content = result.exifData;
  ///   } else {
  ///   // Ooops Something went wrong.
  ///   print('File: $image_file, Error: ${result.error}');
  /// }
  ///
  ///````
  /// Or
  ///
  ///With Callback
  ///````
  /// MetaData.exifData(bytes, onValue: (CallBack result) {
  ///   if (result.error == null) {
  ///     var content = result.exifData;
  ///   } else {
  ///     // Ooops Something went wrong.
  ///     print('File: $image_file, Error: ${result.error}');
  ///   }
  /// });
  ///
  ///````
  static CallBack exifData(Uint8List bytes,
      {void Function(CallBack value)? onValue}) {
    var val = _Exif().exifData(bytes);
    if (onValue != null) {
      onValue(val);
    }
    return val;
  }

  ///
  ///Extract XMP data from image
  ///````
  /// var mapResult = MetaData.extractXMP(bytes);
  /// print(mapResult.toString());
  ///
  ///````
  static Map<String, dynamic> extractXMP(Uint8List bytes, {bool raw = false}) {
    var val;
    try {
      val = XMP.extract(bytes, raw: raw);
    } catch (e) {
      return Map<String, dynamic>.from({'error': e.toString()});
    }
    return val;
  }
}
