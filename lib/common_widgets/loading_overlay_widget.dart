import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay(this.isLoading, {Key? key}) : super(key: key);
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            color: Colors.black38,
            width: 150,
            height: 150,
            child: const SpinKitWave(
              itemCount: 5,
              color: Colors.white,
              duration: Duration(milliseconds: 1000),
            ),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
