import 'package:flutter/material.dart';

class ExtraPage extends StatelessWidget {
  const ExtraPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  Text('From Michael Westbay', style: Theme.of(context).textTheme.headline4),
                  const SizedBox(height: 10),
                  const Text('For my sister.'),
                  const SizedBox(height: 30),
                  const Text('Special thanks to Team Giga'),
                  const SizedBox(height: 10),
                  const Text('https://github.com/holusojivhictor/gigi_notes'),

                  const SizedBox(height: 50),
                  const Text('Copyright @westbaystars'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
