import 'package:flutter/material.dart';
import 'package:location_tracking_app/core/layouts/base_screen_layout.dart';
import 'package:location_tracking_app/screens/summary_screen/widgets/summary_items.dart';

part 'widgets/past_days_items.dart';

class PastDaysScreen extends StatelessWidget {
  const PastDaysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      title: "Past Days Screen",
      child: const _PastDaysItems(),
    );
  }
}
