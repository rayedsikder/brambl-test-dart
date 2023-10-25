import 'package:brambl_dart/brambl_dart.dart';
import 'package:brambl_dart/src/crypto/hash/hash.dart';
import 'package:brambl_dart/src/utils/extensions.dart';

void main() {
  /// encode String to blake2b256
  const input = "Foobar";

  Blake2b256().hash(input.toUtf8Uint8List());
}
