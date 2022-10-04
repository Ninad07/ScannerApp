import 'package:carousel_slider/carousel_slider.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/material.dart';
import 'package:scanner_app/screens/home/components/carousel_slider_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: RichText(
          text: TextSpan(
            text: "Scan",
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
            children: [
              TextSpan(
                text: "IT",
                style: TextStyle(
                    color: Colors.grey.shade700, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        
        actions: [
          IconButton(
            onPressed: () async {
              final images = await CunningDocumentScanner.getPictures();
              print(images);
            },
            icon: const Icon(
              Icons.document_scanner,
              color: Colors.white,
              size: 25,
            ),
          ),
          const SizedBox(width: 5),
        ],
      ),
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: Colors.white,
                size: 25,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.home,
                color: Colors.white,
                size: 25,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
                size: 25,
              ),
            ),
          ],
        ),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 35),
        CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            enableInfiniteScroll: true,
            reverse: false,
            aspectRatio: 330 / 280,
            viewportFraction: 0.75,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            enlargeCenterPage: true,
            scrollDirection: Axis.horizontal,
          ),
          items: [
            CarouselSliderCard("Scan and convert images to PDF",
                "Start Scanning", Icons.document_scanner_outlined, () async {
              final images = await CunningDocumentScanner.getPictures();
            }),
            CarouselSliderCard("Translate and convert your files quickly!",
                "Start Translating", Icons.translate, () async {}),
            CarouselSliderCard("Change the color of your images!",
                "Select Images", Icons.color_lens, () async {}),
          ],
        ),
      ],
    );
  }
}
