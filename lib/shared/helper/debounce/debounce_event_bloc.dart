import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

EventTransformer<E> debounceRestartable<E>() {
  return (events, mapper) => restartable<E>().call(
    events.debounce(const Duration(microseconds: 400)),
    mapper,
  );
}
