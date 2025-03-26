import 'package:flutter/material.dart';
import 'package:location_tracking_app/utils/extensions/duration_extensions.dart';
import 'package:location_tracking_app/utils/extensions/integer_extensions.dart';
import 'package:location_tracking_app/models/tracked_location_entry.dart';

class TrackedLocationEntries extends StatelessWidget {
  const TrackedLocationEntries({
    super.key,
    this.shrinkWrap = false,
    this.physics,
    required this.trackedLocationEntries,
  });

  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final List<TrackedLocationEntry> trackedLocationEntries;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemBuilder:
          (context, index) => _TrackedLocationEntry(
            trackedLocationEntry: trackedLocationEntries[index],
          ),
      itemCount: trackedLocationEntries.length,
    );
  }
}

class _TrackedLocationEntry extends StatelessWidget {
  const _TrackedLocationEntry({required this.trackedLocationEntry});

  final TrackedLocationEntry trackedLocationEntry;

  @override
  Widget build(BuildContext context) {
    return Text(
      "\"${trackedLocationEntry.place.displayName}\": ${trackedLocationEntry.durationInSeconds.toDuration().formatDuration()}",
    );
  }
}
