import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  final Widget child;

  const CardContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 35),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: _cardShape(),
        child: child,
      ),
    );
  }

  BoxDecoration _cardShape() => BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 12, offset: Offset(0, 15))
          ]);
}
