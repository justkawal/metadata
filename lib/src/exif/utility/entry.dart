part of metadata;

class _Entry {
  Uint8List _tag;
  int _tagId;
  String _tagName;
  int _format;
  int _components;
  int _valueOffset;
  dynamic _value;

  _Entry(
    this._tag,
    this._tagId,
    this._tagName,
    this._format,
    this._components,
    this._valueOffset,
    this._value,
  );

  Uint8List get tag => _tag;

  set tag(Uint8List _) => _tag = _;

  int get tagId => _tagId;

  set tagId(int val) => _tagId = val;

  String get tagName => _tagName;

  set tagName(String val) => _tagName = val;

  int get format => _format;

  set format(int val) => _format = val;

  int get components => _components;

  set components(int val) => _components = val;

  int get valueOffset => _valueOffset;

  set valueOffset(int val) => _valueOffset = val;

  dynamic get value => _value;

  set value(dynamic val) => _value = (val is List) ? List.from(val) : val;
}
