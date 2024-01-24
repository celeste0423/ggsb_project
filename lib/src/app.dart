import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  // Widget _tabBar() {
  //   return Container(
  //     margin: EdgeInsets.symmetric(horizontal: 20),
  //     height: 75,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(20),
  //       color: CustomColors.mainBlack,
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey.withOpacity(0.7),
  //           spreadRadius: 1,
  //           blurRadius: 3,
  //           offset: Offset(0, -3), // Offset(수평, 수직)
  //         ),
  //       ],
  //     ),
  //     child: TabBar(
  //       indicator: CircleTabIndicator(color: Colors.white, radius: 5),
  //       controller: _tabController,
  //       indicatorWeight: 4,
  //       splashFactory: NoSplash.splashFactory,
  //       dividerColor: Colors.transparent,
  //       tabs: [
  //         Tab(
  //           key: bukkungTabKey,
  //           child: Image.asset(
  //             'assets/icons/home.png',
  //             width: 50,
  //             color: _tabController.index == 0
  //                 ? Colors.white
  //                 : Colors.white.withOpacity(0.7),
  //             colorBlendMode: BlendMode.modulate,
  //           ),
  //         ),
  //         Tab(
  //           key: suggestionListTabKey,
  //           child: Image.asset(
  //             'assets/icons/note.png',
  //             width: 50,
  //             color: _tabController.index == 1
  //                 ? Colors.white
  //                 : Colors.white.withOpacity(0.7),
  //             colorBlendMode: BlendMode.modulate,
  //           ),
  //         ),
  //         Tab(
  //           key: diaryTabKey,
  //           child: Image.asset(
  //             'assets/icons/book.png',
  //             width: 50,
  //             color: _tabController.index == 2
  //                 ? Colors.white
  //                 : Colors.white.withOpacity(0.7),
  //             colorBlendMode: BlendMode.modulate,
  //           ),
  //         ),
  //         Tab(
  //           key: myTabKey,
  //           child: Image.asset(
  //             'assets/icons/person.png',
  //             width: 50,
  //             color: _tabController.index == 3
  //                 ? Colors.white
  //                 : Colors.white.withOpacity(0.7),
  //             colorBlendMode: BlendMode.modulate,
  //           ),
  //         ),
  //       ],
  //       onTap: (index) {
  //         setState(() {});
  //         switch (index) {
  //           case 1:
  //             Analytics().logEvent('list_suggestion_page_open', null);
  //             break;
  //           case 2:
  //             Analytics().logEvent('diary_page_open', null);
  //             break;
  //           default:
  //             break;
  //         }
  //       },
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // body: TabBarView(
        //   controller: _tabController,
        //   physics: NeverScrollableScrollPhysics(),
        //   viewportFraction: 1,
        //   children: const [
        //     BukkungListPage(),
        //     // GgomulPage(),
        //     ListSuggestionPage(),
        //     DiaryPage(),
        //     MyPage(),
        //   ],
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        // floatingActionButton: _tabBar(),
        );
  }
}

class CircleTabIndicator extends Decoration {
  final BoxPainter _painter;

  CircleTabIndicator({required Color color, required double radius})
      : _painter = _CirclePainter(color, radius);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _painter;
  }
}

class _CirclePainter extends BoxPainter {
  final Paint _paint;
  final double radius;

  _CirclePainter(Color color, this.radius)
      : _paint = Paint()
          ..color = color
          ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final rect = offset & configuration.size!;
    final center = Offset(rect.center.dx, rect.bottom - radius);

    canvas.drawCircle(center, radius, _paint);
  }
}
