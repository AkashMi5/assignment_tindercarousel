import 'package:assignment_tindercarousel/models/tinder_user.dart';
import 'package:flutter/material.dart';
import 'package:swipeable_card/swipeable_card.dart';
import 'package:assignment_tindercarousel/widgets/tinder_card.dart';
import 'package:assignment_tindercarousel/services/api_manager.dart' ;
import 'package:assignment_tindercarousel/utilities/database_helper.dart' ;
import 'package:assignment_tindercarousel/screens/saved_profiles.dart' ;
import 'package:image_downloader/image_downloader.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:assignment_tindercarousel/view_models/favourite_count.dart' ;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // This provider will keep track of number of counts of favourites saved by the user
        ChangeNotifierProvider(create: (context) => FavouriteCount())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(),
      ),
    );
  }
}


class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<TinderCard> cards = [ ] ;
  final DatabaseHelper database = DatabaseHelper.db;
  List<TinderUser> users = [] ;

  @override
  initState(){
    getTinderUsersOnInitialize();
    super.initState();
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(value)));
  }

  // On start of the app, this function will fetch 2 profiles from the api.
  // These profiles will be saved and will show on swiping.
  getTinderUsersOnInitialize() async {
    Api_Manager api_Manager = Api_Manager() ;

    var response  = await api_Manager.getUserData() ;

    if(response is TinderUser){
      cards.add(TinderCard(response));
      users.add(response);
    }

    else {
      print("Exception has occured") ;
      String  _errorMssg = response.toString() ;
      print(_errorMssg);
      showInSnackBar("Please check your internet connection") ;
    }

    print(response.userName.first) ;

    var response2  = await api_Manager.getUserData() ;

    if(response2 is TinderUser){
      cards.add(TinderCard(response2));
      users.add(response);
    }

    else {
      print("Exception has occured") ;
      String  _errorMssg = response.toString() ;
      print(_errorMssg);
      showInSnackBar("Please check your internet connection") ;
    }

    print(response2.userName.first) ;

    setState(() {
    });

  }

  // This function will run when user swipe left or right.
  // It will fetch the next profile using api and save it in the array
  getTinderUser() async {
    Api_Manager api_Manager = Api_Manager();

    var response  = await api_Manager.getUserData() ;

    if(response is TinderUser){
      cards.add(TinderCard(response));
      users.add(response);
    }

    else {
      print("Exception has occured") ;
     String  _errorMssg = response.toString() ;
      print(_errorMssg);
      showInSnackBar("Please check your internet connection") ;
    }

    print(response.userName.first) ;
  }



  int currentCardIndex = 0;

  void swipeTop() {
    print("top");
  }

  void swipeBottom() {
    print("bottom");
  }

  void swipeLeft() async {
    print("left");

    await getTinderUser();

    // NOTE: it is your job to change the card
    setState(() => currentCardIndex++);
  }

  void swipeRight() async  {
    var path ;
    print("right");
    await getTinderUser();
 /*   String url = users[currentCardIndex].imageUrl ;
    try {
      // Saved with this method.
      var imageId = await ImageDownloader.downloadImage(url);
      if (imageId == null) {
        var fileName = await ImageDownloader.findName(imageId);
         path = await ImageDownloader.findPath(imageId);
      }
      print("Path $path" ) ;

      users[currentCardIndex].imageUrl = path ;

    } on PlatformException catch (error) {
      print(error);
    }*/
    int id = await database.insert(users[currentCardIndex]);

    int numOfSavedUsers = await database.getNumberOfSavedTinderUsers() ;    

    //Proivder will set the count and notify the listeners
    Provider.of<FavouriteCount>(context, listen: false).setFavCount(numOfSavedUsers) ;

    setState(() => currentCardIndex++);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xffF58529), Color(0xffDD2A7B) ]
            )
          ),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 60),
                height: MediaQuery.of(context).size.height*0.8,
                child: Column(
                  children: <Widget>[
                    if(currentCardIndex < cards.length)
                      SwipeableWidgetSlide(
                        key: ObjectKey(currentCardIndex),
                        child: cards[currentCardIndex],
                        nextCards: <Widget>[
                          if (currentCardIndex + 1 < cards.length)
                            Align(
                              alignment: Alignment.center,
                              child: cards[currentCardIndex + 1],
                            ),
                        ],
                        onLeftSwipe: () => swipeLeft(),
                        onRightSwipe: () => swipeRight(),
                        onBottomSwipe: () => swipeBottom(),
                        onTopSwipe: () => swipeTop(),
                      )
                    else
                      Center(
                        child: FlatButton(
                          child: Text("Getting user profiles for you"),
                          onPressed: () => setState(() => currentCardIndex = 0),
                        ),
                      ),
                  ],
                ),
              ),

              InkWell(
                onTap: (){
                  Navigator.of(context).push(_createRoute()) ;
                },
                child: Container(
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Image.asset('images/favourite.png', color: Colors.blue, height: 48, width: 48,),
                          Positioned(
                            right: 5,
                              top: -1,
                                child: Container(
                                  height: 16,
                                  width: 16,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                    shape: BoxShape.circle
                                  ),
                                  child: Consumer<FavouriteCount>(
                                   builder: (context, fav, child) {
                                    return Center(
                                      child: Text('${fav.favouriteCount}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.0,
                                              color: Colors.pink)),
                                    );
                                  }
                                  ),
                                ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ) ;


  }

 // Slide transition animation when moving to saved profile page
  Route _createRoute() {
    return PageRouteBuilder(
      opaque: false,
      pageBuilder: (context, animation, secondaryAnimation) => SavedProfiles(),
      transitionDuration: Duration(milliseconds: 1000),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }


}



