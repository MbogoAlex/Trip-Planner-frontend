import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:orchestrator/bloc/fetch_trips/fetch_trips_bloc.dart';
import 'package:orchestrator/bloc/fetch_trips/fetch_trips_event.dart';
import 'package:orchestrator/bloc/fetch_trips/fetch_trips_state.dart'
    as fetch_all_trips;
import 'package:orchestrator/bloc/fetch_trips/fetch_trips_state.dart';

import 'package:orchestrator/models/trip_interest.dart';
import 'package:orchestrator/screens/in_app/propose_trip.dart';

import 'package:orchestrator/screens/widgets/interested_trip_card_display_widget.dart';
import 'package:orchestrator/screens/widgets/trip_card_display.dart';
import 'package:orchestrator/utils/dimensions.dart';
// import 'dart:developer' as debug;

class HomePage extends StatefulWidget {
  final String userName;
  final int userId;
  final int? currentIndex;
  const HomePage(
      {super.key,
      required this.userName,
      required this.userId,
      this.currentIndex});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  bool tripInterestExpressed = false;
  TripInterest? tripInterestedIn;

  void changeIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    // double screenHeight = MediaQuery.of(context).size.height;
    // print("SCREEN HEIGHT IS: $screenHeight");
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFF0F4F3),
          title: currentIndex == 0
              ? const Text("All trips")
              : const Text("Trips you are interested in"),
          actions: [
            currentIndex == 0
                ? Container(
                    margin: EdgeInsets.only(right: screenWidth(25)),
                    child: Row(
                      children: [
                        Text(
                          widget.userName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Icon(Icons.person),
                      ],
                    ),
                  )
                : SizedBox(),
          ],
        ),
        body: currentBodyWidget(),
        floatingActionButton: currentIndex == 0
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProposeTrip(
                          userId: widget.userId, userName: widget.userName),
                    ),
                  );
                },
                child: const Icon(Icons.add),
              )
            : const SizedBox(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: changeIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.travel_explore,
              ),
              label: "Trips",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.heart,
                color: Colors.red,
              ),
              label: "My interests",
            ),
          ],
        ),
      ),
    );
  }

  Widget currentBodyWidget() {
    switch (currentIndex) {
      case 0:
        return tripsWidget();
      case 1:
        return interestedTripsWidget();
      default:
        return tripsWidget();
    }
  }

  Widget tripsWidget() {
    return Container(
        margin: EdgeInsets.only(left: screenWidth(25), right: screenWidth(25)),
        child: MultiBlocProvider(
          providers: [
            BlocProvider<FetchTripsBloc>(
              create: (context) => FetchTripsBloc()
                ..add(
                  TripsFetched(),
                ),
            ),
          ],
          child: BlocConsumer<FetchTripsBloc, fetch_all_trips.FetchTripsState>(
            listener: (context, state) {
              if (state.status == fetch_all_trips.FetchingStatus.success) {
                // print("You have expressed interest in these trips\n");

                // print(state.tripsYouHaveExpressedInterestIn);
              }
            },
            builder: (context, state) {
              switch (state.status) {
                case fetch_all_trips.FetchingStatus.initial:
                  return const Center(child: CircularProgressIndicator());
                case fetch_all_trips.FetchingStatus.fetching:
                  return const Center(child: CircularProgressIndicator());
                case fetch_all_trips.FetchingStatus.success:
                  if (state.trips!.isEmpty) {
                    return const Center(
                      child: Text("No trip yet"),
                    );
                  }
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return TripCardDisplay(
                        trip: state.trips![index],
                        userId: widget.userId,
                        userName: widget.userName,
                        tripInterestExpressed: tripInterestExpressed,
                      );
                    },
                    itemCount: state.trips!.length,
                  );
                case fetch_all_trips.FetchingStatus.failure:
                  return const Center(
                    child: Text("An error occured"),
                  );
              }
            },
          ),
        ));
  }

  Widget interestedTripsWidget() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FetchTripsBloc>(
          create: (context) =>
              FetchTripsBloc()..add(TripsFetched(userId: widget.userId)),
        ),
      ],
      child: BlocConsumer<FetchTripsBloc, FetchTripsState>(
        listener: (context, state) {
          if (state.status == FetchingStatus.success) {
            // print("You have expressed interest in these trips\n");

            // print(state.tripsYouHaveExpressedInterestIn);
          }
        },
        builder: (context, state) {
          switch (state.status) {
            case FetchingStatus.initial:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case FetchingStatus.fetching:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case FetchingStatus.success:
              if (state.tripsYouHaveExpressedInterestIn!.isEmpty) {
                return const Center(
                  child: Text("You have expressed no interest in any trip"),
                );
              }

              return ListView.builder(
                itemBuilder: (context, int index) {
                  if (state.tripsYouHaveExpressedInterestIn![index]
                      .tripInterests!.isNotEmpty) {
                    for (TripInterest tripInterest in state
                        .tripsYouHaveExpressedInterestIn![index]
                        .tripInterests!) {
                      if (tripInterest.interestedPersonId == widget.userId) {
                        tripInterestedIn = tripInterest;
                        break;
                      }
                    }
                  }
                  return InterestedTripCardDisplay(
                    proposerMessage:
                        state.tripsYouHaveExpressedInterestIn![index].message,
                    trip: state.tripsYouHaveExpressedInterestIn![index],
                    interestedPersonMessage:
                        state.tripsYouHaveExpressedInterestIn![index].message,
                    tripInterest: tripInterestedIn!,
                  );
                },
                itemCount: state.tripsYouHaveExpressedInterestIn!.length,
              );
            case FetchingStatus.failure:
              return const Center(
                child: Text("Failed to fetch trips you are interested in"),
              );
          }
        },
      ),
    );
  }
}
