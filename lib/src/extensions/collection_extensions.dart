import 'dart:convert';
import 'dart:developer';

extension MapDynamicExt on Map<String, dynamic> {
  String toPrettyJson() {
    return "\n${"=" * 100}\n|| Pretty Map ||:\n${"-" * 100}\n${const JsonEncoder.withIndent("\t").convert(this)}\n${"-" * 100}\n";
  }

  void toPrintPrettyJson() {
    log(toPrettyJson());
  }

}

extension ListDynamicExt on List<dynamic> {
  String toPrettyJson() {
    return "\n${"=" * 100}\n|| Pretty List ||:\n${"-" * 100}\n${const JsonEncoder.withIndent("\t").convert(this)}\n${"-" * 100}\n";
  }

  void toPrintPrettyJson() {
    log(toPrettyJson());
  }

}

extension IterableIndexed<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) sync* {
    var i = 0;
    for (final element in this) {
      yield f(element, i++);
    }
  }
}