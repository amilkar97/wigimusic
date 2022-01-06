
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:random_color/random_color.dart';
import 'package:wigi/blocs/track/track_bloc.dart';
import 'package:wigi/models/album_model.dart';
import 'package:wigi/models/track_model.dart';
import 'package:wigi/views/artist_view.dart';
import 'dart:math';
class TheTrack extends StatelessWidget {
  final Track track;
  const TheTrack(this.track,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => TrackBloc(),child: TrackPage(track),);
  }
}

class TrackPage extends StatefulWidget {

  final Track track;
  const TrackPage(this.track, {Key? key}) : super(key: key);

  @override
  _TrackPageState createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(seconds: 10));
  late AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
    _controller.repeat();

    _play();

  }
  _play() async{


  }



  @override
  void dispose() {
  _controller.dispose();
  _animationController.dispose();
  super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Icon(LineIcons.stop),
            Icon(LineIcons.backward),

            AnimatedIcon(icon: AnimatedIcons.play_pause,color: Colors.white,progress: _animationController,size: 40,),
            Icon(LineIcons.forward),
            Text(((widget.track.duration_ms/1000)/60).toStringAsFixed(0)+":"+((widget.track.duration_ms%1000)%60).toStringAsFixed(0),overflow: TextOverflow.ellipsis,maxLines: 2,),

          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: 275.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.track.name),
              background: Hero(
                  tag: widget.track.id,
                  child: CachedNetworkImage(
                    imageUrl: widget.track.album.images.first.url,
                    fit: BoxFit.cover,
                  )),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: AnimatedBuilder(animation: _controller,builder: (context, child) {
                    return Transform.rotate(angle: _controller.value *2 *pi,child: child);
                  },child: Image.asset('assets/lp.png',height: 230,),),

                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Album',style: TextStyle(fontSize: 20.sp),),
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(child: CachedNetworkImage(imageUrl: widget.track.album.images.first.url,height: 100,width: 120,)),
                        _getArtistNames(widget.track.artists),
                      ],
                    ),
                    const SizedBox(height: 20,),

                    Text('Artists',style: TextStyle(fontSize: 20.sp),),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                child: ListView.builder(
                  itemCount: widget.track.artists.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                   return  GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ArtistDetails(widget.track.artists[index].id),)),
                       child: ListTile(leading: CircleAvatar(backgroundColor: RandomColor().randomColor(),child: Text(widget.track.artists[index].name.substring(0,1)),),title: Text(widget.track.artists[index].name),));
                },),
              ),
            ),
          ),
        ],
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

    return Expanded(child: Text(names,overflow: TextOverflow.visible,maxLines: 2,));
  }
}

