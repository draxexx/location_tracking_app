part of '../past_days_screen.dart';

class _PastDaysItems extends StatelessWidget {
  const _PastDaysItems({required this.dailyPlaceEntries});

  final List<DailyPlaceEntry> dailyPlaceEntries;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder:
          (context, index) =>
              _PastDayItem(dailyPlaceEntry: dailyPlaceEntries[index]),
      itemCount: dailyPlaceEntries.length,
    );
  }
}

class _PastDayItem extends StatelessWidget {
  const _PastDayItem({required this.dailyPlaceEntry});

  final DailyPlaceEntry dailyPlaceEntry;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          dailyPlaceEntry.date?.formatDate() ?? "",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SummaryItems(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          placeEntries: dailyPlaceEntry.placeEntries ?? [],
        ),
        const Divider(),
      ],
    );
  }
}
