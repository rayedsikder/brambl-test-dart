import 'package:brambl_dart/brambl_dart.dart';
import 'package:test/test.dart';
import 'package:topl_common/genus/data_extensions.dart';
import 'package:topl_common/proto/quivr/models/shared.pb.dart';

void main() {
  group('Int128SyntaxSpec', () {
    final mockLong = 100;
    final mockBigInt = BigInt.from(mockLong);
    final mockInt128 = Int128(value: mockBigInt.toUint8List());

    test('int128AsBigInt', () {
      expect(mockInt128.toBigInt(), mockBigInt);
    });

    test('bigIntAsInt128', () {
      expect(Int128(value: mockBigInt.toUint8List()), mockInt128);
    });

    test('longAsInt128', () {
      expect(Int128(value: mockLong.toBytes), mockInt128);
    });
  });
}
