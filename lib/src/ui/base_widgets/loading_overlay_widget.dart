import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay(this.isLoading, {Key? key}) : super(key: key);
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        color: Colors.white10,
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              //color: Colors.white38,
              width: 150,
              height: 150,
              padding: const EdgeInsets.all(50),
              child: const CircularProgressIndicator(
                strokeWidth: 6,
              ),
            ),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
