import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:assignment_tindercarousel/utilities/constants.dart' ;
import 'package:assignment_tindercarousel/models/tinder_user.dart';
import 'package:assignment_tindercarousel/services/api_exception.dart' ;



class Api_Manager {


Future<dynamic> getUserData() async {

  try {
    final tinderuser_response = await http.get(Constants.API_URL).timeout(Duration(seconds: 10));

    if(tinderuser_response.statusCode == 200){

      print("Inside successful response") ;

      var resbody = json.decode(tinderuser_response.body) ;

        var tinderUserData = resbody['results'][0]['user'];

       TinderUser tinderUser;
       tinderUser = TinderUser.fromJson(tinderUserData);
       return tinderUser;
    }

    else {
      print("In else block");
      _returnResponse(tinderuser_response);
    }

  } on SocketException catch (e){
    print("Socket exception $e");
    return FetchDataException('No Internet connection') ;

  }  on TimeoutException catch (e){
    print("Inside Timeout exception");
    return FetchDataException('No Internet connection') ;
  }

  catch (e) {
    print("In catch exception block");
    print(e);
    return e;

  }

}

dynamic _returnResponse(http.Response response){
  print(response.statusCode);
  switch (response.statusCode) {
    case 400:
    case 404:
      throw BadRequestException(response.body.toString());
    case 401:
    case 403:
      throw UnauthorisedException(response.body.toString());
    case 500:
    default:
      throw FetchDataException(
          'Error occured while Communication with Server with StatusCode : ${response
              .statusCode}');
  }
}

}

