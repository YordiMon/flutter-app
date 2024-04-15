import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onBoarding_items.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:project/LoginPage.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  @override
  Widget build(BuildContext context) {
    
    final controller = OnBoardingItems();
    final pageController = PageController();
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      bottomSheet: 
      Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        color: Theme.of(context).colorScheme.background,

        child:
        Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: ()=>pageController.previousPage(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut),
              child: Text('Atrás', style: TextStyle(color: Theme.of(context).secondaryHeaderColor),)
            ),

            SmoothPageIndicator(
              controller: pageController,
              count: controller.items.length,
              onDotClicked: (index)=> pageController.animateToPage(index, 
                duration: const Duration(milliseconds: 600), curve: Curves.easeOut),
              effect: WormEffect(
                activeDotColor: Theme.of(context).secondaryHeaderColor,
                dotHeight: 10,
                dotWidth: 20,
                dotColor: Theme.of(context).colorScheme.secondary
              ),
            ),

            TextButton(
              onPressed: ()=>pageController.nextPage(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut),
              child: Text('Siguiente', style: TextStyle(color: Theme.of(context).secondaryHeaderColor),)
            ),
          ]
        ),

        const SizedBox(height: 10,),

        getStarted()
          ]
        ),
          
      ),
      
      body: Container(
        margin: const EdgeInsets.all(35),

        child:       
        PageView.builder(
          itemCount: controller.items.length,
          controller: pageController,
          itemBuilder: (context, index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: 
                    Image.asset(
                      controller.items[index].image,
                      scale: currentWidth * 0.01,
                    ),
                  ),

                  const SizedBox(height: 50,),
                  
                  Text(
                    controller.items[index].title,
                    maxLines: 5,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: currentWidth * 0.065,
                    ),
                  ),

                  const SizedBox(height: 15,),

                  Text(
                    controller.items[index].description,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: currentWidth * 0.04,
                      color: Theme.of(context).colorScheme.tertiary
                    ),
                  ),

                  SizedBox(height: currentHeight * 0.1,)
              ]
            );
          }
        )
      )
    );
  }

  Widget getStarted() {
    return 
    ElevatedButton(
      onPressed: () async {

      final pres = await SharedPreferences.getInstance();
      pres.setBool("onboarding", true);

      if(!mounted)return;
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => const LoginPage()
          ),
        );
      }, 

      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.tertiary,
        side: BorderSide(
          width: 1,
          color: Theme.of(context).colorScheme.secondary,
        ),
        minimumSize: const Size(500, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),

    child: const Text(
      'Iniciar sesión'
      ),
                      
    );
  }
}