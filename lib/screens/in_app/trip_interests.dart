import 'package:flutter/material.dart';
import 'package:orchestrator/models/trip_interest.dart';
import 'package:orchestrator/screens/widgets/heading_text.dart';
import 'package:orchestrator/screens/widgets/normal_text.dart';
import 'package:orchestrator/screens/widgets/trip_interests_widget.dart';
import 'package:orchestrator/utils/dimensions.dart';

class TripInterests extends StatefulWidget {
  final List<TripInterest> tripInterests;
  final String location;
  final String tripMessage;
  final String tripDateAndTime;
  final String tripProposer;
  const TripInterests(
      {super.key,
      required this.tripInterests,
      required this.tripMessage,
      required this.tripDateAndTime,
      required this.location,
      required this.tripProposer});

  @override
  State<TripInterests> createState() => _TripInterestsState();
}

class _TripInterestsState extends State<TripInterests> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0F4F3),
        title: Text(widget.location),
      ),
      body: Container(
        margin: EdgeInsets.only(left: screenWidth(20), right: screenWidth(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HeadingText(text: widget.location),
            SizedBox(
              height: screenHeight(10),
            ),
            NormalText(text: widget.tripMessage),
            SizedBox(
              height: screenHeight(10),
            ),
            Row(
              children: [
                const Text(
                  "Trip proposed by: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                NormalText(text: widget.tripProposer),
              ],
            ),
            SizedBox(
              height: screenHeight(10),
            ),
            Row(
              children: [
                const Text(
                  "Date: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                NormalText(text: widget.tripDateAndTime),
              ],
            ),
            SizedBox(
              height: screenHeight(10),
            ),
            const HeadingText(text: "Trip interests"),
            SizedBox(
              height: screenHeight(5),
            ),
            Expanded(
              child: widget.tripInterests.isEmpty
                  ? const Center(
                      child: Text("No one interested in this trip yet"),
                    )
                  : ListView.builder(
                      itemBuilder: (context, int index) {
                        return TripInterestsWidget(
                            tripInterest: widget.tripInterests[index]);
                      },
                      itemCount: widget.tripInterests.length,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
