
class TinderUser {

  UserName userName ;
  String email ;
  String phone ;
  Location location ;
  String dob ;
  String imageUrl ;


  TinderUser({ this.userName, this.email, this.phone, this.location, this.dob, this.imageUrl}) ;

  factory TinderUser.fromJson(Map<String, dynamic> jsonData) {
    return TinderUser(
        userName: UserName.fromJson(jsonData['name']),
        email: jsonData['email'] ,
        phone: jsonData['phone'] ,
        location: Location.fromJson(jsonData['location']),
        dob: jsonData['dob'],
        imageUrl: jsonData['picture']
    );
  }

  factory TinderUser.fromLocalDBJson(Map<String, dynamic> jsonData) {
    return TinderUser(
      userName: UserName(
        title: "",
        first: jsonData['username_first'],
        last: jsonData['username_last']),
      email: jsonData['email'],
      phone: jsonData['phone'],
      dob: jsonData['dob'],
      imageUrl: jsonData['image_url'],
      location: Location(
        street: jsonData['location_street'],
        city: jsonData['location_city'],
        state: "",
        zip: "",
      )
    ) ;
  }


 Map<String, dynamic> toJson() => {
   'username_first' : userName.first,
   'username_last' : userName.last,
   'email' : email,
   'phone' : phone,
   'location_street' : location.street,
   'location_city' : location.city,
   'dob' : dob,
   'image_url' : imageUrl
 } ;


}


  class UserName {

    String title ;
    String first ;
    String last ;

    UserName({this.title, this.first, this.last}) ;

    factory UserName.fromJson(Map<String, dynamic> jsonData) {
      return UserName(
        title: jsonData['title'],
        first: jsonData['first'],
        last: jsonData['last']
      ) ;
    }
  }

  class Location {

  String street;
  String city ;
  String state ;
  String zip ;

  Location({this.street, this.city, this.state, this.zip}) ;

  factory Location.fromJson(Map<String, dynamic> jsonData) {
    return Location(
        street: jsonData['street'],
        city: jsonData['city'],
        state: jsonData['state'],
        zip: jsonData['zip']
    ) ;
  }
}
