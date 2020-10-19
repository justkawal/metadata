part of metadata;

///
/// Extracts Fujifilm flavored Makernotes
///
Map _extractMakerNotesFujiFilm(Uint8List data, int makernoteOffset,
    int tiffOffset, _Exif metadataReference) {
  var makernoteData = {};

  // Start of the Fujifilm flavored Makernote data is determined by the four
  // bytes following the Makernote vendor name
  var ifdOffset = makernoteOffset + getLong(data, makernoteOffset + 8, false);

  // Get the number of entries and extract them
  var numberOfEntries = getShort(data, ifdOffset, false);

  for (var i = 0; i < numberOfEntries; i++) {
    var exifEntry = metadataReference._extractExifEntry(data,
        (ifdOffset + 2 + (i * 12)), makernoteOffset, false, _FUJI_FILM_TAGS);
    if (exifEntry != null && exifEntry.tagName != null) {
      makernoteData[exifEntry.tagName] = exifEntry.value;
    }
  }

  return makernoteData;
}
