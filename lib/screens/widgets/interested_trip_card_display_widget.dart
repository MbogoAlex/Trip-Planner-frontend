import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orchestrator/bloc/check_weather/check_weather_bloc.dart';
import 'package:orchestrator/bloc/check_weather/check_weather_event.dart';
import 'package:orchestrator/bloc/check_weather/check_weather_state.dart';
import 'package:orchestrator/models/trip.dart';
import 'package:orchestrator/models/trip_interest.dart';
import 'package:orchestrator/screens/widgets/custom_button.dart';
import 'package:orchestrator/screens/widgets/heading_text.dart';
import 'package:orchestrator/screens/widgets/normal_text.dart';
import 'package:orchestrator/utils/dimensions.dart';

class InterestedTripCardDisplay extends StatefulWidget {
  final String proposerMessage;
  final Trip trip;
  final String interestedPersonMessage;
  final TripInterest tripInterest;
  const InterestedTripCardDisplay({
    super.key,
    required this.proposerMessage,
    required this.trip,
    required this.interestedPersonMessage,
    required this.tripInterest,
  });

  @override
  State<InterestedTripCardDisplay> createState() =>
      _InterestedTripCardDisplayState();
}

class _InterestedTripCardDisplayState extends State<InterestedTripCardDisplay> {
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
                      HeadingText(text: widget.tripInterest.location),
                      SizedBox(
                        height: screenHeight(10),
                      ),
                      NormalText(
                          text:
                              "${widget.trip.userName}: ${widget.proposerMessage}"),
                      SizedBox(
                        height: screenHeight(10),
                      ),
                      NormalText(
                          text:
                              "You: ${widget.tripInterest.interestedPersonMessage}"),
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
        margin: EdgeInsets.only(
            left: screenWidth(20),
            right: screenWidth(20),
            top: screenHeight(10)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(screenWidth(10))),
        ),
        child: ListTile(
          title: HeadingText(
            text: "Location: ${widget.trip.location}".length < 20
                ? "Location: ${widget.trip.location}"
                : "${"Location: ${widget.trip.location}".substring(0, 20)}...",
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    "Proposed by: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  NormalText(
                    text: widget.trip.userName.length < 20
                        ? widget.trip.userName
                        : "${widget.trip.userName.substring(0, 20)}...",
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    "Proposed on: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  NormalText(text: widget.trip.dateAndTime),
                ],
              ),
              SizedBox(
                height: screenHeight(10),
              ),
              Row(
                children: [
                  const Text(
                    "Trip message: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  NormalText(
                      text: widget.trip.message.length < 20
                          ? widget.trip.message
                          : "${widget.trip.message.substring(0, 20)}..."),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Text(
                    "You expressed interest on: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  NormalText(text: widget.tripInterest.localDateTime),
                ],
              ),
              SizedBox(
                height: screenHeight(10),
              ),
              Row(
                children: [
                  const Text(
                    "You said: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  NormalText(
                      text: widget.tripInterest.interestedPersonMessage.length <
                              20
                          ? widget.tripInterest.interestedPersonMessage
                          : "${widget.tripInterest.interestedPersonMessage.substring(0, 20)}..."),
                ],
              ),
              SizedBox(
                height: screenHeight(20),
              ),
              BlocProvider(
                create: (context) => CheckWeatherBloc(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlocConsumer<CheckWeatherBloc, CheckWeatherState>(
                      listener: (context, state) {
                        if (state.status == CheckingStatus.failure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text("Failed to check weather. Try later..."),
                            ),
                          );
                        } else if (state.status == CheckingStatus.success) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        HeadingText(
                                            text:
                                                "${widget.trip.location} weather"),
                                        SizedBox(
                                          height: screenHeight(10),
                                        ),
                                        NormalText(
                                            text:
                                                "Date: ${state.weather!.date}"),
                                        SizedBox(
                                          height: screenHeight(10),
                                        ),
                                        NormalText(
                                            text:
                                                "Temperature: ${state.weather!.temperature} °C"),
                                        SizedBox(
                                          height: screenHeight(10),
                                        ),
                                        NormalText(
                                            text:
                                                "Current condition: ${state.weather!.currentCondition}"),
                                        SizedBox(
                                          height: screenHeight(10),
                                        ),
                                        NormalText(
                                            text:
                                                "Prediction: ${state.weather!.prediction}"),
                                        SizedBox(
                                          height: screenHeight(10),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Back"))
                                  ],
                                );
                              });
                        }
                      },
                      builder: (context, state) {
                        switch (state.status) {
                          case CheckingStatus.initial:
                            return CustomButton(
                              width: screenWidth(200),
                              height: screenHeight(40),
                              text: "Check weather",
                              onPressed: () {
                                BlocProvider.of<CheckWeatherBloc>(context).add(
                                  WeatherChecked(
                                    location: widget.trip.location,
                                  ),
                                );
                              },
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              borderSize: 1,
                              borderColor: Colors.blue,
                            );
                          case CheckingStatus.checking:
                            return Container(
                              width: screenWidth(200),
                              height: screenHeight(40),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(screenWidth(10)),
                                ),
                                border: Border(
                                  bottom: BorderSide(
                                      width: screenWidth(1),
                                      color: Colors.blue),
                                  left: BorderSide(
                                      width: screenWidth(1),
                                      color: Colors.blue),
                                  right: BorderSide(
                                      width: screenWidth(1),
                                      color: Colors.blue),
                                  top: BorderSide(
                                      width: screenWidth(1),
                                      color: Colors.blue),
                                ),
                              ),
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: screenHeight(10),
                                    bottom: screenHeight(10)),
                                height: screenHeight(5),
                                width: screenWidth(5),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            );
                          case CheckingStatus.success:
                            return CustomButton(
                              width: screenWidth(200),
                              height: screenHeight(40),
                              text: "Check weather",
                              onPressed: () {
                                BlocProvider.of<CheckWeatherBloc>(context).add(
                                  WeatherChecked(
                                    location: widget.trip.location,
                                  ),
                                );
                              },
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              borderSize: screenWidth(1),
                              borderColor: const Color(0xFF4ECDBE),
                            );
                          case CheckingStatus.failure:
                            return CustomButton(
                              width: screenWidth(200),
                              height: screenHeight(40),
                              text: "Check weather",
                              onPressed: () {
                                BlocProvider.of<CheckWeatherBloc>(context).add(
                                  WeatherChecked(
                                    location: widget.trip.location,
                                  ),
                                );
                              },
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              borderSize: screenWidth(1),
                              borderColor: Colors.black,
                            );
                        }
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
