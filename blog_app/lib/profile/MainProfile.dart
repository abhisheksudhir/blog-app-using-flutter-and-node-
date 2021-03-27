import 'package:flutter/material.dart';

import 'package:blog_app/models/ProfileModel.dart';
import 'package:blog_app/profile/EditProfile.dart';
import 'package:blog_app/NetworkHandler.dart';

class MainProfile extends StatefulWidget {
  static const routeName = '/main-profile';

  @override
  _MainProfileState createState() => _MainProfileState();
}

class _MainProfileState extends State<MainProfile> {
  bool circular = true;
  bool error = false;
  ProfileModel profileModel = ProfileModel();
  NetworkHandler networkHandler = NetworkHandler();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  void fetchData() async {
    setState(() {
      circular = true;
    });
    var response = await networkHandler.get("/profile/getData");
    if (response == null) {
      setState(() {
        error = true;
        circular = false;
      });
    } else {
      setState(() {
        profileModel = ProfileModel.fromJson(response["data"]);
        circular = false;
        error = false;
      });
    }
  }

  Widget networkError() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            "Network Error",
            textAlign: TextAlign.center,
            style: TextStyle(
              // color: Colors.deepOrange,
              fontSize: 18,
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.refresh_sharp),
          onPressed: () {
            fetchData();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: circular
          ? Center(child: CircularProgressIndicator())
          : (error
              ? networkError()
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
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            EditProfile.routeName,
                            arguments: profileModel,
                          );
                        },
                        color: Colors.teal,
                      ),
                    ),
                  ],
                )),
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
              backgroundColor: Colors.white,
              // backgroundImage: NetworkHandler().getImage(profileModel.img.url),
              backgroundImage: NetworkImage(
                profileModel.img.url,
              ),
              // child: ClipOval(
              //   child: profileModel.img.url == null
              //       ? CircularProgressIndicator()
              //       : Image.network(
              //           profileModel.img.url,
              //           fit: BoxFit.cover,
              //         ),
              // ),
            ),
          ),
          SizedBox(
            height: 10,
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
