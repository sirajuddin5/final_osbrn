import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:osborn_book/home/home_page.dart';

import '../token/tokens.dart';

class Guide extends StatefulWidget {
  const Guide({super.key});

  @override
  State<Guide> createState() => _GuideState();
}

class _GuideState extends State<Guide> {
  int page = 0;
  PageController? pageController = PageController();

  List pageArr = [
    {
      "title": "Working with EBooks",
      "sub_title":
          "Press and hold to open the toolbox.\nSlide your finger to select an item.",
      "img": "images/bg1.png"
    },
    {
      "title": "Working with EBooks",
      "sub_title": "Choose a tool to start\nworking with the ebook.",
      "img": "images/bg2.png"
    },
    {
      "title": "Working with EBooks",
      "sub_title":
          "Highlights, notes, marks and bookmarks are\nsynchronised across all of your devices.",
      "img": "images/bg3.png"
    },
  ];

  @override
  void initState() {
    super.initState();

    pageController?.addListener(() {
      page = pageController?.page?.round() ?? 0;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black54,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
                controller: pageController,
                itemCount: pageArr.length,
                itemBuilder: (context, index) {
                  var pObj = pageArr[index] as Map? ?? {};
                  return Container(
                    width: media.width,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    child: Column(
                      children: [
                        Text(
                          pObj["title"].toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          pObj["sub_title"].toString(),
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: Color(0xFF57bfab), fontSize: 14),
                        ),
                        SizedBox(
                          height: media.width * 0.25,
                        ),
                        Image.asset(
                          pObj["img"].toString(),
                          width: media.width * 0.9,
                          height: media.width * 0.9,
                          fit: BoxFit.fitWidth,
                        ),
                      ],
                    ),
                  );
                }),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage(deviceToken: deviceTokenUniversal,)));
                        },
                        child: Text(
                          "Skip",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w700),
                        ),
                      ),

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: pageArr.map((pObj) {
                          var index = pageArr.indexOf(pObj);

                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                                color: page == index
                                    ? Colors.white
                                    : Colors.cyan,
                                borderRadius: BorderRadius.circular(7.5)),
                          );
                        }).toList(),
                      ),

                      TextButton(
                        onPressed: () {
                          if (page < 2) {
                            page = page + 1;
                            pageController?.jumpToPage(page);
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>  HomePage(deviceToken: deviceTokenUniversal,)));
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.purple, // Set the background color to purple
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Add padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // Round the edges
                          ),
                        ),
                        child: Text(
                          "Got it!",
                          style: TextStyle(
                            color: Colors.white, // Set the text color to white
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
                SizedBox(
                  height: media.width * 0.15,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
