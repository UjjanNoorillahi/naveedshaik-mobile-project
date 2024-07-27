import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:h2o/constant/const.dart';
import 'package:h2o/screens/Events/service/booked_event_service.dart';
import 'package:h2o/screens/Events/service/buy_ticket_service.dart';
import 'package:h2o/screens/home_screen/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

import 'book_ticket/book_ticket_screen.dart';
import 'booked_event_details_screen.dart';
import 'event_details_screen.dart';
import 'models/booked_event_model.dart';

class BookedEventsScreen extends StatefulWidget {
  const BookedEventsScreen({super.key});

  @override
  State<BookedEventsScreen> createState() => _BookedEventsScreenState();
}

class _BookedEventsScreenState extends State<BookedEventsScreen> {
  late BookedEventService apiService;
  List<Event> bookedEvents = [];
  bool isLoading = true; // Track loading state
  double price = 0.0;

  @override
  void initState() {
    super.initState();
    apiService = BookedEventService(
      baseUrl: BASE_URL,
    );
    _fetchBookedEvents();
  }

  bool loginCheck = true;

  Future<void> _fetchBookedEvents() async {
    try {
      List<Event> events = await apiService.getBookedEvents();
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      price = prefs.getDouble('totalPrice')!;

      setState(() {
        bookedEvents = events;
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Cart'),
      ),
      child: isLoading
          ? const Center(child: CupertinoActivityIndicator(radius: 15)) // iOS style loader
          : price > 0.0
          ? ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          final event = bookedEvents[index];

          String isoDate =  event.date.toString();
          DateTime date = DateTime.parse(isoDate);

          // Set up the format you want
          DateFormat formatter = DateFormat('MM-dd-yyyy');  // Example: 2024-02-22
          String formattedDate = formatter.format(date);

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                // Row(
                //   children: [
                //     const Icon(
                //       Icons.confirmation_number_rounded,
                //       size: 25,
                //       color: Colors.black,
                //     ),
                //     Text(
                //       'Items Qty: ',
                //       style: const TextStyle(
                //           fontSize: 18, fontWeight: FontWeight.bold),
                //     ),
                //     Text(
                //       bookedEvents.length.toString(),
                //       style: const TextStyle(
                //         fontSize: 18,
                //       ),
                //     )
                //   ],
                // ),
                const SizedBox(
                  height: 20,
                ),

                Row(
                  children: [
                    const Icon(
                      Icons.price_change,
                      size: 25,
                      color: Colors.black,
                    ),
                    Text(
                      'Total Price: ',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      price.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    )
                  ],
                ),

                SizedBox(
                  height: 60,
                ),

                // add address textformfield
                CupertinoTextField(
                  // controller: widget.controller,
                  keyboardType: TextInputType.text,
                  padding: const EdgeInsets.all(20),
                  placeholder: "Full Address",
                  // obscureText: widget.obscureText && _obscureText,

                  // style: TextStyle(
                  //   color:
                  // ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  // prefix: Padding(
                  //   padding: const EdgeInsets.all(20.0),
                  //   child: GestureDetector(
                  //     onTap: () {
                  //       setState(() {
                  //         // _obscureText = !_obscureText;
                  //       });
                  //     },
                  //     child: Icon(
                  //       Icons.visibility
                  //
                  //     ),
                  //   ),
                  // )
                ),

                SizedBox(
                  height: 20,
                ),

                CupertinoTextField(
                  // controller: widget.controller,
                  keyboardType: TextInputType.number,
                  padding: const EdgeInsets.all(20),
                  placeholder: "Card Number",
                  // obscureText: widget.obscureText && _obscureText,

                  // style: TextStyle(
                  //   color:
                  // ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  // prefix: Padding(
                  //   padding: const EdgeInsets.all(20.0),
                  //   child: GestureDetector(
                  //     onTap: () {
                  //       setState(() {
                  //         // _obscureText = !_obscureText;
                  //       });
                  //     },
                  //     child: Icon(
                  //       Icons.visibility
                  //
                  //     ),
                  //   ),
                  // )
                ),

                SizedBox(
                  height: 20,
                ),
                CupertinoTextField(
                  // controller: widget.controller,
                  keyboardType: TextInputType.number,
                  padding: const EdgeInsets.all(10),
                  placeholder: "CSV - 376",
                  // obscureText: widget.obscureText && _obscureText,

                  // style: TextStyle(
                  //   color:
                  // ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  // prefix: Padding(
                  //   padding: const EdgeInsets.all(20.0),
                  //   child: GestureDetector(
                  //     onTap: () {
                  //       setState(() {
                  //         // _obscureText = !_obscureText;
                  //       });
                  //     },
                  //     child: Icon(
                  //       Icons.visibility
                  //
                  //     ),
                  //   ),
                  // )
                ),

                SizedBox(
                  height: 20,
                ),

                CupertinoTextField(
                  // controller: widget.controller,
                  keyboardType: TextInputType.text,
                  padding: const EdgeInsets.all(10),
                  placeholder: "Card Expiry - (02/26)",
                  // obscureText: widget.obscureText && _obscureText,

                  // style: TextStyle(
                  //   color:
                  // ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  // prefix: Padding(
                  //   padding: const EdgeInsets.all(20.0),
                  //   child: GestureDetector(
                  //     onTap: () {
                  //       setState(() {
                  //         // _obscureText = !_obscureText;
                  //       });
                  //     },
                  //     child: Icon(
                  //       Icons.visibility
                  //
                  //     ),
                  //   ),
                  // )
                ),

                SizedBox(
                  height: 30,
                ),



                Align(
                    // alignment: Alignment.centerRight,
                    child: ElevatedButton(onPressed: () async {
                      // makePayment(context);

                      setState(() {
                        loginCheck = false;
                      });




                      Timer(const Duration(seconds: 2), () {
                        // Navigate to the welcome screen
                        toastification.show(
                          context: context,
                          title: const Text('Order Status!'),
                          description: const Text('Order successfully placed...'),
                          autoCloseDuration: const Duration(seconds: 3),
                        );

                      });

                      Timer(const Duration(seconds: 3), () {
                        // Navigate to the welcome screen

                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => Home(),
                          ),
                        );
                      });

                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setDouble('totalPrice', 0.0);

                    }, child: loginCheck ?  Text("Checkout") : CircularProgressIndicator(

                      // value: 10,
                    )))
              ],
            )


            // GestureDetector(
            //   onTap: () {
            //
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => BookedEventDetailsScreen(event: event),
            //       ),
            //     );
            //
            //   },
            //   child: Container(
            //       width: MediaQuery.of(context).size.width *
            //           0.9, // Take up the entire screen width
            //
            //       height: MediaQuery.of(context).size.height /
            //           3, // One-third// of the screen height
            //       decoration: const BoxDecoration(
            //         color: Colors.black,
            //         borderRadius: BorderRadius.all(Radius.circular(30)),
            //       ),
            //       child: Column(
            //         children: [
            //           Container(
            //               decoration: const BoxDecoration(
            //                 color: Colors.black,
            //                 borderRadius:
            //                 BorderRadius.all(Radius.circular(30)),
            //               ),
            //               height: MediaQuery.of(context).size.height / 4.2,
            //               child: Container(
            //                 // child: NetworkImage,
            //                 child: Image.network(
            //                     event.images.isEmpty ? "https://res.cloudinary.com/dx3kgoad5/image/upload/v1707300650/images/1707300647385.webp" :event.images[0].toString()
            //                   // 'https://res.cloudinary.com/dx3kgoad5/image/upload/v1715459813/images/1715459813550.png,',
            //                   // height: 300,
            //                   // width: 350,
            //                 ),
            //               )),
            //           Expanded(
            //             child: Container(
            //               width: MediaQuery.of(context).size.width *
            //                   0.9, // Take up the entire screen width
            //               height: MediaQuery.of(context).size.height /
            //                   6, // One-third// of the screen height
            //               decoration: BoxDecoration(
            //                 color: Colors.white,
            //                 borderRadius: const BorderRadius.all(
            //                   Radius.circular(30),
            //                 ),
            //                 border: Border.all(
            //                   color: Colors
            //                       .black, // Set the border color to black
            //                   width: 2.0, // Set the border width
            //                 ),
            //               ),
            //               child:  Column(
            //                 children: [
            //                   Text(
            //                     event.title.toString(), overflow: TextOverflow.ellipsis, maxLines: 1,
            //                     style: const TextStyle(
            //                       fontSize: 20,
            //                       fontFamily: primaryFont,
            //                       fontWeight: FontWeight.w400,
            //                     ),
            //                   ),
            //
            //                   // Padding(
            //                   //   padding: const EdgeInsets.only(left: 10.0),
            //                   //   child: Align(
            //                   //     alignment: Alignment.centerLeft,
            //                   //     child: Text(
            //                   //       '  $formattedDate',
            //                   //       style: const TextStyle(
            //                   //         fontSize: 16,
            //                   //         fontFamily: primaryFont,
            //                   //         fontWeight: FontWeight.w400,
            //                   //       ),
            //                   //     ),
            //                   //   ),
            //                   // ),
            //                   //
            //                   //
            //                   // Padding(
            //                   //   padding: const EdgeInsets.only(left: 17.0),
            //                   //   child: Align(
            //                   //     alignment: Alignment.centerLeft,
            //                   //     child: Text(
            //                   //       event.time.toString(),
            //                   //       style: const TextStyle(
            //                   //         fontSize: 20,
            //                   //         fontFamily: primaryFont,
            //                   //         fontWeight: FontWeight.w400,
            //                   //       ),
            //                   //     ),
            //                   //   ),
            //                   // ),
            //
            //                 ],
            //               ),
            //             ),
            //           )
            //         ],
            //       )
            //   ),
            // ),
          );
          // return Container(
          //   child: Column(
          //     children: [
          //       Text(event.title),
          //       Text(event.description),
          //
          //     ],
          //   ),
          // );
        },
      )
          : Center(child: Text('Cart is empty')),
    );
  }
}
