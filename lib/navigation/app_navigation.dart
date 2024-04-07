import 'package:flutter/material.dart';
import 'package:flutter_dream/guess/guess_page.dart';
import 'package:flutter_dream/muyu/muyu_page.dart';
import 'package:flutter_dream/net_article/views/net_article_page.dart';
import 'package:flutter_dream/paper/paper.dart';
import 'package:flutter_dream/timer/timer_page/view/timer.dart';

import 'app_bottom_bar.dart';

class AppNavigation extends StatefulWidget {
  const AppNavigation({super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  final PageController _ctrl = PageController();
  int _index = 0;
  final List<MenuData> menus = const [
    MenuData(label: '猜数字', icon: Icons.question_mark),
    MenuData(label: '电子木鱼', icon: Icons.my_library_music_outlined),
    MenuData(label: '白板绘制', icon: Icons.palette_outlined),
    MenuData(label: '网络文章', icon: Icons.article_outlined),
    MenuData(label: '秒表', icon: Icons.timer),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContent(),
      bottomNavigationBar: AppBottomBar(
        currentIndex: _index,
        onItemTap: _onChangePage,
        menus: menus,
      ),
    );
  }

  Widget _buildContent() {
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: _ctrl,
      children: const [
        GuessPage(),
        MuYuPage(),
        Paper(),
        NetArticlePage(),
        TimerPage(),
      ],
    );
  }

  void _onChangePage(int index) {
    _ctrl.jumpToPage(index);
    setState(() {
      _index = index;
    });
  }
}
