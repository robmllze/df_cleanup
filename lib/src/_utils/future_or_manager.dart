//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Dart/Flutter (DF) Packages by DevCetra.com & contributors. The use of this
// source code is governed by an MIT-style license described in the LICENSE
// file located in this project's root directory.
//
// See: https://opensource.org/license/mit
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'dart:async';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class FutureOrManager {
  final _futures = <Future<void>>[];
  final _exceptions = <Object>[];

  /// Adds the result of a function that may return a Future or a synchronous value.
  void add(FutureOr<void> value) {
    if (value is Future<void>) {
      _futures.add(
        value.catchError((Object e) {
          _exceptions.add(e);
          return Future<void>.error(e);
        }),
      );
    }
  }

  /// Adds the results of a list of functions that may return a Future or a synchronous value.
  void addAll(Iterable<FutureOr<void>> futuresOr) {
    for (final value in futuresOr) {
      add(value);
    }
  }

  /// Adds an exception to the list of exceptions to throw when completing.
  void addException(Object e) {
    _exceptions.add(e);
  }

  /// Completes the async operations if any, otherwise returns synchronously.
  FutureOr<void> complete([void Function()? onComplete]) {
    if (_futures.isNotEmpty) {
      return Future.wait(_futures).then((_) {
        if (_exceptions.isNotEmpty) {
          throw _exceptions.first;
        }
        onComplete?.call();
      });
    } else if (_exceptions.isNotEmpty) {
      throw _exceptions.first;
    }
    onComplete?.call();
  }
}
