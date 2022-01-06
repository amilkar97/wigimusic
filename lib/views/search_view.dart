
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:wigi/blocs/search/search_bloc.dart';
import 'package:wigi/models/playlist_model.dart';
import 'package:wigi/utilities/widgets/album_carousel.dart';
import 'package:wigi/utilities/widgets/playlists_list.dart';
import 'package:wigi/utilities/widgets/track_list.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wigi/views/tracks_view.dart';
class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => SearchBloc(),child: const _SearchPage(),);
  }
}

class _SearchPage extends StatefulWidget {
  const _SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<_SearchPage> {
  final TextEditingController _searchTextController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchTextController.addListener(() {
      if(_searchTextController.text.isNotEmpty) {
        BlocProvider.of<SearchBloc>(context).add(LoadSearchEvent(_searchTextController.text));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: 10.0,

          ),
          SliverToBoxAdapter(
            child: Hero(
              tag: 'searchbar',
              child: Card(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: TextFormField(
                    autofocus: true,
                    controller: _searchTextController,
                    decoration: const InputDecoration(
                        hintText: 'Search something',
                        border: InputBorder.none,
                        icon: Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Icon(LineIcons.search,
                          ),
                        )),
                  ),
                ),
              ),
            ),
          ),
          BlocBuilder<SearchBloc,SearchState>(builder: (context, state) {
            if(state is SearchLoaded){
              return SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(onTap: (){
                        buildAlbumsBottomSheet(context, state);
                      },child: Text('Ver Albums relacionados',style: TextStyle(fontSize: 15.sp),)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(onTap: (){
                        buildPlaylistsBottomSheetP(context, state);
                      },child: Text('Ver Playlists relacionados',style: TextStyle(fontSize: 15.sp),)),
                    )
                  ],
                ),
              );
            }
            return SliverToBoxAdapter(child: Container());
          },),
          BlocBuilder<SearchBloc,SearchState>(builder: (context, state) {
            if(state is SearchLoaded){
              return TrackLister(state.tracks);
            }
            if(state is SearchLoading){
              return const SliverToBoxAdapter(child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: CircularProgressIndicator(),),
              ));
            }
            return SliverToBoxAdapter(child: Container());
          },)
        ],
      )

    );
  }

  PersistentBottomSheetController<dynamic> buildAlbumsBottomSheet(BuildContext context, SearchLoaded state) {
    return showBottomSheet(context: context, builder: (context) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text('Albums relacionados',style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.bold),),
                              ),
                              CarouselAlbum(state.albums)
                            ],
                          );
                      },);
  }

  PersistentBottomSheetController<dynamic> buildPlaylistsBottomSheetP(BuildContext context, SearchLoaded state) {
    return showBottomSheet(context: context, builder: (context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('Playlists relacionadas',style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.bold),),
                            ),
                            CarouselSlider(items: state.playlists.map((e) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return _carouselPlaylists(context, e);
                                },
                              );
                            }).toList(),  options: CarouselOptions(height: 120.w,autoPlay: true,autoPlayCurve: Curves.fastOutSlowIn),
                            )
                          ],
                        );
                      },);
  }

  Widget _carouselPlaylists(BuildContext context, Playlist e) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: (){
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => Tracks(e),));
        },
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
                                                      child: CachedNetworkImage(imageUrl: e.images.first.url,),
                                                    )
                                                ),
                                              ),
                                              Flexible(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Flexible(child: Text(e.name,overflow: TextOverflow.visible,style: const TextStyle(fontWeight: FontWeight.bold),)),
                                                      const SizedBox(height: 10,),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                      ),
      ),
    );
  }
}

