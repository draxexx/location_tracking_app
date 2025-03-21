part of '../past_days_screen.dart';

class _PastDaysItems extends StatelessWidget {
  const _PastDaysItems();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => const _PastDayItem(),
      itemCount: 4,
    );
  }
}

class _PastDayItem extends StatelessWidget {
  const _PastDayItem();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "2021-09-01",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SummaryItems(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ),
        const Divider(),
      ],
    );
  }
}
