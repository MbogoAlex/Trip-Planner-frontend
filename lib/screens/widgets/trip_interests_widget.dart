import 'package:flutter/material.dart';
import 'package:orchestrator/models/trip_interest.dart';
import 'package:orchestrator/screens/widgets/heading_text.dart';
import 'package:orchestrator/screens/widgets/normal_text.dart';
import 'package:orchestrator/utils/dimensions.dart';

class TripInterestsWidget extends StatefulWidget {
  final TripInterest tripInterest;
  const TripInterestsWidget({super.key, required this.tripInterest});

  @override
  State<TripInterestsWidget> createState() => _TripInterestsWidgetState();
}

class _TripInterestsWidgetState extends State<TripInterestsWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeadingText(
                          text: widget.tripInterest.interestedPersonUserName),
                      SizedBox(
                        height: screenHeight(10),
                      ),
                      NormalText(
                          text: widget.tripInterest.interestedPersonMessage),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Back",
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                ],
              );
            });
      },
      child: Container(
        // margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(screenWidth(10))),
        ),
        child: ListTile(
          title: Text(
            widget.tripInterest.interestedPersonUserName,
            style: TextStyle(
                fontSize: screenHeight(24), fontWeight: FontWeight.w500),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NormalText(
                text: widget.tripInterest.interestedPersonMessage.length < 40
                    ? widget.tripInterest.interestedPersonMessage
                    : "${widget.tripInterest.interestedPersonMessage.substring(0, 40)}...",
              ),
              SizedBox(
                height: screenHeight(10),
              ),
              Text(
                widget.tripInterest.localDateTime,
                style: const TextStyle(fontWeight: FontWeight.w300),
              ),
            ],
          ),
          trailing: const Icon(Icons.arrow_right),
        ),
      ),
    );
  }
}
