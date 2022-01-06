import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wigi/blocs/playlist/playlist_bloc.dart';
import 'package:wigi/models/category_model.dart';
import 'package:wigi/utilities/widgets/playlists_list.dart';

class Playlists extends StatelessWidget {
  final Category category;
  final String country;
  const Playlists(this.category, this.country, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlaylistBloc(),
      child: PlaylistPage(category,country),
    );
  }
}

class PlaylistPage extends StatefulWidget {
  const PlaylistPage(this.category, this.country, {Key? key}) : super(key: key);
  final Category category;
  final String country;


  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async{
    BlocProvider.of<PlaylistBloc>(context).add(LoadPlaylistEvent(widget.category.id, widget.country));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PlaylistBloc, PlaylistState>(
  builder: (context, state) {
    return CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            snap: false,
            floating: false,
            backgroundColor: Colors.black54,
            expandedHeight: 275.0,
            flexibleSpace:  FlexibleSpaceBar(
             title: Text(widget.category.name),
              background: Hero(
                  tag: widget.category.icons.first.url,
                  child: CachedNetworkImage(imageUrl: widget.category.icons.first.url,fit: BoxFit.cover,)),
            ),
          ),
          if(state is PlaylistLoaded)...[
            PlayListsList(state.playlists)
          ]else...[
            const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator())
            ),

          ]

        ],
      );
  },
),
    );
  }
}
