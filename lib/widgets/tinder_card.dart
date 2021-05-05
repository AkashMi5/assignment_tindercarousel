 import 'package:flutter/material.dart';
import 'package:assignment_tindercarousel/models/tinder_user.dart' ;

class TinderCard extends StatefulWidget {

  final TinderUser tinderUser ;

  TinderCard(this.tinderUser) ;

  @override
  _TinderCardState createState() => _TinderCardState();
}

class _TinderCardState extends State<TinderCard> {

  @override
  initState(){
    getUserName();
    super.initState();
  }

  getUserName(){
      userInfo = this.widget.tinderUser.userName.first + " " + this.widget.tinderUser.userName.last ;
  }

  List<bool> selectedInfo = [true, false, false, false, false] ;
  String prefixText = "Name" ;
  String userInfo = " ";

  // This function maanage the click on the different sections of the user profile like email, phone, dob etc.
  // It will show the data according to the section tapped by the user.
  onSelection(int index){
    selectedInfo = selectedInfo.map((e) => false).toList();
    selectedInfo[index] = true;
    switch(index){
      case 0:
        prefixText = "Name" ;
        userInfo = this.widget.tinderUser.userName.first + " " + this.widget.tinderUser.userName.last ;
        break;
      case 1:
        prefixText = "Email" ;
        userInfo = this.widget.tinderUser.email ;
        break;
      case 2:
        prefixText = "My address is" ;
        userInfo = this.widget.tinderUser.location.street + " " + this.widget.tinderUser.location.city ;
        break;
      case 3:
        prefixText = "My phone number" ;
        userInfo = this.widget.tinderUser.phone ;
        break;
      case 4:
        prefixText = "Birthday" ;
        userInfo = this.widget.tinderUser.dob ;
    }
    setState(() {
    });
  }



  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height ;
    double screenWidth = MediaQuery.of(context).size.width ;

    return Container(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                color: Colors.grey.shade200,
                height: screenHeight*0.2,
                width: screenWidth*0.9,
              ),
              Container(
                color: Colors.white,
                height: screenHeight*0.4,
                width: screenWidth*0.9,
              ),
            ],
          ),

          Positioned(
            top: screenHeight*0.08,
            left: screenWidth*0.1,
            right: screenWidth*0.1,
              child: Container(
                 height: screenWidth*0.3,
                 width: screenWidth*0.3,
                decoration : BoxDecoration(
                shape: BoxShape.circle ,
                color: const Color(0xff7c94b6),
                image:  DecorationImage(
                image: NetworkImage(this.widget.tinderUser.imageUrl),
                fit: BoxFit.cover, ),
                border: Border.all( color: Colors.white, width: 4, ),
                //borderRadius: BorderRadius.circular(12),
                 ),
               )
              ),

          Positioned(
            top: screenHeight*0.25,
            left: screenWidth*0.1,
            right: screenWidth*0.1,
            child: Column(
              children: <Widget>[
                Text(prefixText,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.blueGrey
                ),
                ),
                SizedBox(
                 height: 8,
                ),

                Container(
                  height: 48,
                  width: screenWidth,
                  child: Center(
                    child: Text(userInfo,
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 30,
                ),

              Container(
                height: 4,
                width: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.green
                ),
              ),

                SizedBox(
                  height: 16,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal : 8.0),
                      child: InkWell(
                        onTap: (){
                          onSelection(0);
                        },
                          child: Image.asset('images/profile.png', height: 36, width: 36, color: selectedInfo[0] ? Colors.green : Colors.grey,)
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal : 8.0),
                      child: InkWell(
                          onTap: (){
                            onSelection(1);
                          },
                          child: Image.asset('images/email.png', height: 36, width: 36, color: selectedInfo[1] ? Colors.green : Colors.grey,)
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal : 8.0),
                      child: InkWell(
                          onTap: (){
                            onSelection(2);
                          },
                          child: Image.asset('images/location.png', height: 36, width: 36, color: selectedInfo[2] ? Colors.green : Colors.grey,)
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal : 8.0),
                      child: InkWell(
                          onTap: (){
                            onSelection(3);
                          },
                          child: Image.asset('images/phone.png', height: 36, width: 36, color: selectedInfo[3] ? Colors.green : Colors.grey,)
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal : 8.0),
                      child: InkWell(
                          onTap: (){
                            onSelection(4);
                          },
                          child: Image.asset('images/dob.png', height: 36, width: 36, color: selectedInfo[4] ? Colors.green : Colors.grey,)
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
       )
      );

  }
}
