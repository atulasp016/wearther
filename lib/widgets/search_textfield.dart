import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  TextEditingController? mController;
  TextInputType keyboard;
  VoidCallback onTap;

  SearchTextField(
      {super.key,
      this.mController,
      required this.keyboard,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextField(
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16
        ),
        controller: mController,
        keyboardType: keyboard,
        enableSuggestions: true,
        decoration: InputDecoration(
          filled: false,
          hintText: 'Search',
          hintStyle:const TextStyle(
              fontSize: 16
          ),
          suffixIcon:
              InkWell(onTap: onTap, child: const Icon(CupertinoIcons.search)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xffEEF1F4),
              )),
        ),
      ),
    );
  }
}
