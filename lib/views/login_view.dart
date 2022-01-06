import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:line_icons/line_icons.dart';
import 'package:wigi/blocs/auth/auth_bloc.dart';
import 'package:wigi/views/home_view.dart';
import 'package:wigi/views/register_view.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> loadingKey =  GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formkey =  GlobalKey<FormState>();

  bool showPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body:  BlocListener<AuthBloc, AuthState>(
         listener: (context, state) {
           if(state is LoggingState){
               showDialog(context: context, builder: (context) => AlertDialog(key: loadingKey,backgroundColor: Colors.white12,content: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: const [CircularProgressIndicator(),Text('Please wait...',style: TextStyle(fontWeight: FontWeight.bold),)],),),);
           }
           if(state is LoginError){
             Navigator.pop(loadingKey.currentContext!);
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error),duration: const Duration(seconds: 3),backgroundColor: Colors.redAccent.shade200,));
           }
           if(state is LoggedState){
             Navigator.pop(loadingKey.currentContext!);
             Navigator.pushAndRemoveUntil(context, PageRouteBuilder(transitionDuration: const Duration(milliseconds: 500),pageBuilder: (context, animation, secondaryAnimation) => const Home(),), (route) => false);
           }
         },
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.stretch,
           children: [
             Flexible(flex: 1,child: ClipRRect(
               borderRadius: const BorderRadius.only(bottomLeft: Radius.elliptical(200,80),bottomRight: Radius.elliptical(200,80)),
               child: Container(
               decoration: const BoxDecoration(
                 gradient: LinearGradient(colors: [Color(0xffae1b83),Color(0xff0579b2)])
               )
               ,child: Hero(tag: 'logo',child: Image.asset('assets/wigi.png',color: Colors.white,))),
             )),
             Expanded(flex: 2,child: Padding(
               padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 20),
               child: SingleChildScrollView(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text('Login',style: TextStyle(fontSize: 25.sp,fontWeight: FontWeight.bold),),
                     Form(
                       key: _formkey,
                       child: Column(
                         children: [
                           Padding(
                             padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                             child: TextFormField(
                               style: TextStyle(color: const Color(0xFF000000)),
                               cursorColor: Color(0xFF9b9b9b),
                               keyboardType: TextInputType.text,
                               autovalidateMode: AutovalidateMode.onUserInteraction,
                               validator: (value){
                                 bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!);
                                 if(!emailValid){
                                   return 'Verifique su email';
                                 }
                                 return null;
                               },
                               decoration: InputDecoration(
                                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                                 prefixIcon: const Icon(
                                   Icons.email,
                                   color: Colors.grey,
                                 ),
                                 hintText: "Email",
                                 hintStyle: TextStyle(
                                     color: Color(0xFF9b9b9b),
                                     fontSize: 15.sp,
                                     fontWeight: FontWeight.normal),
                               ),
                               controller: _emailController,
                             ),
                           ),
                           Padding(
                             padding: const EdgeInsets.symmetric(horizontal: 10),
                             child: TextFormField(
                               style: TextStyle(color: Color(0xFF000000)),
                               cursorColor: Color(0xFF9b9b9b),
                               keyboardType: TextInputType.text,
                               obscureText: showPassword,
                               autovalidateMode: AutovalidateMode.onUserInteraction,
                               validator: (value){
                                 if(value!.length == 0){
                                   return 'Este campo no debe estar vacío';
                                 }
                                 return null;
                               },
                               decoration: InputDecoration(
                                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                                 prefixIcon: const Icon(
                                   Icons.vpn_key,
                                   color: Colors.grey,
                                 ),
                                 suffixIcon: GestureDetector(onTap: (){
                                   setState(() {
                                     showPassword = !showPassword;
                                   });
                                 },child: Icon(showPassword ? Icons.remove_red_eye_outlined : Icons.remove_red_eye)),
                                 hintText: "Password",
                                 hintStyle: TextStyle(
                                     color: Color(0xFF9b9b9b),
                                     fontSize: 15.sp,
                                     fontWeight: FontWeight.normal),
                               ),
                               controller: _passwordController,

                             ),
                           ),
                           Padding(
                             padding: const EdgeInsets.all(30.0),
                             child: GestureDetector(
                               onTap: (){
                                 if(_formkey.currentState!.validate()){
                                   BlocProvider.of<AuthBloc>(context).add(LoginWithCredentials(_emailController.text, _passwordController.text));
                                 }
                               },
                               child: Container(
                                 decoration: BoxDecoration(
                                     gradient: const LinearGradient(colors: [Color(0xffae1b83),Color(0xff0579b2)]),
                                   borderRadius: BorderRadius.circular(15)
                                 ),
                                 child: Padding(
                                   padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 50),
                                   child: Text(
                                     'Login',
                                     textDirection: TextDirection.ltr,
                                     style: TextStyle(
                                       color: Colors.white,
                                       fontSize: 18.0.sp,
                                       decoration: TextDecoration.none,
                                       fontWeight: FontWeight.normal,
                                     ),
                                   ),
                                 ),
                               ),
                             ),
                             ),
                           const Text('o'),
                           const SizedBox(height: 20,),
                           GestureDetector(
                             onTap: () async{
                               BlocProvider.of<AuthBloc>(context).add(LoginWithGoogle());
                             },
                             child: Container(
                               decoration: BoxDecoration(
                                   color: Colors.red,
                                   borderRadius: BorderRadius.circular(15)
                               ),
                               child: Padding(
                                 padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 50),
                                 child: Row(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children:const [
                                     Icon(LineIcons.googlePlusG,color: Colors.white,),
                                     Text(
                                       'Sigin with Google',
                                       textDirection: TextDirection.ltr,
                                       style: TextStyle(
                                         color: Colors.white,
                                         decoration: TextDecoration.none,
                                         fontWeight: FontWeight.normal,
                                       ),
                                     ),
                                   ],
                                 )
                               ),
                             ),
                           ),
                           const SizedBox(height: 20,),
                           GestureDetector(
                             onTap: () async{
                               BlocProvider.of<AuthBloc>(context).add(LoginWithFacebook());
                             },
                             child: Container(
                               decoration: BoxDecoration(
                                   color: Colors.blue,
                                   borderRadius: BorderRadius.circular(15)
                               ),
                               child: Padding(
                                   padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 50),
                                   child: Row(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     children:const [
                                        Icon(LineIcons.facebookF,color: Colors.white,),
                                       Text(
                                         'Sigin with Facebook',
                                         textDirection: TextDirection.ltr,
                                         style: TextStyle(
                                           color: Colors.white,
                                           decoration: TextDecoration.none,
                                           fontWeight: FontWeight.normal,
                                         ),
                                       ),
                                     ],
                                   )
                               ),
                             ),
                           ),
                           const SizedBox(height: 20,),

                           GestureDetector(onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                             return  Register();
                            },));
                           },child: const Text(r"Don't have an account? Register here")),

                         ],
                       ),
                     )
                   ],
                 ),
               ),
             ))
           ],
         ),
       ),
    );
  }
}
