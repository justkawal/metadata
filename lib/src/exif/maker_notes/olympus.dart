part of metadata;

///
///Extracts Olympus flavored Makernotes.
///
Map _extractMakerNotesOlympus(Uint8List data, int makernoteOffset,
    int tiffOffset, _Exif metadataReference) {
  return _makerNotFunction(
      data, makernoteOffset, tiffOffset, metadataReference, _OLYMPUS_TAGS);
}
