import 'package:flutter/material.dart';

class Sliders extends StatelessWidget {
  final String? logo;
  final String? image;
  final String? description;

  const Sliders({
    Key? key,
    this.image,
    this.description,
    this.logo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image(image: AssetImage(logo!)),
          const SizedBox(height: 25),
          Text(
            description!,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 25),
          // image given in slider
          Image.asset(
            image!,
            fit: BoxFit.scaleDown,
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
