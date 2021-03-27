import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class OverlayCard extends StatelessWidget {
  final PickedFile imagefile;
  final String title;

  const OverlayCard({
    this.imagefile,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(5),
      child: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                  image: FileImage(
                    File(imagefile.path),
                  ),
                  fit: BoxFit.fitWidth),
            ),
          ),
          Positioned(
            bottom: 2,
            left: 1,
            right: 1,
            child: Container(
              padding: EdgeInsets.all(8),
              // height: 55,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                // borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     height: MediaQuery.of(context).size.height * 0.55,
  //     width: MediaQuery.of(context).size.width,
  //     padding: EdgeInsets.all(5),
  //     child: Column(
  //       children: <Widget>[
  //         Container(
  //           height: MediaQuery.of(context).size.height * 0.4,
  //           width: MediaQuery.of(context).size.width,
  //           decoration: BoxDecoration(
  //             color: Colors.black,
  //             borderRadius: BorderRadius.circular(8),
  //             image: DecorationImage(
  //                 image: FileImage(
  //                   File(imagefile.path),
  //                 ),
  //                 fit: BoxFit.fitWidth),
  //           ),
  //         ),
  //         Expanded(
  //           child: Container(
  //             padding: EdgeInsets.all(8),
  //             height: MediaQuery.of(context).size.height * 0.15,
  //             width: MediaQuery.of(context).size.width,
  //             decoration: BoxDecoration(
  //                 color: Colors.white, borderRadius: BorderRadius.circular(9)),
  //             child: Text(
  //               title,
  //               overflow: TextOverflow.visible,
  //               style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 15,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
