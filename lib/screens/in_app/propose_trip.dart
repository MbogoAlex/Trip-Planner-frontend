import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orchestrator/bloc/check_weather/check_weather_bloc.dart';
import 'package:orchestrator/bloc/check_weather/check_weather_event.dart';
import 'package:orchestrator/bloc/check_weather/check_weather_state.dart';
import 'package:orchestrator/bloc/propose_trip/propose_trip_bloc.dart';
import 'package:orchestrator/bloc/propose_trip/propose_trip_event.dart';
import 'package:orchestrator/bloc/propose_trip/propose_trip_state.dart';
import 'package:orchestrator/screens/in_app/home_page.dart';
import 'package:orchestrator/screens/widgets/custom_button.dart';
import 'package:orchestrator/screens/widgets/heading_text.dart';
import 'package:orchestrator/screens/widgets/input_field_widget.dart';
import 'package:orchestrator/screens/widgets/normal_text.dart';
import 'package:orchestrator/utils/dimensions.dart';

class ProposeTrip extends StatefulWidget {
  final int userId;
  final String userName;
  const ProposeTrip({super.key, required this.userId, required this.userName});

  @override
  State<ProposeTrip> createState() => _ProposeTripState();
}

class _ProposeTripState extends State<ProposeTrip> {
  TextEditingController locationController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0F4F3),
        title: const Text("Propose trip"),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<CheckWeatherBloc>(
            create: (context) => CheckWeatherBloc(),
          ),
          BlocProvider<ProposeTripBloc>(
            create: (context) => ProposeTripBloc(),
          ),
        ],
        child: Container(
          margin:
              EdgeInsets.only(left: screenWidth(10), right: screenWidth(10)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: screenHeight(80),
                ),
                InputFieldWidget(
                  controller: locationController,
                  inputHeading: "Trip location",
                  hintText: "Enter trip location",
                  formHeight: screenHeight(50),
                  maxLines: null,
                  centered: true,
                ),
                SizedBox(
                  height: screenHeight(20),
                ),
                InputFieldWidget(
                  controller: messageController,
                  inputHeading: "Message",
                  hintText: "Write something about the trip",
                  formHeight: screenHeight(150),
                  maxLines: null,
                  centered: false,
                ),
                SizedBox(
                  height: screenHeight(20),
                ),
                const NormalText(text: "Check weather of proposed location"),
                SizedBox(
                  height: screenHeight(20),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    HeadingText(
                                        text:
                                            "${locationController.text} weather"),
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
                          width: double.infinity,
                          height: screenHeight(50),
                          text: "Check weather",
                          onPressed: () {
                            if (locationController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Fill the location field..."),
                                ),
                              );
                            } else {
                              BlocProvider.of<CheckWeatherBloc>(context).add(
                                WeatherChecked(
                                    location: locationController.text),
                              );
                            }
                          },
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          borderSize: 1,
                          borderColor: Colors.black,
                        );
                      case CheckingStatus.checking:
                        return Container(
                          width: double.infinity,
                          height: screenHeight(50),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.all(
                              Radius.circular(screenHeight(10)),
                            ),
                            border: Border(
                              bottom: BorderSide(width: screenWidth(1)),
                              left: BorderSide(width: screenWidth(1)),
                              right: BorderSide(width: screenWidth(1)),
                              top: BorderSide(width: screenWidth(1)),
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
                          width: double.infinity,
                          height: screenHeight(50),
                          text: "Check weather",
                          onPressed: () {
                            if (locationController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Fill the location field..."),
                                ),
                              );
                            } else {
                              BlocProvider.of<CheckWeatherBloc>(context).add(
                                WeatherChecked(
                                    location: locationController.text),
                              );
                            }
                          },
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          borderSize: screenWidth(1),
                          borderColor: Colors.black,
                        );
                      case CheckingStatus.failure:
                        return CustomButton(
                          width: double.infinity,
                          height: screenHeight(50),
                          text: "Check weather",
                          onPressed: () {
                            if (locationController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Fill the location field..."),
                                ),
                              );
                            } else {
                              BlocProvider.of<CheckWeatherBloc>(context).add(
                                WeatherChecked(
                                    location: locationController.text),
                              );
                            }
                          },
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          borderSize: 1,
                          borderColor: Colors.black,
                        );
                    }
                  },
                ),
                SizedBox(
                  height: screenHeight(20),
                ),
                const NormalText(text: "Confirm trip proposal"),
                SizedBox(
                  height: screenHeight(20),
                ),
                BlocConsumer<ProposeTripBloc, ProposeTripState>(
                  listener: (context, state) {
                    if (state.status == ProposingStatus.failure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Failed to propose trip.Try later..."),
                        ),
                      );
                    } else if (state.status == ProposingStatus.success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Trip proposed"),
                        ),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(
                              userName: widget.userName, userId: widget.userId),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    switch (state.status) {
                      case ProposingStatus.initial:
                        return CustomButton(
                          width: double.infinity,
                          height: screenHeight(50),
                          text: "Confirm",
                          onPressed: () {
                            if (locationController.text.trim().isNotEmpty &&
                                messageController.text.trim().isNotEmpty) {
                              BlocProvider.of<ProposeTripBloc>(context).add(
                                TripProposed(
                                  userId: widget.userId,
                                  userName: widget.userName,
                                  message: messageController.text,
                                  location: locationController.text,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Fill all the fields"),
                                ),
                              );
                            }
                          },
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          borderSize: 1,
                          borderColor: Colors.black,
                        );
                      case ProposingStatus.proposing:
                        return Container(
                          width: double.infinity,
                          height: screenHeight(50),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.all(
                              Radius.circular(screenHeight(10)),
                            ),
                            border: Border(
                              bottom: BorderSide(width: screenWidth(1)),
                              left: BorderSide(width: screenWidth(1)),
                              right: BorderSide(width: screenWidth(1)),
                              top: BorderSide(width: screenWidth(1)),
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
                      case ProposingStatus.success:
                        return CustomButton(
                          width: double.infinity,
                          height: screenHeight(50),
                          text: "Confirm",
                          onPressed: () {
                            if (locationController.text.trim().isNotEmpty &&
                                messageController.text.trim().isNotEmpty) {
                              BlocProvider.of<ProposeTripBloc>(context).add(
                                TripProposed(
                                  userId: widget.userId,
                                  userName: widget.userName,
                                  message: messageController.text,
                                  location: locationController.text,
                                ),
                              );
                            }
                          },
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          borderSize: screenWidth(1),
                          borderColor: Colors.black,
                        );
                      case ProposingStatus.failure:
                        return CustomButton(
                          width: double.infinity,
                          height: screenHeight(50),
                          text: "Confirm",
                          onPressed: () {
                            if (locationController.text.trim().isNotEmpty &&
                                messageController.text.trim().isNotEmpty) {
                              BlocProvider.of<ProposeTripBloc>(context).add(
                                TripProposed(
                                  userId: widget.userId,
                                  userName: widget.userName,
                                  message: messageController.text,
                                  location: locationController.text,
                                ),
                              );
                            }
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
          ),
        ),
      ),
    );
  }
}
