import 'package:flutter/material.dart';

class EmptyChannels extends StatelessWidget {
  const EmptyChannels({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/empty.png',
            height: 150,
          ),
          const SizedBox(height: 10),
          const Text(
            'There are no messages',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Pick a person and start your conservation',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
        ],
      ),
    );
  }
}
