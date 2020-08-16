import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:movies/src/models/movie_model.dart';

class CardSwiper extends StatelessWidget {
  CardSwiper({@required this.cardItems});
  final List<Movie> cardItems;

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          cardItems[index].uniqueId = '${cardItems[index].id}-card';
          return Hero(
            tag: cardItems[index].uniqueId,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, 'detail',
                      arguments: cardItems[index]),
                  child: FadeInImage(
                    placeholder: AssetImage('assets/no-image.png'),
                    image: NetworkImage(cardItems[index].getPosterImage()),
                    fit: BoxFit.cover,
                  ),
                )),
          );
        },
        itemCount: cardItems.length,
        itemWidth: _screenSize.width * 0.7,
        itemHeight: _screenSize.height * 0.5,
        layout: SwiperLayout.STACK,
      ),
    );
  }
}
