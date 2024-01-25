import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ggsb_project/src/features/home/pages/home_page.dart';
import 'package:ggsb_project/src/features/my/pages/my_page.dart';
import 'package:ggsb_project/src/features/ranking/pages/ranking_page.dart';
import 'package:ggsb_project/src/features/room_list/pages/room_list_page.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with SingleTickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: 4, vsync: this);

  Widget _tabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      height: 65,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: CustomColors.mainBlack,
      ),
      child: TabBar(
        indicator: CircleTabIndicator(
          color: CustomColors.mainBlue,
          radius: 3,
        ),
        controller: _tabController,
        indicatorWeight: 4,
        splashFactory: NoSplash.splashFactory,
        dividerColor: Colors.transparent,
        tabs: [
          Tab(
            child: SvgPicture.asset(
              'assets/icons/home.svg',
              height: 25,
              color: _tabController.index == 0
                  ? CustomColors.mainBlue
                  : Colors.white,
              colorBlendMode: BlendMode.modulate,
            ),
          ),
          Tab(
            child: SvgPicture.asset(
              'assets/icons/room_list.svg',
              height: 30,
              color: _tabController.index == 1
                  ? CustomColors.mainBlue
                  : Colors.white,
              colorBlendMode: BlendMode.modulate,
            ),
          ),
          Tab(
            child: Image.asset(
              'assets/icons/ranking.png',
              width: 35,
              color: _tabController.index == 2
                  ? CustomColors.mainBlue
                  : Colors.white,
              colorBlendMode: BlendMode.modulate,
            ),
          ),
          Tab(
            child: SvgPicture.asset(
              'assets/icons/my.svg',
              height: 25,
              color: _tabController.index == 3
                  ? CustomColors.mainBlue
                  : Colors.white,
              colorBlendMode: BlendMode.modulate,
            ),
          ),
        ],
        onTap: (index) {
          setState(() {});
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(),
        viewportFraction: 1,
        children: const [
          HomePage(),
          RoomListPage(),
          RankingPage(),
          MyPage(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _tabBar(),
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
    final center = Offset(rect.center.dx, rect.bottom - radius - 10);

    canvas.drawCircle(center, radius, _paint);
  }
}
