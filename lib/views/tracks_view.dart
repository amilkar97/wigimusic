import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wigi/blocs/tracks/tracks_bloc.dart';
import 'package:wigi/models/album_model.dart';
import 'package:wigi/models/playlist_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wigi/utilities/widgets/track_list.dart';
import 'package:wigi/views/track_view.dart';

class Tracks extends StatelessWidget {
  final Playlist playlist;
  const Tracks(this.playlist, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TracksBloc(),
      child: TrackPage(playlist),
    );
  }
}

class TrackPage extends StatefulWidget {
  final Playlist playlist;
  const TrackPage(this.playlist, {Key? key}) : super(key: key);

  @override
  _TrackPageState createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<TracksBloc>(context).add(LoadTracksEvent(widget.playlist.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TracksBloc, TracksState>(
        builder: (context, TracksState state) {
          return CustomScrollView(
            slivers: [
                SliverAppBar(
                  pinned: true,
                  snap: false,
                  floating: false,
                  backgroundColor: Colors.black54,
                  expandedHeight: 275.0,
                  title: const Text('Tracks'),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Hero(
                        tag: widget.playlist.images.first.url,
                        child: CachedNetworkImage(
                          imageUrl: widget.playlist.images.first.url,
                          fit: BoxFit.cover,
                        )),
                  ),
                ),
              if (state is TracksLoaded)...[
                  TrackLister(state.tracks)
                ]else ...[
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
