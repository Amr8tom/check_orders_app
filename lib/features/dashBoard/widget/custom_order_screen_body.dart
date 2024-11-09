import 'dart:async';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:live/app/core/utils/dimensions.dart';
import 'package:live/features/dashBoard/provider/files_provider.dart';
import 'package:live/features/dashBoard/widget/vedioPlayer.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:media_cache_manager/media_cache_manager.dart';
import 'package:provider/provider.dart';

import '../../../app/core/utils/color_resources.dart';
import '../../../app/core/utils/images.dart';
import '../../../data/api/end_points.dart';

class CustomOrderScreenBody extends StatelessWidget {
  const CustomOrderScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    Timer? vedioTimer;
    Timer? photoTimer;
    CarouselSliderController buttonCarouselController =
        CarouselSliderController();

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Consumer<MediaProvider>(
        builder: (context, provider, _) {
          return CarouselSlider.builder(
            carouselController: buttonCarouselController,
            disableGesture: true,
            // carouselController: buttonCarouselController,  // Pass controller here
            itemCount: provider.mediaFiles?.length ?? 0,
            itemBuilder: (BuildContext context, int index, int pageViewIndex) {
              return DownloadMediaBuilder(
                url: provider.mediaFiles?.isEmpty ?? true
                    ? "https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_5mb.mp4"
                    : "${EndPoints.baseUrl}/${provider.mediaFiles?[index].fileBaseString}",
                onSuccess: (snapshot) {
                  if (provider.mediaFiles?.isEmpty ?? true) {
                    return Image.asset(
                      Images.logo,
                      width: 200,
                    );
                  }

                  if (provider.mediaFiles?[index].type == 2) {
                    vedioTimer?.cancel();
                    vedioTimer = Timer.periodic(
                        Duration(
                            seconds: provider.mediaFiles![index].duration ??
                                60), (Timer t) {
                      buttonCarouselController.nextPage();
                      vedioTimer?.cancel();
                    });
                    return VedioPlayer(
                      filePath: snapshot.filePath!,
                      // buttonCarouselController: buttonCarouselController,
                    );
                  } else {
                    photoTimer?.cancel();
                    photoTimer = Timer.periodic(
                        Duration(
                            seconds: provider.mediaFiles![index].duration ??
                                60), (Timer t) {
                      if (t.tick == provider.mediaFiles![index].loopcount) {
                        photoTimer?.cancel();
                        buttonCarouselController.nextPage();
                      }
                    });

                    return Image.file(File(snapshot.filePath!));
                  }
                },
                onLoading: (snapshot) {
                  return Center(
                    child: LoadingAnimationWidget.inkDrop(
                      size: 50,
                      color: ColorResources.PRIMARY_COLOR,
                    ),
                  );
                },
              );
            },
            options: CarouselOptions(
              height: 900.h,
              aspectRatio: 16 / 9,
              viewportFraction: 1,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 9),
              autoPlayAnimationDuration: Duration(milliseconds: 2400),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              enlargeFactor: 0.3,
              scrollDirection: Axis.horizontal,
            ),
          );
        },
      ),
    );
  }
}
