
class Cast {

  List<Actor> actors = new List();

  Cast.fromJsonList(List<dynamic> jsonList){

    if ( jsonList == null) return;

    jsonList.forEach((item) {

      final actor = Actor.fromJsonMap(item);
      actors.add(actor);

    });


  }

}



class Actor {
  int castId;
  String character;
  String creditId;
  int gender;
  int id;
  String name;
  int order;
  String profilePath;

  Actor({
    this.castId,
    this.character,
    this.creditId,
    this.gender,
    this.id,
    this.name,
    this.order,
    this.profilePath,
  });


Actor.fromJsonMap(Map<String,dynamic> json){


  character     = json['character'];
  castId        = json['cast_id'];
  gender        = json['gender'];
  creditId      = json['credit_id'];
  name          = json['name'];
  id            = json['id'];
  profilePath   = json['profile_path'];
  order         = json['order'];

}

getActorImage() {
    if ( profilePath == null) {
      return 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQBKEGmmEQ4WlpXIfdqhhaFbJER2pXMLOFU3A&usqp=CAU';
    } else {
      return 'https://image.tmdb.org/t/p/w500/$profilePath';
    }
  }

}