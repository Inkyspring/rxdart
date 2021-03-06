import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';

void main() {
  test('rx.Observable.bufferCount.noSkip', () async {
    const expectedOutput = [
      [1, 2],
      [3, 4]
    ];
    var count = 0;

    final stream = Observable.range(1, 4).bufferCount(2);

    stream.listen(expectAsync1((result) {
      // test to see if the combined output matches
      expect(expectedOutput[count][0], result[0]);
      expect(expectedOutput[count][1], result[1]);
      count++;
    }, count: 2));
  });

  test('rx.Observable.bufferCount.noSkip.asBuffer', () async {
    const expectedOutput = [
      [1, 2],
      [3, 4]
    ];
    var count = 0;

    final stream = Observable.range(1, 4).buffer(onCount(2));

    stream.listen(expectAsync1((result) {
      // test to see if the combined output matches
      expect(expectedOutput[count][0], result[0]);
      expect(expectedOutput[count][1], result[1]);
      count++;
    }, count: 2));
  });

  test('rx.Observable.bufferCount.skip', () async {
    const expectedOutput = [
      [1, 2],
      [2, 3],
      [3, 4],
      [4]
    ];
    var count = 0;

    final stream = Observable.range(1, 4).bufferCount(2, 1);

    stream.listen(expectAsync1((result) {
      // test to see if the combined output matches
      expect(expectedOutput[count].length, result.length);
      expect(expectedOutput[count][0], result[0]);
      if (expectedOutput[count].length > 1)
        expect(expectedOutput[count][1], result[1]);
      count++;
    }, count: 4));
  });

  test('rx.Observable.bufferCount.skip.asBuffer', () async {
    const expectedOutput = [
      [1, 2],
      [2, 3],
      [3, 4],
      [4]
    ];
    var count = 0;

    final stream = Observable.range(1, 4).buffer(onCount(2, 1));

    stream.listen(expectAsync1((result) {
      // test to see if the combined output matches
      expect(expectedOutput[count].length, result.length);
      expect(expectedOutput[count][0], result[0]);
      if (expectedOutput[count].length > 1)
        expect(expectedOutput[count][1], result[1]);
      count++;
    }, count: 4));
  });

  test('rx.Observable.bufferCount.reusable', () async {
    final transformer = new BufferStreamTransformer<int>(onCount(2));
    const expectedOutput = [
      [1, 2],
      [3, 4]
    ];
    var countA = 0, countB = 0;

    final streamA = new Observable(new Stream.fromIterable(const [1, 2, 3, 4]))
        .transform(transformer);

    streamA.listen(expectAsync1((result) {
      // test to see if the combined output matches
      expect(expectedOutput[countA][0], result[0]);
      expect(expectedOutput[countA][1], result[1]);
      countA++;
    }, count: 2));

    final streamB = new Observable(new Stream.fromIterable(const [1, 2, 3, 4]))
        .transform(transformer);

    streamB.listen(expectAsync1((result) {
      // test to see if the combined output matches
      expect(expectedOutput[countB][0], result[0]);
      expect(expectedOutput[countB][1], result[1]);
      countB++;
    }, count: 2));
  });

  test('rx.Observable.bufferCount.asBroadcastStream', () async {
    final stream = new Observable(
            new Stream.fromIterable(const [1, 2, 3, 4]).asBroadcastStream())
        .bufferCount(2);

    // listen twice on same stream
    stream.listen(null);
    stream.listen(null);
    // code should reach here
    await expectLater(true, true);
  });

  test('rx.Observable.bufferCount.asBroadcastStream.asBuffer', () async {
    final stream = new Observable(
            new Stream.fromIterable(const [1, 2, 3, 4]).asBroadcastStream())
        .buffer(onCount(2));

    // listen twice on same stream
    stream.listen(null);
    stream.listen(null);
    // code should reach here
    await expectLater(true, true);
  });

  test('rx.Observable.bufferCount.error.shouldThrowA', () async {
    final observableWithError =
        new Observable(new ErrorStream<void>(new Exception())).bufferCount(2);

    observableWithError.listen(null,
        onError: expectAsync2((Exception e, StackTrace s) {
      expect(e, isException);
    }));
  });

  test('rx.Observable.bufferCount.error.shouldThrowA.asBuffer', () async {
    final observableWithError =
        new Observable(new ErrorStream<void>(new Exception()))
            .buffer(onCount(2));

    observableWithError.listen(null,
        onError: expectAsync2((Exception e, StackTrace s) {
      expect(e, isException);
    }));
  });

  test('rx.Observable.bufferCount.skip.shouldThrowB', () {
    new Observable.fromIterable(const [1, 2, 3, 4])
        .bufferCount(2, 100)
        .listen(null, onError: expectAsync2((ArgumentError e, StackTrace s) {
      expect(e, isArgumentError);
    }));
  });

  test('rx.Observable.bufferCount.skip.shouldThrowB.asBuffer', () {
    new Observable.fromIterable(const [1, 2, 3, 4])
        .buffer(onCount(2, 100))
        .listen(null, onError: expectAsync2((ArgumentError e, StackTrace s) {
      expect(e, isArgumentError);
    }));
  });

  test('rx.Observable.bufferCount.skip.shouldThrowC', () {
    new Observable<int>.fromIterable(const [1, 2, 3, 4])
        .bufferCount(null)
        .listen(null, onError: expectAsync2((ArgumentError e, StackTrace s) {
      expect(e, isArgumentError);
    }));
  });

  test('rx.Observable.bufferCount.skip.shouldThrowC.asBuffer', () {
    new Observable.fromIterable(const [1, 2, 3, 4])
        .buffer(onCount(null))
        .listen(null, onError: expectAsync2((ArgumentError e, StackTrace s) {
      expect(e, isArgumentError);
    }));
  });
}
