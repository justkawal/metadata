part of metadata;

///
/// Extracts AGFA flavored Makernotes which are equal to those of Olympus.
///
Map _extractMakerNotesAgfa(Uint8List data, int makernoteOffset, int tiffOffset,
    _Exif metadataReference) {
  return _makerNotFunction(
      data, makernoteOffset, tiffOffset, metadataReference, _AGFA_TAGS);
}
