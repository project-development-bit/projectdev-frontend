import 'package:flutter/widgets.dart';

class CommonLoadingWidget extends StatelessWidget {
  final double? width;
  final double? height;
  const CommonLoadingWidget({super.key, this.width, this.height});

  factory CommonLoadingWidget.small({Key? key}) {
    return CommonLoadingWidget(
      key: key,
      width: 50,
      height: 50,
    );
  }

  factory CommonLoadingWidget.medium({Key? key}) {
    return CommonLoadingWidget(
      key: key,
      width: 100,
      height: 100,
    );
  }

  factory CommonLoadingWidget.large({Key? key}) {
    return CommonLoadingWidget(
      key: key,
      width: 200,
      height: 200,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/gigafaucet_loading.gif',
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }
}
