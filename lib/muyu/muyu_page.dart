import 'dart:math';

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dream/muyu/record_history.dart';
import 'package:flutter_dream/storage/db_storage/db_storage.dart';
import 'package:flutter_dream/storage/sp_storage.dart';
import 'package:uuid/uuid.dart';

import 'animate_text.dart';
import 'count_panel.dart';
import 'models/audio_option.dart';
import 'models/image_option.dart';
import 'models/merit_record.dart';
import 'muyu_app_bar.dart';
import 'muyu_image.dart';
import 'options/select_audio.dart';
import 'options/select_image.dart';

class MuYuPage extends StatefulWidget {
  const MuYuPage({Key? key}) : super(key: key);

  @override
  State<MuYuPage> createState() => _MuYuPageState();
}

class _MuYuPageState extends State<MuYuPage>
    with AutomaticKeepAliveClientMixin {
  late AudioPool pool;
  int _counter = 0;
  MeritRecord? _cruRecord;
  final Random _random = Random();

  final List<ImageOption> imageOptions = const [
    ImageOption('基础版', 'assets/images/muyu.png', 1, 3),
    ImageOption('尊享版', 'assets/images/muyu2.png', 3, 6),
  ];
  int _activeImageIndex = 0;
  // 激活图像
  String get activeImage => imageOptions[_activeImageIndex].src;
  // 敲击是增加值
  int get knockValue {
    int min = imageOptions[_activeImageIndex].min;
    int max = imageOptions[_activeImageIndex].max;
    return min + _random.nextInt(max + 1 - min);
  }

  final List<AudioOption> audioOptions = const [
    AudioOption('音效1', 'muyu_1.mp3'),
    AudioOption('音效2', 'muyu_2.mp3'),
    AudioOption('音效3', 'muyu_3.mp3'),
  ];
  int _activeAudioIndex = 0;
  String get activeAudio => audioOptions[_activeAudioIndex].src;

  List<MeritRecord> _records = [];
  final Uuid uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    _initAudioPool();
    _initConfig();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: MuYuAppBar(onTapHistory: _toHistory),
      body: Column(
        children: [
          Expanded(
            child: CountPanel(
              count: _counter,
              onTapSwitchAudio: _onTapSwitchAudio,
              onTapSwitchImage: _onTapSwitchImage,
            ),
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                MuYuAssetsImage(
                  image: activeImage, // 使用激活图像
                  onTap: _onKnock,
                ),
                if (_cruRecord != null) AnimateText(record: _cruRecord!)
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 跳转历史记录
  void _toHistory() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RecordHistory(
          records: _records.reversed.toList(),
        ),
      ),
    );
  }

  /// 选择音效
  void _onTapSwitchAudio() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return AudioOptionPanel(
          audioOptions: audioOptions,
          activeIndex: _activeAudioIndex,
          onSelect: _onSelectAudio,
        );
      },
    );
  }

  /// 选择音效时的回调
  void _onSelectAudio(int value) async {
    Navigator.of(context).pop();
    if (value == _activeAudioIndex) return;
    _activeAudioIndex = value;
    saveConfig();
    pool = await FlameAudio.createPool(
      activeAudio,
      maxPlayers: 1,
    );
  }

  /// 选择木鱼
  void _onTapSwitchImage() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return ImageOptionPanel(
          imageOptions: imageOptions,
          activeIndex: _activeImageIndex,
          onSelect: _onSelectImage,
        );
      },
    );
  }

  /// 选择木鱼时的回调
  void _onSelectImage(int value) {
    Navigator.of(context).pop();
    if (value == _activeImageIndex) return;
    setState(() {
      _activeImageIndex = value;
      saveConfig();
    });
  }

  /// 木鱼点击回调
  void _onKnock() {
    pool.start();

    setState(() {
      String id = uuid.v4();
      _cruRecord = MeritRecord(
        id,
        DateTime.now().millisecondsSinceEpoch,
        knockValue,
        activeImage,
        audioOptions[_activeAudioIndex].name,
      );
      _counter += _cruRecord!.value;

      saveConfig();
      DbStorage.instance.meritRecordDao.insert(_cruRecord!);

      // 添加功德记录
      _records.add(_cruRecord!);
    });
  }

  /// 初始化音效
  void _initAudioPool() async {
    debugPrint('初始化音效');
    try {
      pool = await FlameAudio.createPool(
        activeAudio,
        minPlayers: 1,
        maxPlayers: 4,
      );
    } catch (e) {
      debugPrint('初始化音效!${e.toString()}');
    }
  }

  void _initConfig() async {
    Map<String, dynamic> config = await SpStorage.instance.readMuYUConfig();
    _counter = config['counter'] ?? 0;
    _activeImageIndex = config['activeImageIndex'] ?? 0;
    _activeAudioIndex = config['activeAudioIndex'] ?? 0;
    _records = await DbStorage.instance.meritRecordDao.query();
    setState(() {});
  }

  void saveConfig() {
    SpStorage.instance.saveMuYUConfig(
      counter: _counter,
      activeImageIndex: _activeImageIndex,
      activeAudioIndex: _activeAudioIndex,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
