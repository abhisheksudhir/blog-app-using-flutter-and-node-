import 'package:flutter/material.dart';

import 'package:blog_app/models/ProfileModel.dart';
import 'package:blog_app/NetworkHandler.dart';

class MainProfile extends StatefulWidget {
  static const routeName = '/main-profile';

  @override
  _MainProfileState createState() => _MainProfileState();
}

class _MainProfileState extends State<MainProfile> {
  bool circular = true;
  ProfileModel profileModel = ProfileModel();
  NetworkHandler networkHandler = NetworkHandler();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var response = await networkHandler.get("/profile/getData");
    setState(() {
      profileModel = ProfileModel.fromJson(response["data"]);
      circular = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEEEEFF),
      body: circular
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    head(),
                    Divider(
                      thickness: 0.8,
                    ),
                    otherDetails(
                      "About",
                      profileModel.about,
                    ),
                    otherDetails(
                      "Name",
                      profileModel.name,
                    ),
                    otherDetails(
                      "Profession",
                      profileModel.profession,
                    ),
                    otherDetails(
                      "DOB",
                      profileModel.dOB,
                    ),
                    Divider(
                      thickness: 0.8,
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    padding: EdgeInsets.all(20),
                    icon: Icon(Icons.edit),
                    onPressed: () {},
                    color: Colors.black,
                  ),
                ),
              ],
            ),
    );
  }

  Widget head() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: CircleAvatar(
              radius: 75,
              backgroundImage: NetworkHandler().getImage(profileModel.img.url),
            ),
          ),
          Text(
            profileModel.username,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            profileModel.titleline,
          )
        ],
      ),
    );
  }

  Widget otherDetails(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "$label :",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            value,
            style: TextStyle(fontSize: 15),
          )
        ],
      ),
    );
  }
}
