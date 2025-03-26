import 'package:flutter/material.dart';
import 'package:location_tracking_app/core/utils/extensions/duration_extensions.dart';
import 'package:location_tracking_app/core/utils/extensions/integer_extensions.dart';
import 'package:location_tracking_app/models/place_entry.dart';

class SummaryItems extends StatelessWidget {
  const SummaryItems({
    super.key,
    this.shrinkWrap = false,
    this.physics,
    required this.placeEntries,
  });

  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final List<PlaceEntry> placeEntries;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemBuilder:
          (context, index) => _SummaryItem(placeEntry: placeEntries[index]),
      itemCount: placeEntries.length,
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({required this.placeEntry});

  final PlaceEntry placeEntry;

  @override
  Widget build(BuildContext context) {
    return Text(
      "\"${placeEntry.place.displayName}\": ${placeEntry.timeSpent.toDuration().formatDuration()}",
    );
  }
}
