import 'package:brambl_dart/src/quivr/common/contextless_validation.dart';
import 'package:brambl_dart/src/quivr/common/quivr_result.dart';

class SignatureVerifier<T> implements ContextlessValidation<T> {
  SignatureVerifier(this.definedFunction);
  final Function(T) definedFunction;

  @override
  QuivrResult<T> validate(t) => definedFunction(t);
}
