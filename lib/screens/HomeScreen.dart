import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:woocommerce/screens/BrandScreen.dart';
import 'package:woocommerce/screens/CategoryScreen.dart';
import 'package:woocommerce/screens/ProductScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final CarouselSliderController  _controller = CarouselSliderController ();

  int _current = 0;

  final List<String> imgList = [
    'https://d2zny4996dl67j.cloudfront.net/blogs/wp-content/uploads/2023/06/19055507/Blog-Banner-1.jpg',
    'https://www.vummidi.com/blog/wp-content/uploads/2024/01/Gold-Saving-Scheme-1024x574.png',
    'https://bsmedia.business-standard.com/_media/bs/img/about-page/thumb/463_463/1607305466.jpg?im=FitAndFill=(826,465)',
  ];

  List<Widget> get imageSliders => imgList
      .map(
        (item) => ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        item,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) =>
        const Icon(Icons.broken_image, size: 100),
      ),
    ),
  ).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Home"),
      //   centerTitle: true,
      // ),
      body: Column(
        children: [
          SizedBox(height: 10),

          // Carousel Slider
          CarouselSlider(
            items: imageSliders,
            carouselController: _controller,
            options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 2.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
          ),

        ],
      )
    );
  }
}
