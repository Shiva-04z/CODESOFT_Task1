import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:to_do_list/features/home_page/home_page_bindings.dart';
import 'package:to_do_list/features/home_page/home_page_view.dart';
import 'package:to_do_list/features/splash_screen/splash_screen_bindings.dart';
import 'package:to_do_list/features/splash_screen/splash_screen_view.dart';
import 'package:to_do_list/navigation/routes_constant.dart';

List<GetPage> getPages= [

  GetPage(name: RoutesConstant.homepage, page: ()=>HomePageView(),binding: HomePageBindings()),
  GetPage(name: RoutesConstant.splashPage, page: ()=>SplashScreenView(),binding: SplashScreenBindings())
];