import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:async/async.dart';

abstract class SafeCubit<State> extends Cubit<State> {
  SafeCubit(super.initialState);

  /// Keeps track of operations that should be cancelled when the cubit is closed.
  final List<CancelableOperation> _operations = [];

  /// The current debounce timer if any.
  Timer? _debounceTimer;

  /// Safer alternative to standard emit. Only emits if cubit is not closed.
  @override
  void emit(State state) {
    if (!isClosed) {
      super.emit(state);
    }
  }

  /// Alias for emit, in case someone explicitly wants to call safeEmit
  void safeEmit(State state) {
    emit(state);
  }

  /// Adds a cancelable operation. Will be automatically cancelled when close() is called.
  CancelableOperation<T> cancelableOperation<T>(Future<T> future) {
    final operation = CancelableOperation<T>.fromFuture(future);
    _operations.add(operation);
    // Automatically remove from the list once it completes to prevent memory leak
    operation.value.whenComplete(() {
      _operations.remove(operation);
    });
    return operation;
  }

  /// Runs an action after a specified debounce duration.
  /// Subsequent calls before the timer finishes will reset the timer.
  void debounce(Duration duration, void Function() action) {
    _debounceTimer?.cancel();
    if (!isClosed) {
      _debounceTimer = Timer(duration, () {
        if (!isClosed) {
          action();
        }
      });
    }
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    for (final operation in _operations) {
      if (!operation.isCompleted && !operation.isCanceled) {
        operation.cancel();
      }
    }
    _operations.clear();
    return super.close();
  }
}
