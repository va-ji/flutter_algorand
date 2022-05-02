import 'package:flutter/material.dart';

class CompleteService extends StatelessWidget {
  static const route = '/service';
  const CompleteService({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete a service'),
      ),
    );
  }
}
