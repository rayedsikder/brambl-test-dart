import 'dart:typed_data';

import 'package:brambl_dart/brambl_dart.dart';
import 'package:brambl_dart/src/common/functional/either.dart';
import 'package:brambl_dart/src/utils/extensions.dart';
import 'package:collection/collection.dart';
import 'package:fast_base58/fast_base58.dart';

sealed class EncodingError implements Exception {}

class InvalidChecksum implements EncodingError {}

class InvalidInputString implements EncodingError {}

sealed class EncodingDefinition {
  String encodeToBase58(Uint8List array);
  String encodeToHex(Uint8List array);

  Either<EncodingError, Uint8List> decodeFromBase58(String b58);
  Either<EncodingError, Uint8List> decodeFromHex(String hex);

  String encodeToBase58Check(Uint8List payload);
  Either<EncodingError, Uint8List> decodeFromBase58Check(String b58);
}

class Encoding implements EncodingDefinition {
  @override
   String encodeToBase58(Uint8List array) => Base58Encode(array);

  @override
  String encodeToBase58Check(Uint8List payload) {
    final checksum = SHA256().hash(payload).sublist(0, 4);
    return encodeToBase58(payload..addAll(checksum));
  }

  @override
  Either<EncodingError, Uint8List> decodeFromBase58(String b58) => Either.right(Base58Decode(b58).toUint8List());

  @override
  Either<EncodingError, Uint8List> decodeFromBase58Check(String b58) {
    try {
      final decoded = decodeFromBase58(b58).getOrThrow(exception: EncodingError);
      final (payload, errorCheckingCode) = decoded.splitAt(decoded.length - 4);
      final (p, ecc) = (payload.toUint8List(), errorCheckingCode.toUint8List());
      final expectedErrorCheckingCode = SHA256().hash(p).sublist(0, 4);
      final condition = ListEquality().equals(ecc, expectedErrorCheckingCode);
      final result = Either.conditional(condition, left: InvalidChecksum(), right: p);
      return result;
    } catch (e) {
      return Either.left(InvalidChecksum());
    }
  }

  @override
  String encodeToHex(Uint8List array) => array.toHexString();

  @override
  Either<EncodingError, Uint8List> decodeFromHex(String hex) => Either.right(hex.toHexUint8List());
}
