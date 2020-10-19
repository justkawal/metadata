part of metadata;

extension CustomExtension on List<int> {
  String convertToString(int offset, int length) {
    var string = <String>[];
    for (var i = offset; i < offset + length; i++) {
      string.add(String.fromCharCode(this[i]));
    }
    return string.join('');
  }
}
