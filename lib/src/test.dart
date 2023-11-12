import 'package:brambldart/src/crypto/signing/ed25519/ed25519.dart';
import 'package:brambldart/src/crypto/signing/ed25519/ed25519_spec.dart';
import 'package:brambldart/src/crypto/signing/ed25519/ed25519.dart';
import 'package:convert/convert.dart';
import 'dart:typed_data';
import 'dart:core';
import 'package:brambldart/src/crypto/signing/eddsa/ec.dart';
import 'package:fixnum/src/int32.dart';

void main() {
  var myValue = 42;
  var hexString = '9d61b19deffd5a60ba844af492ec2cc44449c5697b326919703bac031cae7f60';
  List<int> bytes = hex.decode(hexString);
  Uint8List uint8List = Uint8List.fromList(bytes);
  var signingKey = SecretKey(uint8List);
  var getVerify = Ed25519();
  var value = getVerify.getVerificationKey(signingKey);
  // var ed25519 = eddsa.Ed25519();
  final pkBytes = Uint8List(32);
  // var verifyKey = ed25519.generatePublicKey(signingKey.bytes, 0, pkBytes, 0);
  print('return value of getVerification key ${value.bytes}');
  // EC().cmov(1, 0, [1, 2, 3, 4, 5], 0, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 0);
}