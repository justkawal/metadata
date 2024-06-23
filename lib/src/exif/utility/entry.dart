part of metadata;

class _Entry {
  Uint8List tag;
  int? tagId;
  String? tagName;
  int format;
  int components;
  int? valueOffset;
  dynamic _value;

  _Entry(
    this.tag,
    this.tagId,
    this.tagName,
    this.format,
    this.components,
    this.valueOffset,
    this._value,
  );

  dynamic get value => _value;

  set value(dynamic val) => _value = (val is List) ? List.from(val) : val;
}
