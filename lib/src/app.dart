import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/auth/controllers/auth_controller.dart';
import 'package:ggsb_project/src/features/home/pages/home_page.dart';
import 'package:ggsb_project/src/features/my/pages/my_page.dart';
import 'package:ggsb_project/src/features/ranking/pages/ranking_page.dart';
import 'package:ggsb_project/src/features/result/pages/result_page.dart';
import 'package:ggsb_project/src/features/room_list/pages/room_list_page.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:ggsb_project/src/utils/date_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with SingleTickerProviderStateMixin {
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _prefsInit();
  }

  void _prefsInit() async {
    prefs = await SharedPreferences.getInstance();
    String? lastDate = prefs.getString('lastDate');
    if (lastDate != null &&
        AuthController.to.user.value.roomIdList!.isNotEmpty) {
      if (lastDate == DateUtil().dateTimeToString(DateUtil().getYesterday())) {
        Get.to(() => const ResultPage());
      }
    }
    prefs.setString('lastDate', DateUtil().dateTimeToString(DateTime.now()));
  }

  late final TabController _tabController =
      TabController(length: 4, vsync: this);

  Widget _tabBar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 85,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -10),
            blurRadius: 10,
            color: _tabController.index == 0
                ? Colors.transparent
                : Colors.black.withOpacity(0.1),
          ),
        ],
        color:
            _tabController.index == 0 ? CustomColors.mainBlack : Colors.white,
      ),
      child: TabBar(
        indicator: CircleTabIndicator(
          color: CustomColors.mainBlue,
          radius: 2,
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
                  : CustomColors.mainBlack,
              colorBlendMode: BlendMode.modulate,
            ),
          ),
          Tab(
            child: SvgPicture.asset(
              'assets/icons/room_list.svg',
              height: 30,
              color: _tabController.index == 1
                  ? CustomColors.mainBlue
                  : _tabController.index == 0
                      ? Colors.white
                      : CustomColors.mainBlack,
              colorBlendMode: BlendMode.modulate,
            ),
          ),
          Tab(
            child: Image.asset(
              'assets/icons/ranking.png',
              width: 35,
              color: _tabController.index == 2
                  ? CustomColors.mainBlue
                  : _tabController.index == 0
                      ? Colors.white
                      : CustomColors.mainBlack,
              colorBlendMode: BlendMode.modulate,
            ),
          ),
          Tab(
            child: SvgPicture.asset(
              'assets/icons/my.svg',
              height: 25,
              color: _tabController.index == 3
                  ? CustomColors.mainBlue
                  : _tabController.index == 0
                      ? Colors.white
                      : CustomColors.mainBlack,
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
        physics: const NeverScrollableScrollPhysics(),
        viewportFraction: 1,
        children: const [
          HomePage(),
          RoomListPage(),
          RankingPage(),
          MyPage(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
    final center = Offset(rect.center.dx, rect.bottom - radius - 15);

    canvas.drawCircle(center, radius, _paint);
  }
}
