import 'package:cointiply_app/features/home/presentation/widgets/home_section_container.dart';
import 'package:flutter/material.dart';

import 'join_crypto_event_widget.dart';

class HomeEventSection extends StatelessWidget {
  const HomeEventSection({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeSectionContainer(
        width: double.infinity,
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                  color: Color(0xff00131E).withAlpha(127),
                ),
                child: Container(
                    constraints: BoxConstraints(maxWidth: 1240),
                    padding: const EdgeInsets.symmetric(vertical: 25.0),
                    margin: EdgeInsets.symmetric(horizontal: 25),
                    child: JoinCryptoEventWidget())),
            Center(
                child: Container(
              constraints: BoxConstraints(maxWidth: 1240),
              padding: const EdgeInsets.symmetric(vertical: 25.0),
              margin: EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [],
              ),
            )),
          ],
        ));
  }
}
