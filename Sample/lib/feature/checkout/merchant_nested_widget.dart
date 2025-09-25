import 'package:flutter/material.dart';

class MerchantNestedWidget extends StatelessWidget {
  const MerchantNestedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      color: Colors.black12,
      child: const Center(
        child: Text(
          'I am a Flutter nested Widget inside a Native View and inside Flutter!',
          style: TextStyle(color: Colors.black54, fontSize: 16),
        ),
      ),
    );
  }
}