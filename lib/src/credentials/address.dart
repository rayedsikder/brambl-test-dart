import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:fast_base58/fast_base58.dart';
import 'package:meta/meta.dart';
import 'package:mubrambl/src/utils/util.dart';

/// Represents an Topl address.
@immutable
class ToplAddress {
  /// The length of a Topl address, in bytes.
  static const addressByteLength = 40;

  final Uint8List addressBytes;

  /// An ethereum address from the raw address bytes.
  const ToplAddress(this.addressBytes)
      : assert(addressBytes.length == addressByteLength);

  /// Constructs a Topl address from a public key. The address is formed by
  /// appending the networkPrefix, the propositionType, the last 34 bytes of the Blake2b hash of the public key + the 4 byte checksum.
  factory ToplAddress.fromPublicKey(
      Uint8List publicKey, String networkPrefix, String propositionType) {
    return ToplAddress(generatePubKeyHashAddress(
        publicKey, networkPrefix, propositionType)['address'] as Uint8List);
  }

  /// Parses a Topl address from the Base58 representation.
  factory ToplAddress.fromBase58(String base58) {
    return ToplAddress(Uint8List.fromList(Base58Decode(base58)));
  }

  /// A hexadecimal representation of this address, padded to a length of 40
  /// characters or 20 bytes, and prefixed with "0x".
  String get base58 => Base58Encode(addressBytes);

  @override
  String toString() => base58;

  @override
  bool operator ==(other) {
    return identical(this, other) ||
        (other is ToplAddress &&
            const ListEquality().equals(addressBytes, other.addressBytes));
  }

  @override
  int get hashCode {
    return hex.hashCode;
  }
}
