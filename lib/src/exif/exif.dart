part of metadata;

class _Exif {
  String imageType;
  bool _isBigEndian = false;
  int _makernoteOffset;

  var _exifData = {
    'image': {},
    'thumbnail': {},
    'exif': {},
    'gps': {},
    'interoperability': {},
    'makernote': {}
  };

  CallBack exifData(Uint8List exif_buffer) {
    _init();
    if (exif_buffer == null || exif_buffer.isEmpty) {
      return CallBack(
          Exception(
              'You have to provide an image or exif_buffer, it is pretty hard to extract Exif data from nothing...'),
          _exifData);
    } else {
      var val, error;
      try {
        val = _processImage(exif_buffer);
      } catch (e) {
        error = Exception(e.toString());
      }
      return CallBack(error, val);
    }
  }

  void _init() {
    imageType = _makernoteOffset = null;
    _isBigEndian = false;
    _exifData = {
      'image': {},
      'thumbnail': {},
      'exif': {},
      'gps': {},
      'interoperability': {},
      'makernote': {}
    };
  }

  Map<String, dynamic> _processImage(Uint8List data) {
    var offset = 0;
    if (2 <= data.length && data[0] == 0xFF && data[1] == 0xD8) {
      imageType = 'JPEG';
    } else {
      throw Exception(
          'The given image is not a JPEG and thus unsupported right now.');
    }
    offset += 2;

    try {
      while (offset < data.length) {
        if (data[offset++] != 0xFF) {
          throw Exception(
              'Invalid marker found at offset ${--offset} . Expected 0xFF but found 0x${offset < data.length ? data[offset].toRadixString(16).toUpperCase() : ''} .');
        }
        if (offset < data.length && data[offset] == 0xE1) {
          offset++;
          var _exifData = extractExifData(
              data, offset + 2, getShort(data, offset, true) - 2);
          //callback(CallBack(null, _exifData));
          return _exifData;
        } else {
          offset++;
          offset += getShort(data, offset, true);
        }
      }
    } catch (error) {
      throw Exception(error.toString());
    }
    throw Exception('No Exif segment found in the given image.');
  }

