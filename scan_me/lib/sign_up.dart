import 'package:firebase_auth/firebase_auth.dart';
import 'package:scan_me/home_page_signed_in.dart';
import 'package:scan_me/landing_page.dart';

import 'home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'sign_in.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Future SignUp() async {
  //   if(_passwordController.text == _confirmPasswordController.text){
  //     await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailController.text.trim(), password: _passwordController.text.trim());
  //     Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MainPage()));
  //   }
    // print(_emailController.text);
    // print("aknf");
    Future<String?> SignUp({
      required String email,
      required String password,
    }) async {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        return 'Success';
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          return 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          return 'The account already exists for that email.';
        }else if(_passwordController!=_confirmPasswordController){
          return 'Password and Confirm password should match';
        }else {
          return e.message;
        }
      } catch (e) {
        return e.toString();
      }
    }






  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.white,
        leading:
        IconButton(
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const MainPage())),
            icon:const Icon(Icons.arrow_back_ios,size: 20,color: Colors.black,)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Text ("Sign Up", style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),),
                        SizedBox(height: 15,),
                        Text("Create an Account, Its free!! ",style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),),
                        SizedBox(height: 20,)
                      ],
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 5)),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40
                      ),
                      child: Column(
                        children: [
                          makeInput(key:"signup_username",label: "Username",controller: _usernameController),
                          makeInput(key:"signup_email",label: "Email",controller: _emailController),
                          makeInput(key:"signup_password",label: "Password",obsureText: true,controller: _passwordController),
                          makeInput(key:"signup_cPassword",label: "Confirm Pasword",obsureText: true,controller: _confirmPasswordController)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40),
                      child: MaterialButton(
                          key: Key("signup_submit"),
                        minWidth: double.infinity,
                        height:45,
                        color: Colors.deepPurple,
                        child: const Text(
                          "SIGN UP",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Color.fromRGBO(246, 246, 246, 1), ),
                        ),
                          // onPressed: null
                      //   onPressed: () => Navigator.of(context)
                      //       .push(MaterialPageRoute(builder: (_) => const SignIn())),

                        onPressed: () async {
                          final message = await SignUp(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );

                          if (message!.contains('Success')) {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) => const HomePage()));
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(message),
                            ),
                          );
                        },


                      ),
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget> [
                        const Text("Already have an account? "),

                        MaterialButton(
                          child: const Text(
                            "SIGN IN",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18
                            ),
                          ),
                          onPressed: () => Navigator.of(context)
                              .push(MaterialPageRoute(builder: (_) => const SignIn())),
                        ),
                      ],
                    )
                  ],

                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


Widget makeInput({key,label,obsureText = false,controller}){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label,style:const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.black87
      ),),
      const SizedBox(height: 5,),
      TextField(
        key: Key(key),
        controller: controller,
        obscureText: obsureText,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
            ),
          ),
          border: OutlineInputBorder(
          ),
        ),
      ),
      const SizedBox(height: 30,)

    ],
  );
}