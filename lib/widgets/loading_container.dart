import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingContainer extends StatelessWidget {
  final double? width;
  final double height;
  const LoadingContainer({super.key, this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: const Color(0xffB0B3B8),
        highlightColor: const Color(0xffEEF1F4),
        child: Container(
          margin: const EdgeInsets.all(11),
          width: width ?? MediaQuery.of(context).size.width,
          height: height,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
        ));
  }
}

