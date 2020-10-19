part of metadata;

///
///Extracts Sanyo flavored Makernotes.
///
Map _extractMakerNotesSanyo(Uint8List data, int makernoteOffset, int tiffOffset,
    _Exif metadataReference) {
  return _makerNotFunction(
      data, makernoteOffset, tiffOffset, metadataReference, _SANYO_TAGS);
}
