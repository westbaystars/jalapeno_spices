import 'package:flutter/material.dart';
import 'package:jalapeno_spices/constants.dart';

class EmptySpiceScreen extends StatelessWidget {
  const EmptySpiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: kPadding * 3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/jalapeno_spices_logo.png'),
          const SizedBox(height: 10),
          const Center(
            child: Text('No Spices'),
          ),
        ],
      ),
    );
  }
}
