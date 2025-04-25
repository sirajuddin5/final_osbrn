
import 'package:flutter/material.dart';

// Updated showCustomAlertDialog function with an async logout callback parameter
void showCustomAlertDialog(BuildContext context, Future<void> Function() logout) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.black87, // Set the background color to black
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Optional: round corners
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Sign Out',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Are you sure you want to sign out?',
                maxLines: 1,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20.0),
            const Divider(
              thickness: 2,
              color: Colors.white12,
            ),
            // Add some spacing
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.blue, // Set button text color to blue
                    ),
                  ),
                ),
                // const VerticalDivider(
                //   color: Colors.red,
                //   width: 7,
                //   thickness: 5,
                // ),
                Container(
                  width: 2, // Set the width of the container
                  height: 40, // Set a fixed height for the divider
                  color: Colors.white12, // Set divider color
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop(); // Close the dialog
                    await logout(); // Call the async logout function
                  },
                  child: Text(
                    'Sign Out',
                    style: TextStyle(
                      color: Colors.red, // Set button text color to red
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0), // Add some spacing at the bottom
          ],
        ),
      );
    },
  );
}
