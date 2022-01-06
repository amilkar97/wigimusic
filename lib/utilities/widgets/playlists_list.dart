import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wigi/models/playlist_model.dart';
import 'package:wigi/views/tracks_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class PlayListsList extends StatelessWidget {
  final List<Playlist> playlists;
  const PlayListsList(this.playlists, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return FadeInRight(
          duration: const Duration(milliseconds: 500),
          delay: Duration(milliseconds: 30*index),
          child: GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Tracks(playlists[index]),)),
            child: Container(
                color: Colors.black12,
                height: 100.0,
                child: Row(
                  children: [
                    ZoomIn(duration: const Duration(milliseconds: 500),child: Hero(tag: playlists[index].images.first.url,child: CachedNetworkImage(imageUrl: playlists[index].images.first.url))),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(playlists[index].name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.sp),),
                            const SizedBox(height: 10,),
                            Text(playlists[index].description,overflow: TextOverflow.ellipsis,maxLines: 2,),
                          ],
                        ),
                      ),
                    )
                  ],
                )
            ),
          ),
        );
      },
          childCount: playlists.length
      ),
    );
  }
}
