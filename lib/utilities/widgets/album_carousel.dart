

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:wigi/models/album_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class CarouselAlbum extends StatelessWidget {
  final List<Album> albums;
  const CarouselAlbum(this.albums,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: CarouselSlider(
        options: CarouselOptions(height: 120.w,autoPlay: true,autoPlayCurve: Curves.fastOutSlowIn),
        items: albums.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return FadeInDown(
                duration: const Duration(milliseconds: 1000),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 15.0),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Row(
                      children: [
                        ZoomIn(
                          duration: const Duration(seconds: 2),
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(imageUrl: i.images.first.url,),
                              )
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(child: Text(i.name,overflow: TextOverflow.visible,style: const TextStyle(fontWeight: FontWeight.bold),)),
                                const SizedBox(height: 10,),
                                Flexible(child: Text(i.artists.first.name,overflow: TextOverflow.visible,style: const TextStyle(),))

                              ],
                            ),
                          ),
                        )
                      ],
                    )
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
