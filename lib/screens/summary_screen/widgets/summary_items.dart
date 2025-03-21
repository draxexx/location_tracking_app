import 'package:flutter/material.dart';

class SummaryItems extends StatelessWidget {
  const SummaryItems({super.key, this.shrinkWrap = false, this.physics});

  final bool shrinkWrap;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemBuilder: (context, index) => const _SummaryItem(),
      itemCount: 10,
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem();

  @override
  Widget build(BuildContext context) {
    return Text("\"Home\": 1h 30m");
  }
}
