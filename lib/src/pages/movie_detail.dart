
import 'package:flutter/material.dart';
import 'package:movies/src/models/actor_model.dart';
import 'package:movies/src/models/movie_model.dart';
import 'package:movies/src/providers/movies_provider.dart';


class MovieDetail extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final Movie movie = ModalRoute.of(context).settings.arguments;


    return Scaffold(
      body:CustomScrollView(
        slivers: <Widget>[
          _createAppBar(movie),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 20,),
                _poster(context, movie),
                _description(movie),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10.0),
                  child: Text(
                    'Casting',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                _casting(movie)

              ]
            )

          ),
        ],
      )
    );
  }

  Widget _createAppBar(Movie movie){

    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          movie.title,
          style:TextStyle(color: Colors.white, fontSize: 16.0)
        ),
        background: FadeInImage(
          placeholder: AssetImage('assets/wait.gif'),
          image: NetworkImage(movie.getBackgrounImage()),
          fit: BoxFit.cover,
        ),
      ),



    );


  }

  Widget _poster(BuildContext context, Movie movie){

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          Hero(
            tag: movie.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                image:NetworkImage(movie.getPosterImage()),
                height: 150.0,
               ),
            ),
          ),
          SizedBox(width: 20.0),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start ,
              children: <Widget>[
                Text(
                  movie.title,
                 style: Theme.of(context).textTheme.title ,
                 overflow: TextOverflow.ellipsis,
                 textAlign: TextAlign.left,),
                Text(movie.originalTitle, 
                  style: Theme.of(context).textTheme.subhead ,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left),
                SizedBox(height: 5.0,),
                Row(
                  children: <Widget>[
                    Icon(Icons.star_border, color: Colors.blueAccent,),
                    Text(movie.voteAverage.toString(),style: Theme.of(context).textTheme.subhead ,overflow: TextOverflow.ellipsis)
                  ],
                ),


              ],
            )
          )
        ],
      ),

    );

  }

 Widget _description(Movie movie){

   return Container(
     padding: EdgeInsets.all(20.0),
     child: Text(
       movie.overview,
       textAlign: TextAlign.justify,
     ),
   );

 }

 Widget _casting(Movie movie){

   final movieProvider = new MoviesProvider();

   return FutureBuilder(
      future: movieProvider.getCast(movie.id.toString()),
      builder: ( context, AsyncSnapshot<List> snapshot) {

          if (snapshot.hasData){
            return _createActorsPageView(snapshot.data);
          }else{
             return Center(child: CircularProgressIndicator());
          }
      },
    );
 }

 Widget _createActorsPageView(List<Actor> actors){

   return SizedBox(
      height: 160.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(
          initialPage: 1,
          viewportFraction: 0.3
        ),
        itemCount: actors.length,
        itemBuilder:(contex , i){
          return _actorCard(actors[i]);
        }
      ),
   ) ;

 }

  Widget _actorCard(Actor actor){

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0 ),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              placeholder: AssetImage('assets/no-image.png'),
              image: NetworkImage(actor.getActorImage()),
              height: 120.0,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 5.0,),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis,
          )

        ],
      ),
    );


  }



}