part of metadata;

int getByte(Uint8List buffer, int offset) {
  return offset < buffer.length ? buffer[offset] : null;
}

int getSignedByte(Uint8List buffer, int offset) {
  return (buffer[offset] > 127) ? buffer[offset] - 256 : buffer[offset];
}

int getShort(Uint8List buffer, int offset, [bool bigEndian = false]) {
  var copy = Uint8List.fromList(buffer);
  var shortValue = copy.buffer
      .asByteData()
      .getUint16(offset, !bigEndian ? Endian.little : Endian.big);

  return shortValue;
}

int getSignedShort(Uint8List buffer, int offset, bigEndian) {
  var shortVal = (bigEndian)
      ? (buffer[offset] << 8) + buffer[offset + 1]
      : (buffer[offset + 1] << 8) + buffer[offset];
  return (shortVal > 32767) ? shortVal - 65536 : shortVal;
}

int getLong(Uint8List buffer, int offset, bigEndian) {
  var longVal = (bigEndian)
      ? (((((buffer[offset] << 8) + buffer[offset + 1]) << 8) +
                  buffer[offset + 2]) <<
              8) +
          buffer[offset + 3]
      : (((((buffer[offset + 3] << 8) + buffer[offset + 2]) << 8) +
                  buffer[offset + 1]) <<
              8) +
          buffer[offset];
  return (longVal < 0) ? longVal + 4294967296 : longVal;
}

int getSignedLong(Uint8List buffer, int offset, bigEndian) {
  var longVal = (bigEndian)
      ? (((((buffer[offset] << 8) + buffer[offset + 1]) << 8) +
                  buffer[offset + 2]) <<
              8) +
          buffer[offset + 3]
      : (((((buffer[offset + 3] << 8) + buffer[offset + 2]) << 8) +
                  buffer[offset + 1]) <<
              8) +
          buffer[offset];
  return (longVal > 2147483647) ? longVal - 4294967296 : longVal;
}
