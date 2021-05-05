import 'package:flutter/material.dart';
import 'package:assignment_tindercarousel/utilities/database_helper.dart' ;

class FavouriteCount extends ChangeNotifier {

  final DatabaseHelper database = DatabaseHelper.db;

  int favCount = 0 ;

  int get favouriteCount  {
    return favCount ;
  }

  setFavCount(int count) {
    favCount = count ;

    notifyListeners();
  }

  int incrementCounter() {

    favCount = favCount + 1;

    notifyListeners() ;

  }

  int decrementCounter() {

    favCount = favCount - 1;

    notifyListeners() ;

  }


}