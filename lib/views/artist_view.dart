import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wigi/blocs/artist/artist_bloc.dart';
import 'package:wigi/models/track_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wigi/utilities/widgets/album_carousel.dart';
import 'package:wigi/utilities/widgets/track_list.dart';

class ArtistDetails extends StatelessWidget {
  final String artistID;
  const ArtistDetails(this.artistID,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => ArtistBloc(),child: _ArtistPage(artistID),);
  }
}

class _ArtistPage extends StatefulWidget {
  final String artistID;
  const _ArtistPage(this.artistID, {Key? key}) : super(key: key);

  @override
  _ArtistPageState createState() => _ArtistPageState();
}

class _ArtistPageState extends State<_ArtistPage> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  _loadData(){
    BlocProvider.of<ArtistBloc>(context).add(LoadArtistEvent(widget.artistID));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<ArtistBloc, ArtistState>(
      builder: (context, state) {
        if(state is ArtistLoaded){
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                snap: false,
                floating: false,
                expandedHeight: 275.0,forceElevated: true,
                flexibleSpace: FlexibleSpaceBar(
                  //title: Text(state.artist.name),

                  background: FadeInUp(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(state.artist.images!.first.url)
                        )
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(state.artist.name,style: TextStyle(fontSize: 30.sp),),
                          const SizedBox(height: 20,),
                          Text(state.artist.followers.toString()+' FOLLOWERS'),
                          const SizedBox(height: 10,),
                          Text(state.artist.popularity.toString()+' OF POPULARITY'),
                          const SizedBox(height: 10,),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    child: _track(state.topTracks)
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                      child: Text('Albums',style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.bold),)
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: CarouselAlbum(state.albums),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                      child: Text('Top Tracks',style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.bold),)
                  ),
                ),
              ),
              TrackLister(state.topTracks),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());

  },
),
    );
  }

 Widget _track(List<Track> topTracks) {
      String tracks = "";

      for(var track in topTracks){
        if(topTracks.indexOf(track) != topTracks.length-1){
          tracks += track.name +" ~ ";
        }else{
          tracks += track.name;
        }
      }

      return Text(tracks,style: const TextStyle(fontWeight: FontWeight.bold,height: 2),);
 }
}

