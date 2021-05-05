 import 'package:assignment_tindercarousel/view_models/favourite_count.dart';
import 'package:flutter/material.dart' ;
 import 'package:assignment_tindercarousel/utilities/database_helper.dart' ;
 import 'package:assignment_tindercarousel/models/tinder_user.dart' ;
 import 'package:assignment_tindercarousel/widgets/tinder_card.dart' ;
 import 'package:provider/provider.dart';
 import 'package:assignment_tindercarousel/view_models/favourite_count.dart' ;

class SavedProfiles extends StatefulWidget {

  @override
  _SavedProfilesState createState() => _SavedProfilesState();
}

class _SavedProfilesState extends State<SavedProfiles> {
  DatabaseHelper database  = DatabaseHelper.db ;

  List<TinderUser> tinderUsers = [] ;
  int numOfFav = 0;

  @override
  void initState() {
   getSavedProfiles();
    super.initState();
  }

  getSavedProfiles() async {
    tinderUsers = await database.getTinderUsers() ;
    numOfFav = tinderUsers.length ;
  //  print(tinderUsers[0].imageUrl);
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    double cHeight = MediaQuery.of(context).size.height ;
    double cWidth = MediaQuery.of(context).size.width ;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Saved Profiles",
        style: TextStyle(
          color: Colors.white
        ),),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(top: cHeight*0.1, left: cWidth*0.05, right: cWidth*0.05),
          height: cHeight ,
          width: cWidth ,
          color: Colors.blueGrey,
          child: Center(
            child: numOfFav > 0  ? Column(
              children: <Widget>[
                Container(
                  height: cHeight*0.7,
                  child: PageView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, position) {
                      return TinderCard(tinderUsers[position]);
                    },
                    itemCount: tinderUsers.length,
                  ),
                ),

                InkWell(
                  onTap: () async {
                    //Clear all the rows in the table of the saved users' profiles.
                    await database.deleteAll();
                    Provider.of<FavouriteCount>(context, listen: false).setFavCount(0) ;
                    getSavedProfiles();
                  },
                  child: Container(
                    height: 32,
                    child: Text("Clear all favourites",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),),
                  ),
                )
              ],
            ) :
            Container(
              child: Text(
                "No Saved Profiles yet",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18
                ),
              )
            ),
          ),
        ),
      ),
    );
  }
}
