import 'package:get/get.dart';
import 'package:to_do_list/features/home_page/home_page_controller.dart';

class HomePageBindings extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>HomePageController());
  }

}