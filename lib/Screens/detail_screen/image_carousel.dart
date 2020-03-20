import 'package:carousel_slider/carousel_slider.dart';
import 'package:fisheri/firestore_request_service.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class ImageCarousel extends StatefulWidget {
  ImageCarousel({
    @required this.imageURLs,
    this.index,
  });

  final List<String> imageURLs;
  final int index;

  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final _currentPageNotifier = ValueNotifier<int>(0);

  bool imageURLsHasValue() {
    return widget.imageURLs != null && widget.imageURLs.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CarouselSlider.builder(
        viewportFraction: 1.0,
        enableInfiniteScroll: imageURLsHasValue(),
        itemCount: imageURLsHasValue() ? widget.imageURLs.length : 1,
        height: 350,
        itemBuilder: (BuildContext context, int itemIndex) =>
            imageURLsHasValue()
                ? CachedNetworkImage(
                    imageUrl: widget.imageURLs[itemIndex],
                    fit: BoxFit.fill,
                    placeholder: (context, url) => Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Image.asset('images/lake.jpg', fit: BoxFit.cover),
        onPageChanged: (index) {
          setState(() {
            _currentPageNotifier.value = index;
          });
        },
      ),
      if (imageURLsHasValue())
      Positioned(
        left: 0,
        right: 0,
        bottom: 16,
        child: CirclePageIndicator(
          selectedDotColor: Colors.white,
          dotColor: Colors.grey[400],
          itemCount: 5,
          currentPageNotifier: _currentPageNotifier,
        ),
      ),
    ]);
  }
}
