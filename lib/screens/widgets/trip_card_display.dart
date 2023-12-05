import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orchestrator/bloc/check_weather/check_weather_bloc.dart';
import 'package:orchestrator/bloc/check_weather/check_weather_event.dart';
import 'package:orchestrator/bloc/check_weather/check_weather_state.dart';
import 'package:orchestrator/bloc/express_trip_interest/express_trip_interest_bloc.dart';
import 'package:orchestrator/bloc/express_trip_interest/express_trip_interest_event.dart';
import 'package:orchestrator/bloc/express_trip_interest/express_trip_interest_state.dart';
import 'package:orchestrator/models/trip.dart';
import 'package:orchestrator/screens/in_app/home_page.dart';
import 'package:orchestrator/screens/in_app/trip_interests.dart';
import 'package:orchestrator/screens/widgets/custom_button.dart';
import 'package:orchestrator/screens/widgets/heading_text.dart';
import 'package:orchestrator/screens/widgets/input_field_widget.dart';
import 'package:orchestrator/screens/widgets/normal_text.dart';
import 'package:orchestrator/utils/dimensions.dart';

class TripCardDisplay extends StatefulWidget {
  final Trip trip;
  final int userId;
  final String userName;
  final bool tripInterestExpressed;
  const TripCardDisplay(
      {super.key,
      required this.trip,
      required this.userId,
      required this.userName,
      required this.tripInterestExpressed});

  @override
  State<TripCardDisplay> createState() => _TripCardDisplayState();
}

