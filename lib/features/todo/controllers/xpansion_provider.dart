import 'package:flutter_riverpod/flutter_riverpod.dart';

class XpansionNotifier extends StateNotifier<bool> {
  XpansionNotifier() : super(false);

  void setStart(bool newState) {
    state = newState;
  }
}

final xpansionProvider = StateNotifierProvider<XpansionNotifier, bool>((ref) {
  return XpansionNotifier();
});




/*import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'xpansion_provider.g.dart';

@riverpod
class XpansionState extends _$XpansionState {
  @override
  bool build() {
    return false;
  }

  void setStart(bool newState) {
    state = newState;
  }
}

@riverpod
class XpansionState0 extends _$XpansionState0 {
  @override
  bool build() {
    return false;
  }

  void setStart(bool newState) {
    state = newState;
  }
}*/