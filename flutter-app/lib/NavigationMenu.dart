import 'package:flutter/material.dart';
import 'package:project/CreatePage.dart';
import 'package:project/SearchPage.dart';
import 'package:project/MyHomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project/CustomAppBar.dart';
import 'package:project/MyProfilePage.dart';
import 'package:project/LoginPage.dart';
import 'package:project/SavedsPage.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  _NavigationMenuState createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _currentIndex = 0;
  late int id = 0;
  String name = "";
  String email = "";
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    getCred();
  }

  void getCred() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState( () {
      name = prefs.getString('login_name')!;
      id = prefs.getInt('login_id')!;
      email = prefs.getString('login_email')!;
    });
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final double currentWidth = MediaQuery.of(context).size.width;
    final double currentHeight = MediaQuery.of(context).size.height;

    final List<Widget> _screens = [
      MyHomePage(),
      CreatePage(id: id),
      SearchPage(),
    ];

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex == 0) {
          return true;
        } else {
          setState(() {
            _currentIndex = 0;
          });
          return false;
        }
      },

      child: Scaffold(

        appBar: CustomAppBar(),

        drawer: Container(
          width: currentWidth * 0.75,
          padding: const EdgeInsets.only(top: 75),
          color: Theme.of(context).colorScheme.background,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 20, right: 25),
                
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    Text(
                      'Hola',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: currentWidth * 0.070,
                        fontWeight: FontWeight.w300,
                        color: Theme.of(context).colorScheme.tertiary
                      ),
                    ),

                    Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: currentWidth * 0.060,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    Text(
                      'Bienvenido a StoryBranch',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: currentWidth * 0.03,
                        color: Theme.of(context).colorScheme.tertiary
                      ),
                    ),
                    const SizedBox(height: 75,),
                    
                    Text(
                      'Mi cuenta',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: currentWidth * 0.03,
                        fontWeight: FontWeight.w200,
                        color: Theme.of(context).colorScheme.tertiary
                      ),
                    ),
                  ]
                ),
              ),
              const SizedBox(height: 5,),
              PreferredSize(
                preferredSize: const Size.fromHeight(1.0),
                child: Container(
                  color: Theme.of(context).colorScheme.primary,
                  height: 1,
                ),
              ),

              const SizedBox(height: 10,),

              ListTile(
                leading: const Icon(Icons.person_outline_rounded),
                title: const Text('Perfil', style: TextStyle(fontWeight: FontWeight.w900)),
                onTap: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => MyProfilePage(id: id)
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.bookmark_border_rounded),
                title: const Text('Historias guardadas', style: TextStyle(fontWeight: FontWeight.w900)),
                onTap: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => SavedsPage(id: id)
                    ),
                  ); 
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout_rounded),
                title: const Text('Cerrar sesión', style: TextStyle(fontWeight: FontWeight.w900)),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Cerrar sesión", style: TextStyle(fontWeight: FontWeight.w500)),
                        content: Text('¿Estás seguro de querer cerrar sesión?', style: TextStyle(fontWeight: FontWeight.w300, color: Theme.of(context).colorScheme.tertiary)),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("No", style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
                          ),
                          TextButton(
                            onPressed: () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                                setState(() {
                                  prefs.setBool('isAuth', false);
                                }
                              );

                              Navigator.push(
                                context, 
                                MaterialPageRoute(builder: (context) => const LoginPage()),
                              );
                            },
                            child: Text("Sí", style: TextStyle(color: Theme.of(context).secondaryHeaderColor)),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),

              Container(
                margin: EdgeInsets.only(top: currentHeight * 0.325, left: 25, right: 25, bottom: 25),

                child: Column(

                  children: [
                    Row(
                      children: [
                        Icon(Icons.sunny, size: currentWidth * 0.04),
                        const SizedBox(width: 10),
                        Text('Tema visual', style: TextStyle(fontSize: currentWidth * 0.035, fontWeight: FontWeight.w900)),
                      ] 
                    ),
                    const SizedBox(height: 10,),
                    Text(
                      'El tema visual cambia automaticamente a oscuro o claro dependiendo del tema que este usando en su celular.',
                      style: TextStyle(
                        fontSize: currentWidth * 0.03,
                        color: Theme.of(context).colorScheme.tertiary
                      ),
                    ),
                  ]
                ),
              )
            ],
          ),
        ),

        body: _screens[_currentIndex],

        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 1.0,
              ),
            ),
          ),

          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Theme.of(context).colorScheme.background,
            selectedItemColor: Theme.of(context).cardColor,
            unselectedItemColor: Theme.of(context).colorScheme.tertiary,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.home_rounded),
                icon: Icon(Icons.home_outlined),
                label: 'Inicio',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.add_to_photos),
                icon: Icon(Icons.add_to_photos_outlined),
                label: 'Crear',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.search_rounded),
                icon: Icon(Icons.search),
                label: 'Buscar',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
