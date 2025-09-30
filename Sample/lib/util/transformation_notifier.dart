import 'package:flutter/foundation.dart';

class TransformationNotifier<T1, T2> extends ValueNotifier<T2> {
  final ValueNotifier _notifier;
  final T2 Function(T1) _transform;

  TransformationNotifier(ValueNotifier<T1> notifier, T2 Function(T1) predicate)
    : _notifier = notifier,
      _transform = predicate,
      super(predicate(notifier.value)) {
    _notifier.addListener(_updateCombinedValue);
  }

  void _updateCombinedValue() {
    value = _transform(_notifier.value);
  }

  @override
  void dispose() {
    _notifier.removeListener(_updateCombinedValue);
    super.dispose();
  }
}
