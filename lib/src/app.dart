import 'package:flutter/material.dart';
import 'package:ggsb_project/src/features/home/pages/home_page.dart';
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
      height: 75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: CustomColors.mainBlack,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.7),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, -3), // Offset(수평, 수직)
          ),
        ],
      ),
      child: TabBar(
        indicator: CircleTabIndicator(color: Colors.white, radius: 5),
        controller: _tabController,
        indicatorWeight: 4,
        splashFactory: NoSplash.splashFactory,
        dividerColor: Colors.transparent,
        tabs: [
          Tab(
            child: Image.asset(
              'assets/icons/home.png',
              width: 50,
              color: _tabController.index == 0
                  ? Colors.white
                  : Colors.white.withOpacity(0.7),
              colorBlendMode: BlendMode.modulate,
            ),
          ),
          Tab(
            child: Image.asset(
              'assets/icons/note.png',
              width: 50,
              color: _tabController.index == 1
                  ? Colors.white
                  : Colors.white.withOpacity(0.7),
              colorBlendMode: BlendMode.modulate,
            ),
          ),
          Tab(
            child: Image.asset(
              'assets/icons/book.png',
              width: 50,
              color: _tabController.index == 2
                  ? Colors.white
                  : Colors.white.withOpacity(0.7),
              colorBlendMode: BlendMode.modulate,
            ),
          ),
          Tab(
            child: Image.asset(
              'assets/icons/person.png',
              width: 50,
              color: _tabController.index == 3
                  ? Colors.white
                  : Colors.white.withOpacity(0.7),
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
    final center = Offset(rect.center.dx, rect.bottom - radius);

    canvas.drawCircle(center, radius, _paint);
  }
}
