import 'dart:async';
import 'dart:math' show Random;
import 'package:bloc_provider/bloc_provider.dart';

class CalcBloc implements Bloc {
  CalcBloc() {
    // スタートボタンが押されるのを待つ
    _startController.stream.listen((_) => _start());

    // 秒数が通知されるのを待つ
    _calcController.stream.listen((count) => _calc(count));

    // ボタンの表示を指示する
    _btnController.sink.add(true);
  }

  final _startController = StreamController<void>();
  final _calcController = StreamController<int>();
  final _outputController = StreamController<String>();
  final _btnController = StreamController<bool>();

  // 入力用sinkのGetter
  StreamSink<void> get start => _startController.sink;

  // 出力用streamのGetter
  Stream<String> get onAdd => _outputController.stream;
  Stream<bool> get onToggle => _btnController.stream;

  static const _repeat = 6;
  int _sum;
  Timer _timer;

  void _start() {
    _sum = 0;
    _outputController.sink.add('');
    _btnController.sink.add(false);

    // 1秒ごとに秒数を通知
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      _calcController.sink.add(t.tick);
    });
  }

  void _calc(int count) {
    if (count < _repeat + 1) {
      final num = Random().nextInt(99) + 1;
      _outputController.sink.add('$num');
      _sum += num;
    } else {
      _timer.cancel();
      _outputController.sink.add('答えは$_sum');
      _btnController.sink.add(true);
    }
  }

  @override
  Future<void> dispose() async {
    await _startController.close();
    await _calcController.close();
    await _outputController.close();
    await _btnController.close();
  }
}
