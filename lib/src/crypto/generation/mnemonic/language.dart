import 'dart:io';

import 'package:brambldart/src/common/functional/either.dart';
import 'package:brambldart/src/crypto/hash/sha.dart';
import 'package:brambldart/src/utils/extensions.dart';

sealed class Language {
  const Language(this.filePath, this.hash);

  final String filePath;
  final String hash;
  // ignore: avoid_field_initializers_in_const_classes
  final String wordlistDirectory = 'bip-0039';
}

class ChineseSimplified extends Language {
  const ChineseSimplified()
      : super('chinese_simplified.txt', 'bfd683b91db88609fabad8968c7efe4bf69606bf5a49ac4a4ba5e355955670cb');
}

class ChineseTraditional extends Language {
  const ChineseTraditional()
      : super('chinese_traditional.txt', '85b285c4e0e3eb1e52038e2cf4b4f8bba69fd814e1a09e063ce3609a1f67ad62');
}

class English extends Language {
  const English() : super('english.txt', 'ad90bf3beb7b0eb7e5acd74727dc0da96e0a280a258354e7293fb7e211ac03db');
}

class French extends Language {
  const French() : super('french.txt', '9cbdaadbd3ce9cbaee1b360fce45e935b21e3e2c56d9fcd56b3398ced2371866');
}

class Italian extends Language {
  const Italian() : super('italian.txt', '80d2e90d7436603fd6e57cd9af6f839391e64beac1a3e015804f094fcc5ab24c');
}

class Japanese extends Language {
  const Japanese() : super('japanese.txt', 'd9d1fde478cbeb45c06b93632a487eefa24f6533970f866ae81f136fbf810160');
}

class Korean extends Language {
  const Korean() : super('korean.txt', 'f04f70b26cfef84474ff56582e798bcbc1a5572877d14c88ec66551272688c73');
}

class Spanish extends Language {
  const Spanish() : super('spanish.txt', 'a556a26c6a5bb36db0fb7d8bf579cb7465fcaeec03957c0dda61b569962d9da5');
}

class Czech extends Language {
  const Czech() : super('czech.txt', 'f9016943461800f7870363b4c301c814dbcb8f4de801e6c87d859eba840469d5');
}

class Portuguese extends Language {
  const Portuguese() : super('portuguese.txt', 'eed387d44cf8f32f60754527e265230d8019e8a2277937c71ef812e7a46c93fd');
}

class LanguageWordList {
  const LanguageWordList(this.value);
  final List<String> value;

  static const _hexDigits = '0123456789abcdef';

  // ignore: unused_element
  static String _toHexString(List<int> bytes) {
    final buffer = StringBuffer();
    for (final byte in bytes) {
      buffer.write(_hexDigits[(byte >> 4) & 0xF]);
      buffer.write(_hexDigits[byte & 0xF]);
    }
    return buffer.toString();
  }

  static Future<Either<ValidationFailure, LanguageWordList>> validated(Language language) async {
    try {
      final file = File('lib/assets/${language.wordlistDirectory}/${language.filePath}');
      final words = await file.readAsLines();

      final hash = LanguageWordList.validateChecksum(words, language.hash);
      return hash.isRight ? Either.right(LanguageWordList(words)) : Either.left(InvalidChecksum());
    } catch (e) {
      return Either.left(FileReadFailure(e));
    }
  }

  static Either<ValidationFailure, List<String>> validateChecksum(
    List<String> words,
    String expectedHash,
  ) {
    final hash = SHA256().hash(words.join().toUtf8Uint8List());
    final hashString = hash.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
    return hashString == expectedHash ? Either.right(words) : Either.left(InvalidChecksum());
  }
}

sealed class ValidationFailure implements Exception {}

class FileReadFailure implements ValidationFailure {
  const FileReadFailure(this.exception);
  final Object exception;
}

class InvalidChecksum implements ValidationFailure {}
