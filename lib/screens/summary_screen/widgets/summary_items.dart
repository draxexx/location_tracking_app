import 'package:flutter/material.dart';
import 'package:location_tracking_app/core/utils/extensions/duration_extensions.dart';
import 'package:location_tracking_app/core/utils/extensions/integer_extensions.dart';
import 'package:location_tracking_app/models/location_track.dart';

class SummaryItems extends StatelessWidget {
  const SummaryItems({
    super.key,
    this.shrinkWrap = false,
    this.physics,
    required this.locationTracks,
  });

  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final List<LocationTrack> locationTracks;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemBuilder:
          (context, index) =>
              _SummaryItem(locationTrack: locationTracks[index]),
      itemCount: locationTracks.length,
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({required this.locationTrack});

  final LocationTrack locationTrack;

  @override
  Widget build(BuildContext context) {
    return Text(
      "\"${locationTrack.location.displayName}\": ${locationTrack.timeSpent.toDuration().formatDuration()}",
    );
  }
}
