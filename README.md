# metadata
  
  <a href="https://flutter.io">  
    <img src="https://img.shields.io/badge/Platform-Flutter-yellow.svg"  
      alt="Platform" />  
  </a> 
   <a href="https://pub.dartlang.org/packages/metadata">  
    <img src="https://img.shields.io/pub/v/metadata.svg"  
      alt="Pub Package" /> 
  </a>
   <a href="https://opensource.org/licenses/MIT">  
    <img src="https://img.shields.io/badge/License-MIT-red.svg"  
      alt="License: MIT" />  
  </a>  
   <a href="https://www.paypal.me/justkawal">
    <img src="https://img.shields.io/badge/Donate-PayPal-green.svg"  
      alt="Donate" />  
  </a>
   <a href="https://github.com/justkawal/metadata/issues">  
    <img src="https://img.shields.io/github/issues/justkawal/metadata"  
      alt="Issue" />  
  </a> 
   <a href="https://github.com/justkawal/metadata/network">  
    <img src="https://img.shields.io/github/forks/justkawal/metadata"  
      alt="Forks" />  
  </a> 
   <a href="https://github.com/justkawal/metadata/stargazers">  
    <img src="https://img.shields.io/github/stars/justkawal/metadata"  
      alt="Stars" />  
  </a>
  <br>
  <br>
 
 [metadata](https://www.pub.dev/packages/metadata) is a dart library to extract exif data of the images.


# Table of Contents
  - [Installing](#lets-get-started)
  - [Usage](#usage)
    * [Imports](#imports)
    * [Read image file](#read-image-file)
    * [Read image file from Asset Folder](#read-image-from-flutters-asset-folder)
    * [Extract Exif Data](#extract-exif-data)
    * [Extract Exif Data with callback](#extract-exif-data-with-callback)
    * [Saving Exif Content into File](#saving-exif-content-into-file)
  - [Upcoming Features](#features-coming-in-next-version)
  - [Donate (Be the First one)](#donate)

# Lets Get Started

### 1. Depend on it
Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  metadata: any
```

### 2. Install it

You can install packages from the command line:

with `pub`:

```css
$  pub get
```

### 3. Import it

Now in your `Dart` code, you can use: 

````dart
    import 'package:metadata/metadata.dart';
````

# Usage

### Imports

````dart
    import 'package:metadata/metadata.dart';
    
````

### Read Image File

````dart
    var file = "path_to_pre_existing_image_file/image.jpg";
    var bytes = File(file).readAsBytesSync();
    
````

### Read Image from Flutter's Asset Folder

````dart
    import 'package:flutter/services.dart' show ByteData, rootBundle;
    
    /* Your awesome code here */
    
    ByteData data = await rootBundle.load("assets/path_to_pre_existing_image_file/image.jpg";);
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    
````

### Extract Exif Data
    
````dart
    var result = MetaData.exifData(bytes);
    if (result.error == null) {
      var content = result.exifData; // exif data is available in contents
      saveFile(image_name, content);
    } else {
      print('File: $image.jpg, Error: ${result.error}');
    }
    
````

### Extract Exif Data with callback
    
````dart
    MetaData.exifData(bytes, onValue: (CallBack result) {
      if (result.error == null) {
        var content = result.exifData;
        saveFile(image_name, content);
      } else {
        print('File: $image.jpg, Error: ${result.error}');
      }
    });
    
````
### Extract XMP Data 
    
````dart
    var mapResult = MetaData.extractXMP(bytes);
    print(mapResult.toString());
    saveFile(image_name, mapResult);
    
````

### Saving exif content into File

````dart
      void saveFile(String fileName, dynamic exifContent) {
          File('${path}$fileName.json').writeAsStringSync(jsonEncode(exifContent));
      }
    
````
