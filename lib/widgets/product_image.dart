import 'dart:io';

import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  String? image;

  ProductImage({Key? key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15, left: 15, top: 10),
      child: Container(
        width: double.infinity,
        height: 450,
        decoration: _buildBoxDecoration(),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          child: getImage(image),
        ),
      ),
    );
  }

  Widget getImage(String? image) {
    if (image == null) {
      return const Image(
          fit: BoxFit.cover, image: AssetImage('assets/no-image.png'));
    }

    if (image.startsWith('http')) {
      return FadeInImage(
        placeholder: const AssetImage('assets/jar-loading.gif'),
        image: NetworkImage(image),
        fit: BoxFit.cover,
      );
    }

    return Image.file(
      File(image),
      fit: BoxFit.cover,
    );
  }

  BoxDecoration _buildBoxDecoration() => const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 5),
              blurRadius: 10,
            )
          ]);
}
