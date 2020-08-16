import 'package:flutter/material.dart';
import 'package:movies/src/models/movie_model.dart';
import 'package:movies/src/providers/movies_provider.dart';

class DataSearch extends SearchDelegate {

  String selected = '';
  MoviesProvider moviesProvider = new MoviesProvider();

  final movies = [
    '1917',
    'Onward',
    'Avengers',
    'Spiderman',
    'Trolls',
    'Joker',
    'Parasite',
    'Star Wars',
    'Star Wars V'
  ];

  final recentMovies = ['Spiderman', 'Star Wars'];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Text(selected),
    );
  }



@override
  Widget buildSuggestions(BuildContext context) {

    if (query.isEmpty){
      return Container();
    }else{


      return FutureBuilder(
        future:moviesProvider.searchMovie(query) ,
        builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {  

          if (snapshot.hasData){

            final movies = snapshot.data;

            return ListView(
              children: movies.map((movie) {

                return ListTile(
                  leading: FadeInImage(
                    placeholder: AssetImage('assets/no-image.png'),
                    image: NetworkImage(movie.getPosterImage()),
                    width: 50.0,
                    fit: BoxFit.cover
                  ),
                  title: Text(movie.title),
                  subtitle: Text(movie.originalTitle),
                  onTap: (){
                    close(context, null);
                    movie.uniqueId = '';
                    Navigator.pushNamed(context, 'detail',arguments: movie);

                  },
                );

              }).toList(),
            );

          }else{
            return Center(child: CircularProgressIndicator());
          }

        },
      );


    }


  }




  // @override
  // Widget buildSuggestions(BuildContext context) {


  //   final sugestList = (query.isEmpty) 
  //                       ? recentMovies
  //                       : movies.where((m) => m.toLowerCase().startsWith(query.toLowerCase())
  //                       ).toList();

  //   return ListView.builder(
  //       itemCount: sugestList.length,
  //       itemBuilder: (context, i) {
  //         return ListTile(
  //           leading: Icon(Icons.movie_creation),
  //           title: Text(sugestList[i]),
  //           onTap: (){
  //             selected = sugestList[i];
  //             showResults(context);
  //           },
  //         );
  //       });
  // }
}
