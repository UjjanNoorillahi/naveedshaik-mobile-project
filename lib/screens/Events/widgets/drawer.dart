import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:h2o/screens/auth/login_screen.dart';
import 'package:h2o/screens/home_screen/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/sign_up_screen.dart';
import '../booked_events_screen.dart';

class CupertinoDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        height: MediaQuery.of(context).size.height,
        color: CupertinoColors.activeOrange,
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.14,
              color: CupertinoColors.black,
              alignment: Alignment.center,
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: CupertinoColors.white,
                  fontSize: 24,
                ),
              ),
            ),
            Container(
              color: CupertinoColors.activeOrange,

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Container(child: Image.asset('assets/logo/logo.png', height: 120, width: 200)),
                  // const Text('H2OEvents', style: TextStyle(color: CupertinoColors.white, fontSize: 24, fontWeight: FontWeight.bold)),

                ],
              ),
            ),
            // const Text("___________________________________________" , style: TextStyle(color: CupertinoColors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            CupertinoButton(
              onPressed: () {
                // Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Home(),
                  ),
                );

              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,

                children: [
                  Icon(CupertinoIcons.moon_stars_fill, color: CupertinoColors.white),
                  SizedBox(width: 10),
                  Text('View Items', style: TextStyle(color: CupertinoColors.white, fontSize: 19, fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            CupertinoButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const BookedEventsScreen(),
                  ),
                );
              },
              child: GestureDetector(
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const BookedEventsScreen(),
                    ),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,

                  children: [
                    Icon(CupertinoIcons.cart, color: CupertinoColors.white),
                    SizedBox(width: 10),
                    Text('Cart', style: TextStyle(color: CupertinoColors.white, fontSize: 19, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),

            // CupertinoButton(
            //   onPressed: () {
            //     Navigator.pop(context);
            //   },
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //
            //     children: [
            //       Icon(CupertinoIcons.timer, color: CupertinoColors.white),
            //       SizedBox(width: 10),
            //       Text('Past Event', style: TextStyle(color: CupertinoColors.white, fontSize: 19, fontWeight: FontWeight.bold)),
            //     ],
            //   ),
            // ),
            CupertinoButton(
              onPressed: () async {

                final SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('userToken');
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LoginScreen())
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,

                children: [
                  Icon(Icons.logout, color: CupertinoColors.white),
                  SizedBox(width: 10),
                  Text('Logout', style: TextStyle(color: CupertinoColors.white, fontSize: 19, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
