part of '../past_days_screen.dart';

class _PastDailyPlaceEntries extends StatelessWidget {
  const _PastDailyPlaceEntries({required this.dailyPlaceEntries});

  final List<DailyPlaceEntry> dailyPlaceEntries;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder:
          (context, index) =>
              _PastDailyPlaceEntry(dailyPlaceEntry: dailyPlaceEntries[index]),
      itemCount: dailyPlaceEntries.length,
    );
  }
}

class _PastDailyPlaceEntry extends StatelessWidget {
  const _PastDailyPlaceEntry({required this.dailyPlaceEntry});

  final DailyPlaceEntry dailyPlaceEntry;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          dailyPlaceEntry.date?.formatDate() ?? "",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        PlaceEntries(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          placeEntries: dailyPlaceEntry.placeEntries ?? [],
        ),
        const Divider(),
      ],
    );
  }
}
