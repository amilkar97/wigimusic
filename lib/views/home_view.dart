import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:line_icons/line_icons.dart';
import 'package:random_color/random_color.dart';
import 'package:wigi/blocs/auth/auth_bloc.dart';
import 'package:wigi/blocs/home/home_bloc.dart';
import 'package:wigi/models/category_model.dart';
import 'package:wigi/models/album_model.dart';
import 'package:wigi/models/user_google_model.dart';
import 'package:wigi/utilities/widgets/album_carousel.dart';
import 'package:wigi/views/login_view.dart';
import 'package:wigi/views/playlists_view.dart';
import 'package:wigi/views/search_view.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (context) => HomeBloc(),
      ),
      BlocProvider(
        create: (context) => AuthBloc(),
      ),
    ], child: const HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String country = 'CO';

  @override
  void initState() {
    super.initState();
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.getToken().then((String? token) {assert(token != null);});
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
        print('llego');
        if(mounted){
          showDialog(builder: (context) => AlertDialog(
            title: Text(notification!.title.toString(),),
            content: Text(notification.body.toString()),
            actions: [
              ElevatedButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text('Ok'))
            ],
          ), context: (context),);
        }

    });
    _loadData();
  }

  _loadData() {
    BlocProvider.of<HomeBloc>(context).add(LoadHomeEvent());
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: Drawer(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, HomeState state) {
            if (state is HomeLoading) {
              return  const Center(
                child: CircularProgressIndicator(),
              );
            }
            late UserGoogle user;
            if (state is HomeLoaded) {
              user = state.userGoogle;
            }
            if(state is LoadedCategories) user = state.userGoogle;

            return Column(
              children: [
                UserAccountsDrawerHeader(
                  accountName: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name! +
                          " " +
                          user.lastname!),
                      Text("DocumentNumber: " +
                          user.documentNumber!)
                    ],
                  ),
                  accountEmail: Text(user.email!),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.amber,
                    child: Text(
                        user.name!.substring(0, 1).toUpperCase()),
                  ),
                ),
                GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const ListTile(
                      leading: Icon(Icons.home),
                      title: Text('Home'),
                    )),
                GestureDetector(
                    onTap: () => BlocProvider.of<AuthBloc>(context)
                        .add(SignOutEvent()),
                    child: const ListTile(
                      leading: Icon(
                        LineIcons.powerOff,
                        color: Colors.redAccent,
                      ),
                      title: Text('Logout'),
                    )),
              ],
            );
            return const Center(child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, AuthState state) {
          if (state is ClosedSessionState) {
            if(mounted){
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Colors.white12,
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      CircularProgressIndicator(),
                      Text(
                        'Please wait...',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              );
            }

          }
          if (state is ClosedSessionState) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => Login(),
                ),
                (route) => false);
          }
          if (state is SignOutError) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.error.toString()),
              backgroundColor: Colors.redAccent.shade200,
            ));
          }
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              snap: false,
              floating: false,
              title: const Text('WigiMusic'),
              backgroundColor: ThemeData.dark().primaryColor,
              actions: [
                GestureDetector(
                  onTap: ()async{
                    String? pushToken = await FlutterSecureStorage().read(key: 'push_token');
                    print(pushToken);
                    try {
                      await Dio().post('https://fcm.googleapis.com/fcm/send',options: Options(headers: {
                        'Authorization': 'key=AAAAhoon7MU:APA91bHAaXFVR0NfMt0LvpCb05BBT-grGGc3IwTEecdlqnMKvr7jzU6w2o2HsBOh3bit1n79oT8hBASNPojCpTxCC5AxsNC5N9EI0FajDtm9cEOSntuyNlhmDywpxylZEvjm2uZjTVxI ',
                        'Content-Type': 'application/json'
                      }),data: {
                        'to': pushToken,
                        'notification':{
                          'title': 'HOLAA',
                          'body': 'Esto es un mensaje de prueba de firebase messaging',
                        }
                      });
                    } catch (error) {
                      if(error is DioError){
                        print(error.response!.statusCode);
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20,bottom: 10),
                    child: Transform.rotate(angle: -(45/180)*pi,child: Icon(Icons.send)),
                  ),
                ),
                DropdownButton<String>(
                  value: country,
                  elevation: 16,
                  style: const TextStyle(color: Colors.white),
                  dropdownColor: Colors.blueGrey,
                  underline: Container(),
                  onChanged: (String? newValue) {
                    setState(() {
                      country = newValue!;
                    });
                    BlocProvider.of<HomeBloc>(context).add(LoadCategoriesEvent(newValue!));
                  },
                  items: <String>['CO', 'AU'].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        children: [
                          if(value == 'CO')...[
                            Image.asset('assets/colombia.png',width: 40,fit: BoxFit.contain)
                          ]else...[
                            Image.asset('assets/australia.jpg',width: 40,fit: BoxFit.contain)
                          ],
                          const SizedBox(width: 10,),
                          Text(value,style: const TextStyle(color: Colors.white),),
                        ],
                      ),
                    );
                  }).toList(),
                )
              ],
            ),
            SliverPersistentHeader(
              pinned: true,
              floating: false,
              delegate: _delegateSearchBar(),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeInLeft(
                        duration: const Duration(milliseconds: 1000),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text('New Releases',style: TextStyle(color: Colors.white,fontSize: 20.sp)),
                        ),
                      ),
                      BlocBuilder<HomeBloc, HomeState>(
                        builder: (context, HomeState state) {
                          if(state is HomeLoaded){
                            return CarouselAlbum(state.releases);
                          }
                          if(state is LoadedCategories){
                            return CarouselAlbum(state.releases);
                          }
                          return const Center(child: CircularProgressIndicator(),);
                        },
                      ),
                      FadeInLeft(
                        duration: const Duration(milliseconds: 1000),
                        delay: const Duration(milliseconds: 2000),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text('Categories',style: TextStyle(color: Colors.white,fontSize: 20.sp)),
                        ),
                      ),
                      BlocBuilder<HomeBloc, HomeState>(
                        builder: (context, HomeState state) {
                          
                          if(state is HomeLoaded){
                            return  _categoryList(state.categories);
                          }
                          if(state is LoadedCategories){
                            return  _categoryList(state.categories);
                          }
                          return const Center(child: CircularProgressIndicator(),);

                        },
                      )
                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }



  Widget _categoryList(List<Category> categories) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisExtent: 115.w,),
        itemCount: categories.length,
        padding: const EdgeInsets.symmetric(vertical: 10),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
            return GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Playlists(categories[index],country),));
              },
              child: ZoomIn(
                duration: const Duration(milliseconds: 500),
                delay: Duration(milliseconds: 20*index),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: RandomColor().randomColor(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(categories[index].name,style: TextStyle(fontSize: 15.sp),),
                          )),
                          Flexible(
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                    right: -25,
                                    bottom: 15,
                                    width: 75,
                                    height: 75,
                                    child: SlideInRight(
                                      duration: const Duration(milliseconds: 500),
                                      delay: Duration(milliseconds: 200*index),
                                      child: Transform.rotate(
                                        angle: (45/180)*pi,
                                        child: Hero(
                                          tag: categories[index].icons.first.url,
                                          child: CachedNetworkImage(imageUrl: categories[index].icons.first.url,
                                          fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
        },);
  }


}

class _delegateSearchBar extends SliverPersistentHeaderDelegate {

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ZoomIn(
      duration: const Duration(milliseconds: 1000),
      child: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Search(),)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Hero(
            tag: 'searchbar',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                color: overlapsContent ? Colors.black54.withOpacity(0.5) : Colors.white.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: const [
                      Flexible(child: Icon(LineIcons.search)),
                      SizedBox(width: 10,),
                      Expanded(child: Text('Search Something'))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => 80;

  @override
  // TODO: implement minExtent
  double get minExtent => 80;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
   return true;
  }
}

