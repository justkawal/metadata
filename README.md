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
   <a href="https://www.paypal.me/kawal7415">  
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
 It is purely written in dart, So it can be used on server as well as on client.



# Table of Contents
  - [Installing](#lets-get-started)
  - [Usage](#usage)
    * [Imports](#imports)
    * [Read xlsx file](#read-xlsx-file)
    * [Read xlsx file from Asset Folder](#read-xlsx-from-flutters-asset-folder)
    * [Create xlsx file](#create-new-xlsx-file)
  - [Upcoming Features](#features-coming-in-next-version)
  - [Donate (Be the First one)](#donate-be-the-first-one)

# Lets Get Started

### 1. Depend on it
Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  metadata: ^1.1.5
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

### Read XLSX File

````dart
    var file = "path_to_pre_existing_image_file/image.jpg";
    var bytes = File(file).readAsBytesSync();
    
````

### Read XLSX from Flutter's Asset Folder

````dart
    import 'package:flutter/services.dart' show ByteData, rootBundle;
    
    /* Your blah blah code here */
    
    ByteData data = await rootBundle.load("assets/path_to_pre_existing_image_file/image.jpg";);
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    
````

### Extract Exif Data
    
````dart
    var result = MetaData.exifData(bytes);
    if (result.error == null) {
      var content = result.exifData; // exif data is available in contents
      saveFile(image, content);
    } else {
      print('File: $image.jpg, Error: ${result.error}');
    }
    
````

### Extract Exif Data
    
````dart
    MetaData.exifData(bytes, onValue: (CallBack result) {
      if (result.error == null) {
        var content = result.exifData;
        saveFile(image, content);
      } else {
        print('File: $image.jpg, Error: ${result.error}');
      }
    });
    
````

   
### Saving exif content into File

````dart
      void saveFile(String fileName, dynamic exifContent) {
          File('${path}$fileName.json').writeAsStringSync(jsonEncode(exifContent));
      }
    
````

## Features coming in next version
On-going implementation for future:
- metadata of audio and video files
- extracting file-types

#### Also checkout our other libraries: 
  - Excel **·······**> [Excel](https://www.github.com/justkawal/excel)
  - Protect **···············**> [Protect](https://www.github.com/justkawal/protect)
  - Text Animations **··**> [AnimatedText](https://www.github.com/justkawal/animated_text)
  - Translations **·······**> [Arb Translator](https://www.github.com/justkawal/arb_translator)

### Donate
Ooooops, My laptop is **slow**, but I'm not.
  - [Paypal](https://www.paypal.me/kawal7415)
  - Not having Paypal account ?? [Join Now](https://www.paypal.com/in/flref?refBy=Pzpaa7qp041602067472432) and both of us could earn **`$10`**
