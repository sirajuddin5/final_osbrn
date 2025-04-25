// import 'package:flutter/material.dart';
// import 'package:osborn_book/widgets/custom_alert_dialog.dart';
//
// import '../shared_prefrences/shared_prefremces.dart';
//
//
//
// Container CustomDrawer(BuildContext context) {
//   var media = MediaQuery.of(context).size;
//   bool isNotSelectedColor =true;
//   return Container(
//
//     child: Drawer(
//
//       backgroundColor: Color(0xff393742),
//
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: <Widget>[
//           DrawerHeader(
//             decoration: BoxDecoration(
//               color: Colors.deepPurple,
//             ),
//             child: Expanded(
//               child: Image.asset(
//                 'images/drawerosb.png',
//                 height: media.height*10,
//                 width: media.width*0.65,
//               ),
//             ),
//           ),
//           ListTile(
//             leading: Icon(Icons.book,color: Colors.white,),
//             title: Text('All Books',style: TextStyle(color: Colors.white),),
//             focusColor: Colors.green[900],
//             selectedTileColor: Colors.green[900],
//             tileColor: isNotSelectedColor?Colors.green[900]:Colors.transparent,
//             onTap: () {
//               isNotSelectedColor = true;
//               // Navigate to the All Books page
//
//             },
//
//
//
//           ),
//           ListTile(
//             leading: Icon(Icons.save_alt,color: Colors.white,),
//             title: Text('On Device',style: TextStyle(color: Colors.white)),
//             onTap: () {
//               // Navigate to the On Device page
//             },
//
//           ),
//           Divider(),
//           ListTile(
//             leading: Icon(Icons.exit_to_app,color: Colors.white,),
//             title: Text('Sign Out',style: TextStyle(color: Colors.white)),
//             subtitle: Text('books@osbornebooks.co.uk',style: TextStyle(color: Colors.white)),
//             onTap: () {
//               // Sign out logic
//               // _showLogoutDialog(context);
//               showCustomAlertDialog(context , () => logout(context) );
//             },
//
//           ),
//         ],
//       ),
//     ),
//   );
// }

import 'package:flutter/material.dart';
import 'package:osborn_book/widgets/custom_alert_dialog.dart';
import '../pdf/downloaded_pdf_list.dart';
import '../shared_prefrences/shared_prefremces.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String _selectedItem = 'All Books'; // Default selected item

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Container(
      child: Drawer(
        backgroundColor: Color(0xff393742),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Expanded(
                child: Image.asset(
                  'images/osbrndrwr.png',
                  height: media.height * 0.1,
                  width: media.width * 0.65,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.book, color: Colors.white),
              title: Text('All Books', style: TextStyle(color: Colors.white)),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
              focusColor: Colors.green[900],
              selectedTileColor: Colors.green[900],
              tileColor: _selectedItem == 'All Books' ? Color(0xff114f4d) : Colors.transparent,
              onTap: () {
                setState(() {
                  _selectedItem = 'All Books';
                  Navigator.pop(context);// Update selected item
                });
                // Navigate to the All Books page
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt, color: Colors.white),
              title: Text('On Device', style: TextStyle(color: Colors.white)),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
              tileColor: _selectedItem == 'On Device' ? Color(0xff114f4d) : Colors.transparent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DownloadedPdfsPage()),
                );

                setState(() {
                  _selectedItem = 'On Device'; // Update selected item
                });
                // Navigate to the On Device page
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.white),
              title: Text('Sign Out', style: TextStyle(color: Colors.white)),
              subtitle: Text('books@osbornebooks.co.uk', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Sign out logic
                // _showLogoutDialog(context);
                showCustomAlertDialog(context, () => logout(context));
              },
            ),
          ],
        ),
      ),
    );
  }
}
