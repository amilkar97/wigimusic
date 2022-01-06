import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wigi/models/album_model.dart';
import 'package:wigi/models/track_model.dart';
import 'package:wigi/views/track_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class TrackLister extends StatelessWidget {
  List<Track> tracks;
  TrackLister(this.tracks,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return FadeInRight(
          duration: const Duration(milliseconds: 500),
          delay: Duration(milliseconds: 30*index),
          child: GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TheTrack(tracks[index]),)),
            child: Container(
                color: Colors.black12,
                height: 100.0,
                child: Row(
                  children: [
                    ZoomIn(duration: const Duration(milliseconds: 500),child: Hero(tag: tracks[index].id,child: CachedNetworkImage(imageUrl: tracks[index].album.images.first.url))),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tracks[index].name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.sp),),
                            const SizedBox(height: 10,),
                            _getArtistNames(tracks[index].artists),
                            const SizedBox(height: 10,),
                            Text(((tracks[index].duration_ms/1000)/60).toStringAsFixed(0)+":"+((tracks[index].duration_ms%1000)%60).toStringAsFixed(0)+" minutes",overflow: TextOverflow.ellipsis,maxLines: 2,),
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
          childCount: tracks.length
      ),
    );
  }
  _getArtistNames(List<Artist> artists) {
    String names = "";
    for (var element in artists) {
      int index = artists.indexOf(element);
      if(index == artists.length-1){
        names += element.name;
      }else{
        names += element.name+", ";
      }
    }

    return Flexible(child: Text(names,overflow: TextOverflow.visible,maxLines: 2,));
  }
}
