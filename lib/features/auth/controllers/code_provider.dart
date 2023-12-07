import 'package:flutter_riverpod/flutter_riverpod.dart';

class CodeNotifier extends StateNotifier<String> {
  CodeNotifier() : super("");

  void setStart(String newState) {
    state = newState;
  }
}

final codeProvider = StateNotifierProvider<CodeNotifier, String>((ref) {
  return CodeNotifier();
});


/*import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'code_provider.g.dart';

@riverpod
class CodeState extends _$CodeState {
  @override
  String build() {
    return "";
  }

  void setStart(String newState) {
    state = newState;
  }
}*/
