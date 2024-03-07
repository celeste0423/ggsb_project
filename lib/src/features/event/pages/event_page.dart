import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ggsb_project/src/features/event/controller/event_page_controller.dart';
import 'package:ggsb_project/src/models/event_model.dart';
import 'package:ggsb_project/src/utils/custom_color.dart';
import 'package:ggsb_project/src/widgets/loading_indicator.dart';
import 'package:ggsb_project/src/widgets/svg_icon_button.dart';
import 'package:ggsb_project/src/widgets/title_text.dart';

class EventPage extends GetView<EventPageController> {
  const EventPage({super.key});

  PreferredSizeWidget _appBar() {
    return AppBar(
      centerTitle: true,
      leading: ImageIconButton(
        assetPath: 'assets/icons/back.svg',
        onTap: Get.back,
      ),
      title: TitleText(
        text: '이벤트',
      ),
    );
  }

  Widget _eventCardList() {
    return FutureBuilder(
      future: controller.getEventList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: loadingIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Text('에러 발생');
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              return _eventCard(snapshot.data![index]);
            },
          );
        }
      },
    );
  }

  Widget _eventCard(EventModel eventModel) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      onPressed: () {
        controller.eventCardButton(eventModel.contentUrl);
      },
      child: SizedBox(
        height: 130,
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: CustomColors.whiteBackground,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, 4),
                      blurRadius: 7,
                    ),
                  ],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eventModel.title ?? '',
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mainBlack,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      eventModel.content ?? '',
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 10,
                        color: CustomColors.mainBlack,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: 130,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 4),
                    blurRadius: 7,
                  ),
                ],
                image: DecorationImage(
                  image: NetworkImage(eventModel.imgUrl!),
                  fit: BoxFit.cover, // 이미지가 컨테이너를 꽉 채우도록 설정
                ),
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(EventPageController());
    return Scaffold(
      appBar: _appBar(),
      body: _eventCardList(),
    );
  }
}