  Map<String, dynamic> extractExifData(Uint8List data, int start, int length) {
    var self = this;
    var tiffOffset = start + 6;
    var ifdOffset, numberOfEntries;

    // Exif data always starts with Exif\0\0

    var valueStr = utf8.decode(data.sublist(start, tiffOffset));
    if (valueStr.length < 4 || valueStr.substring(0, 4) != 'Exif') {
      throw Exception('The Exif data ist not valid.');
    }

    // After the Exif start we either have 0x4949 if the following data is
    // stored in big endian or 0x4D4D if it is stored in little endian
    if (getShort(data, tiffOffset) == 0x4949) {
      _isBigEndian = false;
    } else if (getShort(data, tiffOffset) == 0x4D4D) {
      _isBigEndian = true;
    } else {
      throw Exception(
          'Invalid TIFF data! Expected 0x4949 or 0x4D4D at offset ' +
              (tiffOffset).toString() +
              ' but found 0x' +
              data[tiffOffset].toRadixString(16).toUpperCase() +
              data[tiffOffset + 1].toRadixString(16).toUpperCase() +
              '.');
    }
    var f = getShort(data, tiffOffset + 2, _isBigEndian);
    // Valid TIFF headers always have 0x002A here
    if (f != 0x002A) {
      var expected = (_isBigEndian) ? '0x002A' : '0x2A00';
      throw Exception('Invalid TIFF data! Expected ' +
          expected +
          ' at offset ' +
          (tiffOffset + 2).toString() +
          ' but found 0x' +
          data[tiffOffset + 2].toRadixString(16).toUpperCase() +
          data[tiffOffset + 3].toRadixString(16).toUpperCase() +
          '.');
    }

    ///******************************* IFD0 **********************************/

    // Offset to IFD0 which is always followed by two bytes with the amount of
    // entries in this IFD
    ifdOffset = tiffOffset + getLong(data, tiffOffset + 4, _isBigEndian);
    numberOfEntries = getShort(data, ifdOffset, _isBigEndian);

    // Each IFD entry consists of 12 bytes which we loop through and extract
    // the data from
    for (var i = 0; i < numberOfEntries; i++) {
      var y = (ifdOffset + 2 + (i * 12));
      var exifEntry = self._extractExifEntry(
          data, y, tiffOffset, _isBigEndian, _ExifImageTAGS.exif);
      if (exifEntry != null && exifEntry.tagName != null) {
        var value = (exifEntry.value is List && exifEntry.value.length == 1)
            ? exifEntry.value[0]
            : exifEntry.value;
        _exifData['image'][exifEntry.tagName] = value;
      }
    }

    ///******************************* IFD1 **********************************/
    // Check if there is an offset for IFD1. If so it is always followed by two
    // bytes with the amount of entries in this IFD, if not there is no IFD1
    var nextIfdOffset =
        getLong(data, ifdOffset + 2 + (numberOfEntries * 12), _isBigEndian);
    if (nextIfdOffset != 0x00000000) {
      ifdOffset = tiffOffset + nextIfdOffset;
      numberOfEntries = getShort(data, ifdOffset, _isBigEndian);

      // Each IFD entry consists of 12 bytes which we loop through and extract
      // the data from
      for (var i = 0; i < numberOfEntries; i++) {
        var exifEntry = self._extractExifEntry(data, (ifdOffset + 2 + (i * 12)),
            tiffOffset, _isBigEndian, _ExifImageTAGS.exif);
        if (exifEntry != null && exifEntry.tagName != null) {
          var value = (exifEntry.value is List && exifEntry.value.length == 1)
              ? exifEntry.value[0]
              : exifEntry.value;
          _exifData['thumbnail'][exifEntry.tagName] = value;
        }
      }
    }

    ///***************************** EXIF IFD ********************************/

    // Look for a pointer to the Exif IFD in IFD0 and extract information from
    // it if available
    if (_exifData['image'] != null &&
        _exifData['image'][_ExifImageTAGS.exif[0x8769]] != null) {
      ifdOffset = tiffOffset + _exifData['image'][_ExifImageTAGS.exif[0x8769]];
      numberOfEntries = getShort(data, ifdOffset, _isBigEndian);

      // Each IFD entry consists of 12 bytes which we loop through and extract
      // the data from
      for (var i = 0; i < numberOfEntries; i++) {
        var exifEntry = self._extractExifEntry(data, (ifdOffset + 2 + (i * 12)),
            tiffOffset, _isBigEndian, _ExifImageTAGS.exif);
        if (exifEntry != null && exifEntry.tagName != null) {
          var value = (exifEntry.value is List && exifEntry.value.length == 1)
              ? exifEntry.value[0]
              : exifEntry.value;
          _exifData['exif'][exifEntry.tagName] = value;
        }
      }
    }

    ///****************************** GPS IFD ********************************/

    // Look for a pointer to the GPS IFD in IFD0 and extract information from
    // it if available
    var t = _ExifImageTAGS.exif[0x8825];
    var gpsifdOffset =
        _exifData['image'] == null ? null : _exifData['image'][t];
    if (gpsifdOffset != null && gpsifdOffset > 0) {
      ifdOffset = tiffOffset + _exifData['image'][t];
      numberOfEntries = getShort(data, ifdOffset, _isBigEndian);

      // Each IFD entry consists of 12 bytes which we loop through and extract
      // the data from
      for (var i = 0; i < numberOfEntries; i++) {
        var exifEntry = self._extractExifEntry(data, (ifdOffset + 2 + (i * 12)),
            tiffOffset, _isBigEndian, _ExifImageTAGS.gps);
        if (exifEntry != null && exifEntry.tagName != null) {
          var value = (exifEntry.value is List && exifEntry.value.length == 1)
              ? exifEntry.value[0]
              : exifEntry.value;
          _exifData['gps'][exifEntry.tagName] = value;
        }
      }
    }

    ///*********************** Interoperability IFD **************************/

    // Look for a pointer to the interoperatbility IFD in the Exif IFD and
    // extract information from it if available
    if (_exifData['exif'] != null &&
        _exifData['exif'][_ExifImageTAGS.exif[0xA005]] != null) {
      ifdOffset = tiffOffset + _exifData['exif'][_ExifImageTAGS.exif[0xA005]];
      numberOfEntries = getShort(data, ifdOffset, _isBigEndian);

      // Each IFD entry consists of 12 bytes which we loop through and extract
      // the data from
      for (var i = 0; i < numberOfEntries; i++) {
        var exifEntry = self._extractExifEntry(data, (ifdOffset + 2 + (i * 12)),
            tiffOffset, _isBigEndian, _ExifImageTAGS.exif);
        if (exifEntry != null && exifEntry.tagName != null) {
          var value = (exifEntry.value is List && exifEntry.value.length == 1)
              ? exifEntry.value[0]
              : exifEntry.value;
          _exifData['interoperability'][exifEntry.tagName] = value;
        }
      }
    }

    ///*************************** Makernote IFD *****************************/

    // Look for Makernote data in the Exif IFD, check which type of proprietary
    // Makernotes the image contains, load the respective functionality and
    // start the extraction

    // check explicitly for the getString method in case somehow this isn't
    // a buffer. Found this in an image in the wild
    var makerNoteValue1 = _exifData['exif'][_ExifImageTAGS.exif[0x927C]];
    if (makerNoteValue1 != null) {
      Uint8List makerNoteValue;

      if (makerNoteValue1.runtimeType is String) {
        makerNoteValue = utf8.encode(makerNoteValue1);
      }

      if (makerNoteValue.runtimeType is Uint8List) {
        Function extractMakernotes;

        // Check the header to see what kind of Makernote we are dealing with
        if (utf8.decode(makerNoteValue.sublist(0, 7)) == 'OLYMP\x00\x01' ||
            utf8.decode(makerNoteValue.sublist(0, 7)) == 'OLYMP\x00\x02') {
          extractMakernotes = _extractMakerNotesOlympus;
        } else if (utf8.decode(makerNoteValue.sublist(0, 7)) ==
            'AGFA \x00\x01') {
          extractMakernotes = _extractMakerNotesAgfa;
        } else if (utf8.decode(makerNoteValue.sublist(0, 8)) ==
            'EPSON\x00\x01\x00') {
          extractMakernotes = _extractMakerNotesEpson;
        } else if (utf8.decode(makerNoteValue.sublist(0, 8)) == 'FUJIFILM') {
          extractMakernotes = _extractMakerNotesFujiFilm;
        } else if (utf8.decode(makerNoteValue.sublist(0, 5)) == 'SANYO') {
          extractMakernotes = _extractMakerNotesSanyo;
        } else {
          // Makernotes are available but the format is not recognized so
          // an error message is added instead, this ain't the best
          // solution but should do for now
          _exifData['makernote']['error'] =
              'Unable to extract Makernote information as it is in an unsupported or unrecognized format.';
        }

        if (_exifData['makernote']['error'] == null) {
          _exifData['makernote'] =
              extractMakernotes(data, self._makernoteOffset, tiffOffset);
        }
      }
    }

    return _exifData;
  }

