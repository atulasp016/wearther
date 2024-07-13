import 'package:flutter/material.dart';
import 'package:weather/utils/app_images.dart';

class GridTileContainer extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData urlImage;
  const GridTileContainer({
    super.key,
    required this.title,
    required this.subtitle,
    required this.urlImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.42,
      height: MediaQuery.of(context).size.height * 0.12 - 21,
      padding: const EdgeInsets.all(11),
      margin: const EdgeInsets.all(11),
      decoration: BoxDecoration(
          color: const Color(0xffE5E5E5),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Center(child: Icon(urlImage,size: 40, color: Colors.blue.shade400)),
          const SizedBox(width: 11),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.7,
                      fontSize: 18)),
              Text(subtitle, style: const TextStyle(fontSize: 16)),
            ],
          )
        ],
      ),
    );
  }
}


