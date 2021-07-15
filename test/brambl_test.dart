import 'package:fast_base58/fast_base58.dart';
import 'package:mubrambl/src/utils/address_utils.dart';
import 'package:mubrambl/src/utils/key_utils.dart';
import 'package:test/test.dart';

void main() {
  group('validate addresses', () {
    setUp(() {
      // Additional setup goes here.
    });

    // test isValidNetwork success
    test('isValidNetwork success', () {
      final validationRes = isValidNetwork('private');
      expect(validationRes, true);
    });

    test('isValidNetwork failure empty', () {
      final validationRes = isValidNetwork('');
      expect(validationRes, false);
    });

    test('isValidNetwork failure wrong name', () {
      final validationRes = isValidNetwork('bifrost');
      expect(validationRes, false);
    });

// using a private address test to make sure that BramblDart validates properly
    test('validate address by network success private', () {
      final validationRes = validateAddressByNetwork(
          'private', 'AUAvJqLKc8Un3C6bC4aj8WgHZo74vamvX8Kdm6MhtdXgw51cGfix');

      expect(validationRes['success'], true);
    });

// using a valhalla address test to make sure that BramblDart validates properly
    test('validate address by network success valhalla', () {
      final validationRes = validateAddressByNetwork(
          'valhalla', '3NKunrdkLG6nEZ5EKqvxP5u4VjML3GBXk2UQgA9ad5Rsdzh412Dk');

      expect(validationRes['success'], true);
    });

    // using a toplnet address test to make sure that BramblDart validates properly

    test('validate address by network success toplnet', () {
      final validationRes = validateAddressByNetwork(
          'toplnet', '9d3Ny7sXoezon5DkAEqkHRjmZCitVLLdoTMqAKhRiKDWU8YZfax');

      expect(validationRes['success'], true);
    });

    // validate addresses empty address
    test('validate address by network failure empty address', () {
      final validationRes = validateAddressByNetwork('private', '');

      expect(validationRes['success'], false);
      expect(validationRes['errorMsg'], 'No addresses provided');
    });

    // validate addresses invalid network
    test('validate address by network failure invalid network', () {
      final validationRes = validateAddressByNetwork(
          'bifrost', '9d3Ny7sXoezon5DkAEqkHRjmZCitVLLdoTMqAKhRiKDWU8YZfax');

      expect(validationRes['success'], false);
      expect(validationRes['errorMsg'], 'Invalid network provided');
    });

    // validate addresses failure address too short
    test('validate address by network failure too short', () {
      final validationRes = validateAddressByNetwork(
          'toplnet', '9d3Ny7sXoezon5DkAEqkHRjmZCitVLLdoTMqAKhRiKDWU8YZfx');

      expect(validationRes['success'], false);
      expect(validationRes['errorMsg'], 'Invalid address for network: toplnet');
    });

    // validate addresses failure address too long
    test('validate address by network failure too long', () {
      final validationRes = validateAddressByNetwork(
          'toplnet', '9d3Ny7sXoezon5DkAEqkHRjmZCitVLLdoTMqAKhRiKDWU8YZfffff');

      expect(validationRes['success'], false);
      expect(validationRes['errorMsg'], 'Invalid address for network: toplnet');
    });

    // validate addresses failure address wrong network decimal
    test('validate address by network failure wrong network decimal', () {
      final validationRes = validateAddressByNetwork(
          'toplnet', '3NKunrdkLG6nEZ5EKqvxP5u4VjML3GBXk2UQgA9ad5Rsdzh412Dk');

      expect(validationRes['success'], false);
      expect(validationRes['errorMsg'], 'Invalid address for network: toplnet');
    });

    // validate addresses failure address invalid checksum
    test('validate address by network failure invalid checksum', () {
      final validationRes = validateAddressByNetwork(
          'valhalla', '3NKunrdUtKdWRXz33PazioBLgc7uynUQkM1bwLUfURpxt6V99VRQ');

      expect(validationRes['success'], false);
      expect(
          validationRes['errorMsg'], 'Addresses with invalid checksums found');
    });
  });

  group('get network prefix for address tests', () {
    // test get network prefix for address success (private)
    test('getAddressNetwork success private', () {
      final networkResult = getAddressNetwork(
          'AUAvJqLKc8Un3C6bC4aj8WgHZo74vamvX8Kdm6MhtdXgw51cGfix');
      expect(networkResult['success'], true);
      expect(networkResult['networkPrefix'], 'private');
    });

    // test get network prefix for address success (valhalla)
    test('getAddressNetwork success valhalla', () {
      final networkResult = getAddressNetwork(
          '3NKunrdkLG6nEZ5EKqvxP5u4VjML3GBXk2UQgA9ad5Rsdzh412Dk');
      expect(networkResult['success'], true);
      expect(networkResult['networkPrefix'], 'valhalla');
    });

    // test get network prefix for address success (toplnet)
    test('getAddressNetwork success toplnet', () {
      final networkResult = getAddressNetwork(
          '9d3Ny7sXoezon5DkAEqkHRjmZCitVLLdoTMqAKhRiKDWU8YZfax');
      expect(networkResult['success'], true);
      expect(networkResult['networkPrefix'], 'toplnet');
    });

    // test get network prefix for address failure
    test('getAddressNetwork failure', () {
      final networkResult =
          getAddressNetwork('sXoezon5DkAEqkHRjmZCitVLLdoTMqAKhRiKDWU8YZfax');
      expect(networkResult['success'], false);
      expect(networkResult['error'], 'invalid network prefix found');
    });

    // test get network prefix for address failure empty
    test('getAddressNetwork failure empty string', () {
      expect(
          () => getAddressNetwork(''), throwsA(TypeMatcher<Base58Exception>()));
    });
  });

  group('test key utilities', () {
    // test key recovery success
    test('keyRecovery success', () {
      final cipherParams = CipherParams('NPL8XoWBJL1x539wb19jL8');
      final crypto = Crypto(
          '2DbmnQiaUyBrgZka4ZhrGibop7gf6wQsLtTfFeTVQkYv',
          'scrypt',
          '3zHMnaVUNqcbLqKdA9G5EWy2CDRmvvDZZjW7FBChdM3ru6UJWxDECNPqchuNDjyyTrmFGSRN2m34NeDD8oL1PiUn',
          '7Z7Z99siQvzRUdcX9SH1s45F4mMsYSa3YYXFq7Tqq5Ns',
          'aes-256-ctr',
          cipherParams);
      final address = '3NKunrdkLG6nEZ5EKqvxP5u4VjML3GBXk2UQgA9ad5Rsdzh412Dk';
      final kdfParams = KDFParams(32, 262144, 8, 1);

      final keys = recover('test', KeyFile(crypto, address), kdfParams);
      expect(keys, [
        'DvovrPBee6AVQKaA7Ldd6ZSmvFaXptXadntrjeSCjroE',
        '3L92EtcUV6Eh8G5A9iBnFhitLuTdzeZ814SuMD5dzDqv'
      ]);
    });

    // throws exception if password is incorrect (anagram)
    test('keyRecovery incorrect anagram', () {
      final cipherParams = CipherParams('NPL8XoWBJL1x539wb19jL8');
      final crypto = Crypto(
          '2DbmnQiaUyBrgZka4ZhrGibop7gf6wQsLtTfFeTVQkYv',
          'scrypt',
          '3zHMnaVUNqcbLqKdA9G5EWy2CDRmvvDZZjW7FBChdM3ru6UJWxDECNPqchuNDjyyTrmFGSRN2m34NeDD8oL1PiUn',
          '7Z7Z99siQvzRUdcX9SH1s45F4mMsYSa3YYXFq7Tqq5Ns',
          'aes-256-ctr',
          cipherParams);
      final address = '3NKunrdkLG6nEZ5EKqvxP5u4VjML3GBXk2UQgA9ad5Rsdzh412Dk';
      final kdfParams = KDFParams(32, 262144, 8, 1);

      expect(() => recover('estt', KeyFile(crypto, address), kdfParams),
          throwsA(TypeMatcher<ArgumentError>()));
    });
  });
}
