part of '../past_days_screen.dart';

class _PastDaysItems extends StatelessWidget {
  const _PastDaysItems({required this.locationTrackDays});

  final List<LocationTrackDay> locationTrackDays;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder:
          (context, index) =>
              _PastDayItem(locationTrackDay: locationTrackDays[index]),
      itemCount: locationTrackDays.length,
    );
  }
}

class _PastDayItem extends StatelessWidget {
  const _PastDayItem({required this.locationTrackDay});

  final LocationTrackDay locationTrackDay;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          locationTrackDay.date?.formatDate() ?? "",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SummaryItems(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          locationTracks: locationTrackDay.locationTracks ?? [],
        ),
        const Divider(),
      ],
    );
  }
}
