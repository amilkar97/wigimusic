

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wigi/blocs/register_bloc.dart';

class Register extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterBloc(),
      child: const RegisterPage(),
    );
  }

}

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool showPassword = true;
  bool showComfirmPassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: BlocListener<RegisterBloc,RegisterState>(
              listener: (context, RegisterState state) {
                if(state is RegisterIsLoading){
                  showDialog(context: context, builder: (context) => AlertDialog(backgroundColor: Colors.white12,content: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [CircularProgressIndicator(),Text('Please wait...',style: TextStyle(fontWeight: FontWeight.bold),)],),),);
                }
                if(state is RegisterIsDone){
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usuario creado con exito, puedes iniciar sesion'),duration: Duration(seconds: 3),backgroundColor: Colors.green,));
                }
                if(state is RegisterError){
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error),duration: const Duration(seconds: 3),backgroundColor: Colors.redAccent.shade200,));
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding:  EdgeInsets.only(left: 10),
                    child:  Text('Registrarse',style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.bold),),
                  ),
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
                        hintText: "Correo",
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
                        hintText: "Contraseña",
                        hintStyle: TextStyle(
                            color: Color(0xFF9b9b9b),
                            fontSize: 15.sp,
                            fontWeight: FontWeight.normal),
                      ),
                      controller: _passwordController,

                    ),
                  ),
                  const SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      style: TextStyle(color: Color(0xFF000000)),
                      cursorColor: Color(0xFF9b9b9b),
                      keyboardType: TextInputType.text,
                      obscureText: showComfirmPassword,
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
                            showComfirmPassword = !showComfirmPassword;
                          });
                        },child: Icon(showComfirmPassword ? Icons.remove_red_eye_outlined : Icons.remove_red_eye)),
                        hintText: "Confirmar Contraseña",
                        hintStyle: TextStyle(
                            color: Color(0xFF9b9b9b),
                            fontSize: 15.sp,
                            fontWeight: FontWeight.normal),
                      ),
                      controller: _confirmPasswordController,

                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: GestureDetector(
                      onTap: () async{
                       //BlocProvider.of<RegisterBloc>(context).add(doRegisterEvent(_emailController.text,_passwordController.text));
                        if(_formKey.currentState!.validate()){
                          if(_confirmPasswordController.text != _passwordController.text){
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Las contraseñas no coinciden')));
                          }else{
                            BlocProvider.of<RegisterBloc>(context).add(doRegisterEvent(_emailController.text,_passwordController.text));
                          }
                        }

                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xffae1b83),Color(0xff0579b2)]),
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 50),
                          child: Text(
                            'Registrarse',
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
