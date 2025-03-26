part of '../past_days_screen.dart';

class _PastTrackedLocationEntries extends StatelessWidget {
  const _PastTrackedLocationEntries({required this.dailySummaries});

  final List<DailySummary> dailySummaries;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder:
          (context, index) =>
              _PastTrackedLocationEntry(dailySummary: dailySummaries[index]),
      itemCount: dailySummaries.length,
    );
  }
}

class _PastTrackedLocationEntry extends StatelessWidget {
  const _PastTrackedLocationEntry({required this.dailySummary});

  final DailySummary dailySummary;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          dailySummary.date.formatDate(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        TrackedLocationEntries(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          trackedLocationEntries: dailySummary.trackedLocationEntries,
        ),
        const Divider(),
      ],
    );
  }
}
