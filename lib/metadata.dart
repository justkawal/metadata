library metadata;

import 'dart:convert';
import 'dart:typed_data';

part 'src/metadata.dart';

///
///Exif Part `START`
///
part 'src/exif/exif.dart';

// constants
part 'src/exif/constants/constants.dart';
part 'src/exif/constants/exif_image_tags.dart';

// utility
part 'src/exif/utility/buffer.dart';
part 'src/exif/utility/metadata_extension.dart';
part 'src/exif/utility/entry.dart';
part 'src/exif/utility/callback.dart';

// maker_notes
part 'src/exif/maker_notes/agfa.dart';
part 'src/exif/maker_notes/epson.dart';
part 'src/exif/maker_notes/fujifilm.dart';
part 'src/exif/maker_notes/maker_notes_function.dart';
part 'src/exif/maker_notes/sanyo.dart';
part 'src/exif/maker_notes/olympus.dart';
///
///Exif Part `END`
///
