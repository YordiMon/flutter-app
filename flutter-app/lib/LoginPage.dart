import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project/NavigationMenu.dart';
import 'package:project/RegisterPage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late bool? isAuth = false;
  bool userCreated = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? errorText;

  Future<void> login() async {
    String email = emailController.text.toString();
    String password = passwordController.text.toString();

    var url = Uri.parse('https://yordi.terrabyteco.com/api/login');
    var response = await http.post(url, body: 
    {
      "email": email,
      "password": password
    }
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      if (jsonResponse['message'] == 'success') {
        final body = jsonDecode(response.body);
        pageRoute(
          body['profile']['id'],
          body['access_token'],
          body['profile']['name'],
          body['profile']['email'],
        );
      } else {
        _setErrorText('Correo o contraseña incorrecta. Intentelo denuevo.');
      }
    } else {
      throw Exception('Fallo al iniciar sesión. Intentelo mas tarde.');
    }
  }

  void pageRoute(int id, String token, name, email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('login_id', id);
    await prefs.setString('login_token', token);
    await prefs.setString('login_name', name);
    await prefs.setString('login_email', email);

    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => const NavigationMenu()
      ),
    );
  }

 @override
  void initState() {
    super.initState();
    getAuth();
  }

  void getAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isAuth = prefs.getBool('isAuth');
    });

    if (isAuth == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NavigationMenu()),
      );
    }
  }

  void _setErrorText(String message) {
    setState(() {
      errorText = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;

    // ignore: deprecated_member_use
    return WillPopScope(
    onWillPop: () async {
      exit(0);
    },
    child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.only(
                top: currentHeight * 0.15,
                bottom  : currentHeight * 0.15,
                left: 25,
                right: 25,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/logotipo.png',
                    scale: 10,
                  ),
                  const SizedBox(height: 25,),
                  const Row(
                    children: [
                      Icon(Icons.login),
                      Text(
                        ' Inicio de sesión',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold
                        )
                      ),
                    ]
                  ),
                  const SizedBox(height: 30,),
                  Text(
                    'Escribe los datos de tu cuenta StoryBranch para ingresar a la página principal.',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor, 
                    )
                  ),
                  const SizedBox(height: 35,),
                  if (errorText != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      child: Text(
                        errorText!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  TextField(
                    controller: emailController,
                    cursorColor: Theme.of(context).secondaryHeaderColor,
                    cursorWidth: 1,
                    decoration: InputDecoration(
                      filled: true, // Activa el fondo relleno
                      fillColor: Theme.of(context).colorScheme.background,
                      labelText: 'Correo',
                      floatingLabelStyle:  TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(
                          color:Theme.of(context).colorScheme.tertiary,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(
                          color: Theme.of(context).secondaryHeaderColor,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25,),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    cursorColor: Theme.of(context).secondaryHeaderColor,
                    cursorWidth: 1,
                    decoration: InputDecoration(
                      filled: true, // Activa el fondo relleno
                      fillColor: Theme.of(context).colorScheme.background, 
                      labelText: 'Contraseña',
                      floatingLabelStyle:  TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(
                          color:Theme.of(context).colorScheme.tertiary,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(
                          color: Theme.of(context).secondaryHeaderColor,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15,),
                  InkWell(
                    onTap: () {},
                    child: Text(
                      '¿Olvidaste tu contraseña?',
                      style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                      )
                    ),
                  ),
                  const SizedBox(height: 50,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) => const RegisterPage()),
                          );
                        },
                        child: Text(
                          'Crear cuenta',
                          style: TextStyle(color: Theme.of(context).secondaryHeaderColor,)
                        ),
                      ),

                      ElevatedButton(
                        onPressed: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                            setState(() {
                              prefs.setBool('isAuth', true);
                            }
                          );
                          
                          login();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).secondaryHeaderColor,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(150, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'Ingresar',
                          style: TextStyle(
                            fontWeight: FontWeight.w600
                          )
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}