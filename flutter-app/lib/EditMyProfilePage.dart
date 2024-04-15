import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/MyProfilePage.dart';
import 'package:project/models/User.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditMyProfilePage extends StatefulWidget {
  const EditMyProfilePage({Key? key, required this.id});

  final int id;

  @override
  State<EditMyProfilePage> createState() => _EditMyProfilePageState();
}

class _EditMyProfilePageState extends State<EditMyProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late Future<User> _futureUser;

  @override
  void initState() {
    super.initState();
    _futureUser = fetchUser();

    nameController = TextEditingController();
    emailController = TextEditingController();
    bioController = TextEditingController();
    passwordController = TextEditingController();
  }

  void setName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('login_name', nameController.text);
  }

  Future<User> fetchUser() async {
    final response = await http.get(Uri.parse('https://yordi.terrabyteco.com/api/user/${widget.id}'));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return User.fromJson(responseData as Map<String, dynamic>);
    } else {
      throw Exception('Fallo al cargar la historia');
    }
  }

  Future<void> update() async {
    String name = nameController.text.toString();
    String email = emailController.text.toString();
    String bio = bioController.text.toString();
    String password = passwordController.text.toString();

    if (name.isEmpty || email.isEmpty || bio.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(
        msg: "¡Rellena todos los campos!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Editar perfil", style: TextStyle(fontWeight: FontWeight.w500)),
          content: Text('¿Estás seguro de querer editar los datos de tu perfil?', style: TextStyle(fontWeight: FontWeight.w300, color: Theme.of(context).colorScheme.tertiary)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("No", style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("Sí", style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
            ),
          ],
        );
      },
    );

    if (confirm) {
      var url = Uri.parse('https://yordi.terrabyteco.com/api/uuser/${widget.id}');
      var response = await http.post(url, body: {
        "id": widget.id.toString(),
        "name": name,
        "email": email,
        "bio": bio,
        "password": password
      });

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        setName();
        if (jsonResponse['response'] == 'Éxito: registro modificado correctamente.') {
          Fluttertoast.showToast(
            msg: "Datos modificados correctamente.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyProfilePage(id: widget.id)),
          );
        } else if (jsonResponse['response'] ==
            'Error: algo salió mal, por favor inténtalo de nuevo.') {
          Fluttertoast.showToast(
            msg: "Algo salió mal, por favor inténtalo de nuevo.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } else {
        throw Exception('Fallo al iniciar sesión. Intentelo mas tarde.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Theme.of(context).colorScheme.primary,
            height: 1,
          ),
        ),
        title: const Text('Editar perfil'),
      ),
      body: FutureBuilder<User>(
        future: _futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            final user = snapshot.data!;
            
            if (nameController.text.isEmpty) nameController.text = user.name;
            if (emailController.text.isEmpty) emailController.text = user.email;
            if (bioController.text.isEmpty) bioController.text = user.bio ?? '';

            return ListView(
              padding: const EdgeInsets.all(20.0),
              children: [
                const SizedBox(height: 50),
                Text(
                  'Asegurate de recordar los datos que vayas a modificar de tu perfil.',
                  style: TextStyle(
                    fontSize: currentWidth * 0.035,
                    color: Theme.of(context).colorScheme.tertiary
                  ),
                ),
                const SizedBox(height: 25,),
                TextField(
                  controller: nameController,
                  cursorColor: Theme.of(context).secondaryHeaderColor,
                  cursorWidth: 1,
                  decoration: InputDecoration(
                    filled: true, // Activa el fondo relleno
                    fillColor: Theme.of(context).colorScheme.background,
                    labelText: 'Nuevo nombre',
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
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  cursorColor: Theme.of(context).secondaryHeaderColor,
                  cursorWidth:
 1,
                  decoration: InputDecoration(
                    filled: true, // Activa el fondo relleno
                    fillColor: Theme.of(context).colorScheme.background,
                    labelText: 'Nuevo correo',
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
                const SizedBox(height: 20),
                TextField(
                  controller: bioController,
                  cursorColor: Theme.of(context).secondaryHeaderColor,
                  cursorWidth: 1,
                  maxLines: 3,
                  decoration: InputDecoration(
                    filled: true, // Activa el fondo relleno
                    fillColor: Theme.of(context).colorScheme.background,
                    labelText: 'Nueva biografía',
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
                const SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  cursorColor: Theme.of(context).secondaryHeaderColor,
                  cursorWidth: 1,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true, // Activa el fondo relleno
                    fillColor: Theme.of(context).colorScheme.background,
                    labelText: 'Nueva contraseña',
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
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: update,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).secondaryHeaderColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(500, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text('Editar perfil'),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
