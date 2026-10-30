import 'package:flutter/material.dart';

import 'cart_styles.dart';

class CartCard extends StatelessWidget {
  const CartCard({
    required this.child,
    this.color = Colors.white,
    this.borderColor = CartStyles.border,
    super.key,

    // here we have define a default color as the white?
    //  if we don' define color default then what will happen
  });

  final Widget child;
  final Color color;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: borderColor),
        // border here we don't have to give a border it gives a appropriate border
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }
}