  _Entry _extractExifEntry(Uint8List data, int entryOffset, int tiffOffset,
      bool _isBigEndian, Map<int, Object> tags) {
    var self = this;
    var entry = _Entry(
        data.sublist(entryOffset, entryOffset + 2),
        null,
        null,
        getShort(data, entryOffset + 2, _isBigEndian),
        getLong(data, entryOffset + 4, _isBigEndian),
        null,
        null);

    entry.tagId = getShort(entry.tag, 0, _isBigEndian);

    // The tagId may correspond to more then one tagName so check which
    if (tags != null &&
        entry.tagId != null &&
        tags[entry.tagId] != null &&
        tags[entry.tagId] == 'Closure \'main_closure\'') {
      Function customFunction = tags[entry.tagId];
      entry.tagName = customFunction(entry);

      if (entry.tagName == null) {
        return null;
      }

      // The tagId corresponds to exactly one tagName
    } else if (tags != null && tags[entry.tagId] != null) {
      entry.tagName = tags[entry.tagId];

      // The tagId is not recognized
    } else {
      return null;
    }

    if (entry.components > data.length) {
      entry.components = 0;
      return entry;
    }

    switch (entry.format) {
      case 0x0001: // unsigned byte, 1 byte per component
        entry.valueOffset = (entry.components <= 4)
            ? entryOffset + 8
            : getLong(data, entryOffset + 8, _isBigEndian) + tiffOffset;

        var elements = List<dynamic>(entry.components);
        for (var i = 0; i < entry.components; i++) {
          elements[i] = getByte(data, entry.valueOffset + i);
        }
        entry.value = elements;
        break;

      case 0x0002: // ascii strings, 1 byte per component
        entry.valueOffset = (entry.components <= 4)
            ? entryOffset + 8
            : getLong(data, entryOffset + 8, _isBigEndian) + tiffOffset;
        var entryValue = List<int>.from(data);

        entry.value =
            entryValue.convertToString(entry.valueOffset, entry.components);
        if (entry.value[entry.value.length - 1] == '\u0000') {
          // Trim null terminated strings
          entry.value = entry.value.substring(0, entry.value.length - 1);
        }
        break;

      case 0x0003: // unsigned short, 2 byte per component
        entry.valueOffset = (entry.components <= 2)
            ? entryOffset + 8
            : getLong(data, entryOffset + 8, _isBigEndian) + tiffOffset;
        var elements = List<dynamic>(entry.components);
        for (var i = 0; i < entry.components; i++) {
          elements[i] = getShort(data, entry.valueOffset + i * 2, _isBigEndian);
        }
        entry.value = elements;
        break;

      case 0x0004: // unsigned long, 4 byte per component
        entry.valueOffset = (entry.components == 1)
            ? entryOffset + 8
            : getLong(data, entryOffset + 8, _isBigEndian) + tiffOffset;
        var elements = List(entry.components);
        for (var i = 0; i < entry.components; i++) {
          elements[i] = getLong(data, entry.valueOffset + i * 4, _isBigEndian);
        }
        entry.value = elements;
        break;

      case 0x0005: // unsigned rational, 8 byte per component (4 byte numerator and 4 byte denominator)
        entry.valueOffset =
            getLong(data, entryOffset + 8, _isBigEndian) + tiffOffset;

        var elements = List<dynamic>(entry.components);
        for (var i = 0; i < entry.components; i++) {
          elements[i] =
              (getLong(data, entry.valueOffset + i * 8, _isBigEndian) /
                  getLong(data, entry.valueOffset + i * 8 + 4, _isBigEndian));
        }
        entry.value = elements;
        break;

      case 0x0006: // signed byte, 1 byte per component
        entry.valueOffset = (entry.components <= 4)
            ? entryOffset + 8
            : getLong(data, entryOffset + 8, _isBigEndian) + tiffOffset;

        var elements = List<dynamic>(entry.components);
        for (var i = 0; i < entry.components; i++) {
          elements[i] = getSignedByte(data, entry.valueOffset + i);
        }
        entry.value = elements;
        break;

      case 0x0007: // undefined, 1 byte per component
        entry.valueOffset = (entry.components <= 4)
            ? entryOffset + 8
            : getLong(data, entryOffset + 8, _isBigEndian) + tiffOffset;

        var elements = <dynamic>[];
        elements.addAll(data.sublist(
            entry.valueOffset, entry.valueOffset + entry.components));
        entry.value = elements;
        break;

      case 0x0008: // signed short, 2 byte per component
        entry.valueOffset = (entry.components <= 2)
            ? entryOffset + 8
            : getLong(data, entryOffset + 8, _isBigEndian) + tiffOffset;

        var elements = List<dynamic>(entry.components);
        for (var i = 0; i < entry.components; i++) {
          elements[i] =
              getSignedShort(data, entry.valueOffset + i * 2, _isBigEndian);
        }
        entry.value = elements;
        break;

      case 0x0009: // signed long, 4 byte per component
        entry.valueOffset = (entry.components == 1)
            ? entryOffset + 8
            : getLong(data, entryOffset + 8, _isBigEndian) + tiffOffset;
        var elements = List<dynamic>(entry.components);
        for (var i = 0; i < entry.components; i++) {
          elements[i] =
              (getSignedLong(data, entry.valueOffset + i * 4, _isBigEndian));
        }
        entry.value = elements;
        break;

      case 0x000A: // signed rational, 8 byte per component (4 byte numerator and 4 byte denominator)
        entry.valueOffset =
            getLong(data, entryOffset + 8, _isBigEndian) + tiffOffset;
        var elements = List<dynamic>(entry.components);
        for (var i = 0; i < entry.components; i++) {
          elements[i] = (getSignedLong(
                  data, entry.valueOffset + i * 8, _isBigEndian) /
              getSignedLong(data, entry.valueOffset + i * 8 + 4, _isBigEndian));
        }
        entry.value = elements;
        break;
      default:
        return null;
    }

    // If this is the Makernote tag save its offset for later use
    if (entry.tagName == 'MakerNote') self._makernoteOffset = entry.valueOffset;

    return entry;
  }
}
