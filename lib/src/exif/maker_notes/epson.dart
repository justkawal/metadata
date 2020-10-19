part of metadata;

///
///Extracts EPSON flavored Makernotes which are equal to those of Olympus.
///
Map _extractMakerNotesEpson(Uint8List data, int makernoteOffset, int tiffOffset,
    _Exif metadataReference) {
  return _makerNotFunction(
      data, makernoteOffset, tiffOffset, metadataReference, _EPSON_TAGS);
}
