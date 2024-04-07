import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dream/timer/utils/right_2_left_router.dart';

import '../../setting_page/setting_page.dart';
import '../bloc/bloc.dart';
import 'button_tools.dart';
import 'record_panel.dart';
import 'stopwatch_widget.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  StopWatchBloc get stopWatchBloc => BlocProvider.of<StopWatchBloc>(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: buildActions(),
      ),
      body: Column(
        children: [
          buildStopwatchPanel(),
          buildRecordPanel(),
          buildTools(),
        ],
      ),
    );
  }

  List<Widget> buildActions() {
    return [
      PopupMenuButton<String>(
        itemBuilder: _buildItem,
        onSelected: _onSelectItem,
        icon: const Icon(Icons.more_vert_outlined, color: Color(0xff262626)),
        position: PopupMenuPosition.under,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      )
    ];
  }

  List<PopupMenuEntry<String>> _buildItem(BuildContext context) {
    return const [
      PopupMenuItem<String>(value: "设置", child: Center(child: Text("设置")))
    ];
  }

  void _onSelectItem(String value) {
    if (value == "设置") {
      Navigator.of(context).push(Right2LeftRouter(child: const SettingPage()));
    }
  }

  Widget buildStopwatchPanel() {
    double radius = MediaQuery.of(context).size.width / 2 * 0.75;

    return BlocBuilder<StopWatchBloc, StopWatchState>(
      buildWhen: (p, n) => p.duration != n.duration,
      builder: (_, state) => StopwatchWidget(
        duration: state.duration,
        radius: radius,
        themeColor: Theme.of(context).primaryColor,
        secondDuration: state.secondDuration,
      ),
    );
  }

  Widget buildRecordPanel() {
    return Expanded(
      child: BlocBuilder<StopWatchBloc, StopWatchState>(
        buildWhen: (p, n) => p.durationRecord != n.durationRecord,
        builder: (_, state) => RecordPanel(
          record: state.durationRecord,
        ),
      ),
    );
  }

  Widget buildTools() {
    return BlocBuilder<StopWatchBloc, StopWatchState>(
      buildWhen: (p, n) => p.type != n.type,
      builder: (_, state) => ButtonTools(
        state: state.type,
        onRecoder: onRecoder,
        onReset: onReset,
        toggle: toggle,
      ),
    );
  }

  void onReset() => stopWatchBloc.add(const ResetStopWatch());
  void onRecoder() => stopWatchBloc.add(const RecordeStopWatch());
  void toggle() => stopWatchBloc.add(const ToggleStopWatch());
}