class _TripCardDisplayState extends State<TripCardDisplay> {
  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CheckWeatherBloc>(
          create: (context) => CheckWeatherBloc(),
        ),
        BlocProvider<ExpressTripInterestBloc>(
          create: (context) => ExpressTripInterestBloc(),
        ),
      ],
      child: Column(
        children: [
          SizedBox(
            height: screenHeight(10),
          ),
          const Row(),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TripInterests(
                    tripInterests: widget.trip.tripInterests!,
                    tripMessage: widget.trip.message,
                    tripDateAndTime: widget.trip.dateAndTime,
                    location: widget.trip.location,
                    tripProposer: widget.trip.userName,
                  ),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.only(
                left: screenWidth(30),
                top: screenHeight(20),
                right: screenWidth(30),
                bottom: screenHeight(20),
              ),
              // height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    screenWidth(10),
                  ),
                ),
                border: Border.all(
                  width: screenWidth(1),
                  color: const Color(0xFF4ECDBE),
                ),
              ),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HeadingText(
                              text: widget.trip.location.length < 20
                                  ? widget.trip.location
                                  : "${widget.trip.location.substring(0, 20)}..."),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const NormalText(text: "Trip proposer: "),
                              NormalText(
                                text: widget.trip.userID == widget.userId
                                    ? "(You) ${widget.trip.userName}"
                                    : widget.trip.userName,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: screenHeight(10),
                          ),
                          NormalText(
                              text: widget.trip.message.length < 20
                                  ? widget.trip.message
                                  : "${widget.trip.message.substring(0, 20)}..."),
                          SizedBox(
                            height: screenHeight(10),
                          ),
                          Row(
                            children: [
                              const NormalText(text: "proposed on: "),
                              NormalText(text: widget.trip.dateAndTime),
                            ],
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          widget.trip.tripInterests!.isNotEmpty
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TripInterests(
                                      tripInterests: widget.trip.tripInterests!,
                                      tripMessage: widget.trip.message,
                                      tripDateAndTime: widget.trip.dateAndTime,
                                      location: widget.trip.location,
                                      tripProposer: widget.trip.userName,
                                    ),
                                  ),
                                )
                              : ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text("No person interested yet..."),
                                    duration: Duration(microseconds: 1000),
                                  ),
                                );
                        },
                        child: Column(
                          children: [
                            Text(
                                "${widget.trip.tripInterests!.length} interested"),
                            widget.trip.tripInterests!.isNotEmpty
                                ? const Icon(Icons.arrow_right)
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight(10),
                  ),
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
                                          text: "Date: ${state.weather!.date}"),
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
                            width: screenWidth(260),
                            height: screenHeight(50),
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
                            borderColor: Colors.blue,
                          );
                        case CheckingStatus.checking:
                          return Container(
                            width: screenWidth(260),
                            height: screenHeight(50),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4ECDBE),
                              borderRadius: BorderRadius.all(
                                Radius.circular(screenWidth(10)),
                              ),
                              border: Border(
                                bottom: BorderSide(
                                    width: screenWidth(1),
                                    color: const Color(0xFF4ECDBE)),
                                left: BorderSide(
                                    width: screenWidth(1),
                                    color: const Color(0xFF4ECDBE)),
                                right: BorderSide(
                                    width: screenWidth(1),
                                    color: const Color(0xFF4ECDBE)),
                                top: BorderSide(
                                    width: screenWidth(1),
                                    color: const Color(0xFF4ECDBE)),
                              ),
                            ),
                            child: SizedBox(
                              height: screenHeight(30),
                              width: screenWidth(30),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          );
                        case CheckingStatus.success:
                          return CustomButton(
                            width: screenWidth(260),
                            height: screenHeight(50),
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
                            borderColor: Colors.blue,
                          );
                        case CheckingStatus.failure:
                          return CustomButton(
                            width: screenWidth(260),
                            height: screenHeight(50),
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
                  SizedBox(
                    height: screenHeight(10),
                  ),
                  widget.trip.userID == widget.userId
                      ? const SizedBox()
                      : widget.tripInterestExpressed
                          ? Container(
                              width: screenWidth(260),
                              height: screenHeight(50),
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(screenWidth(10))),
                              ),
                              child: const Center(child: Text("Interested")),
                            )
                          : CustomButton(
                              width: screenWidth(260),
                              height: screenHeight(50),
                              text: "Express interest",
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return BlocProvider(
                                        create: (context) =>
                                            ExpressTripInterestBloc(),
                                        child: AlertDialog(
                                          content: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                HeadingText(
                                                    text: widget.trip.location),
                                                SizedBox(
                                                    height: screenHeight(10)),
                                                const NormalText(
                                                    text:
                                                        "Interested with this trip?"),
                                                SizedBox(
                                                  height: screenHeight(10),
                                                ),
                                                InputFieldWidget(
                                                  controller: messageController,
                                                  inputHeading: "Message",
                                                  hintText:
                                                      "Express your interest with a short note",
                                                  maxLines: null,
                                                  formHeight: screenHeight(150),
                                                  centered: false,
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                "Cancel",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ),
                                            BlocConsumer<
                                                ExpressTripInterestBloc,
                                                ExpressTripInterestState>(
                                              listener: (context, state) {
                                                if (state.status ==
                                                    ExpressingStatus.success) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          "Interest in trip expressed..."),
                                                    ),
                                                  );
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          HomePage(
                                                              userName: widget
                                                                  .userName,
                                                              userId: widget
                                                                  .userId),
                                                    ),
                                                  );
                                                } else if (state.status ==
                                                    ExpressingStatus.failure) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          "Failed to express interest in trip. Try later..."),
                                                    ),
                                                  );
                                                }
                                              },
                                              builder: (context, state) {
                                                switch (state.status) {
                                                  case ExpressingStatus.initial:
                                                    return TextButton(
                                                      onPressed: () {
                                                        if (messageController
                                                            .text
                                                            .trim()
                                                            .isNotEmpty) {
                                                          BlocProvider.of<
                                                                      ExpressTripInterestBloc>(
                                                                  context)
                                                              .add(
                                                            TripInterestExpressed(
                                                              tripID: widget
                                                                  .trip.tripID,
                                                              interestedPersonId:
                                                                  widget.userId,
                                                              proposerUserName:
                                                                  widget.trip
                                                                      .userName,
                                                              interestedPersonUserName:
                                                                  widget
                                                                      .userName,
                                                              interestedPersonMessage:
                                                                  messageController
                                                                      .text,
                                                            ),
                                                          );
                                                        } else {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                              content: Text(
                                                                  "Write a note"),
                                                            ),
                                                          );
                                                        }
                                                      },
                                                      child:
                                                          const Text("Confirm"),
                                                    );
                                                  case ExpressingStatus
                                                        .expressing:
                                                    return SizedBox(
                                                      height: screenHeight(25),
                                                      width: screenWidth(25),
                                                      child:
                                                          const CircularProgressIndicator(),
                                                    );
                                                  case ExpressingStatus.success:
                                                    return TextButton(
                                                      onPressed: () {},
                                                      child:
                                                          const Text("Confirm"),
                                                    );
                                                  case ExpressingStatus.failure:
                                                    return TextButton(
                                                      onPressed: () {
                                                        if (messageController
                                                            .text
                                                            .trim()
                                                            .isNotEmpty) {
                                                          BlocProvider.of<
                                                                      ExpressTripInterestBloc>(
                                                                  context)
                                                              .add(
                                                            TripInterestExpressed(
                                                              tripID: widget
                                                                  .trip.tripID,
                                                              interestedPersonId:
                                                                  widget.userId,
                                                              proposerUserName:
                                                                  widget.trip
                                                                      .userName,
                                                              interestedPersonUserName:
                                                                  widget
                                                                      .userName,
                                                              interestedPersonMessage:
                                                                  messageController
                                                                      .text,
                                                            ),
                                                          );
                                                        } else {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                              content: Text(
                                                                  "Write a note"),
                                                            ),
                                                          );
                                                        }
                                                      },
                                                      child:
                                                          const Text("Confirm"),
                                                    );
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                              },
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              borderSize: screenWidth(1),
                              borderColor: Colors.blue,
                            ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
