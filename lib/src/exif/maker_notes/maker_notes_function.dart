part of metadata;

Map _makerNotFunction(Uint8List data, int makernoteOffset, int tiffOffset,
    _Exif metadataReference, Map<int, Object> tags) {
  var makernoteData = {};

  // Agfa flavored Makernote data starts after eight bytes
  var ifdOffset = makernoteOffset + 8;

  // Get the number of entries and extract them
  var numberOfEntries =
      getShort(data, ifdOffset, metadataReference._isBigEndian);

  var makernoteEndianness = metadataReference._isBigEndian;
  if (numberOfEntries > 255) {
    makernoteEndianness = !makernoteEndianness;
    numberOfEntries = getShort(data, ifdOffset, makernoteEndianness);
  }

  for (var i = 0; i < numberOfEntries; i++) {
    var exifEntry = metadataReference._extractExifEntry(data,
        (ifdOffset + 2 + (i * 12)), tiffOffset, makernoteEndianness, tags);
    if (exifEntry != null && exifEntry.tagName != null) {
      makernoteData[exifEntry.tagName] = exifEntry.value;
    }
  }

  return makernoteData;
}
