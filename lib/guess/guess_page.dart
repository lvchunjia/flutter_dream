import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dream/guess/result_notice.dart';
import 'package:flutter_dream/storage/sp_storage.dart';

import 'guess_app_bar.dart';

class GuessPage extends StatefulWidget {
  const GuessPage({super.key});

  @override
  State<GuessPage> createState() => _GuessPageState();
}

class _GuessPageState extends State<GuessPage>
    with AutomaticKeepAliveClientMixin {
  int _value = 0;
  bool _guessing = false;
  bool? _isBig;

  final Random _random = Random();
  final TextEditingController _guessCtrl = TextEditingController();

  @override
  void dispose() {
    _guessCtrl.dispose();
    super.dispose();
    _initConfig();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: GuessAppBar(onCheck: _onCheck, controller: _guessCtrl),
      body: Stack(
        children: [
          if (_isBig != null)
            Column(
              children: [
                if (_isBig!)
                  const ResultNotice(color: Colors.redAccent, info: '大了'),
                const Spacer(),
                if (!_isBig!)
                  const ResultNotice(color: Colors.blueAccent, info: '小了'),
              ],
            ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (!_guessing)
                  const Text(
                    '点击生成随机数:',
                    style: TextStyle(color: Colors.purple, fontSize: 16),
                  ),
                Text(
                  _guessing ? '**' : '$_value',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _guessing ? null : _generateRandomValue,
        backgroundColor: _guessing ? Colors.grey : Colors.blue,
        tooltip: 'Increment',
        child: const Icon(Icons.generating_tokens_outlined),
      ),
    );
  }

  void _initConfig() async {
    Map<String, dynamic> config = await SpStorage.instance.readGuessConfig();
    _guessing = config['guessing'] ?? false;
    _value = config['value'] ?? 0;
    setState(() {});
  }

  _generateRandomValue() {
    setState(() {
      _guessing = true;
      _value = _random.nextInt(100);
      SpStorage.instance.saveGuessConfig(guessing: _guessing, value: _value);
    });
  }

  void _onCheck() {
    int? guessValue = int.tryParse(_guessCtrl.text);
    // 游戏未开始，或者输入非整数，无视
    if (!_guessing || guessValue == null) return;

    //猜对了
    if (guessValue == _value) {
      setState(() {
        _isBig = null;
        _guessing = false;
      });
      return;
    }

    // 猜错了
    setState(() {
      _isBig = guessValue > _value;
    });
  }

  @override
  bool get wantKeepAlive => true;
}
