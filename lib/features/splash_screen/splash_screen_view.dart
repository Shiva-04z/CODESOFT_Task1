import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_list/features/splash_screen/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {


  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.resetAndStartAnimations();
    });

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            AnimatedOpacity(
              opacity: controller.logoOpacity.value,
              duration: const Duration(seconds: 1),
              child: Container(
                height: 150,
                width: 150,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/to_do_list.png"),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // App Name with fade-in animation
            AnimatedOpacity(
              opacity: controller.textOpacity.value,
              duration: const Duration(seconds: 1),
              child: Text(
                'My To-Do List',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}