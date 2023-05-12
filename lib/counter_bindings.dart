import 'dart:ffi';
import 'dart:io';

typedef IncrementCFunc = Uint32 Function(Uint32);
typedef IncrementDartFunc = int Function(int);
typedef DecrementCFunc = Uint32 Function(Uint32);
typedef DecrementDartFunc = int Function(int);

class CounterBindings {
  late DynamicLibrary _lib;
  late IncrementDartFunc _increment;
  late DecrementDartFunc _decrement;

  CounterBindings() {
    _lib = Platform.isWindows
        ? DynamicLibrary.open('src/counter.dll')
        : DynamicLibrary.open('../src/libcounter.so');

    _increment = _lib
        .lookup<NativeFunction<IncrementCFunc>>('increment')
        .asFunction<IncrementDartFunc>();

    _decrement = _lib
        .lookup<NativeFunction<DecrementCFunc>>('decrement')
        .asFunction<DecrementDartFunc>();
  }

  int increment(int value) => _increment(value);
  int decrement(int value) => _decrement(value);
}
