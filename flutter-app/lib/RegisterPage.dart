import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/LoginPage.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? errorText;
  bool userCreated = false;

  Future<void> register() async {
    String name = nameController.text.toString();
    String email = emailController.text.toString();
    String password = passwordController.text.toString();

    var url = Uri.parse('https://yordi.terrabyteco.com/api/register');
    var response = await http.post(url, body: 
    {
      "name": name,
      "email": email,
      "password": password
    }
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      if (jsonResponse['message'] == 'success') {
        Fluttertoast.showToast(
          msg: "Usuario registrado correctamente",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        
        // ignore: use_build_context_synchronously
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => const LoginPage()
          ),
        );
      } else if (jsonResponse == null) {
        _setErrorText('El formato de tus datos no es correcto. Intentalo denuevo.');
      }
    } else {

      Fluttertoast.showToast(
        msg: "Rellena todos los campos con el formato solicitado",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      throw Exception('Fallo al crear cuenta. Intentelo mas tarde.');
      
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

    return Scaffold(

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

              Image.asset(
                'assets/logotipo.png',
                scale: 10,
              ),

              const SizedBox(height: 25,),

              const Row(

                children: [
                  Icon( Icons.app_registration ),
                  Text(
                    ' Creación de cuenta',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                    )
                  ),
                ]
              ),

              const SizedBox(height: 30,),

              Text(
                'Ingresa tu nombre, correo y contraseña para crear una cuenta StoryBranch.',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor, 
                )
              ),

              const SizedBox(height: 35,),

              TextField(
                controller: nameController,
                cursorColor: Theme.of(context).secondaryHeaderColor,
                cursorWidth: 1,
                decoration: InputDecoration(
                  filled: true, 
                  fillColor: Theme.of(context).colorScheme.background,
                        
                  labelText: 'Nombre',
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
                controller: emailController,
                cursorColor: Theme.of(context).secondaryHeaderColor,
                cursorWidth: 1,
                decoration: InputDecoration(
                  filled: true, 
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
                  filled: true, 
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
            
            const SizedBox(height: 50,),

            Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => const LoginPage()
                    ),
                  );
                },
                      
                child: Text(
                  'Volver',
                  style: TextStyle(color: Theme.of(context).secondaryHeaderColor,)
                  ),
              ),

              ElevatedButton(
                onPressed: register,

              child: const Text(
                'Crear cuenta',
                style: TextStyle(
                  fontWeight: FontWeight.w600
                )
               ),

              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).secondaryHeaderColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(150, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
                  ],
                ),
            ],
          )
       )
      ],
    ),
    );
  }
}