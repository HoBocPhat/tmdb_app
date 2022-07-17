

class User{
  User();

  late String? avatar;
  late int id;
  late String iso_639_1;
  late String iso_3166_1;
  late String name;
  late bool includeAdult;
  late String? username;

 User.fromJson(Map<String, dynamic> json){
    if(json['avatar']['tmbd']['avatarpath'] != null){
      avatar = json['avatar']['tmbd']['avatarpath'];
    }

    id = json['id'];
    iso_639_1 = json['iso_639_1'];
    iso_3166_1 = json['iso_3166_1'];
    name = json['name'];
    includeAdult = json['include_adult'];
    username = json['username'];
  }


}