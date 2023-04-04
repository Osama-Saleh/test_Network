import 'package:flutter/material.dart';

class MyDivider extends StatelessWidget {
  const MyDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      width: MediaQuery.of(context).size.width/2.5,
      color: Colors.grey[600],);
  }
}