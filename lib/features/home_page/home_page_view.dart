import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:to_do_list/features/home_page/home_page_controller.dart';

class HomePageView extends GetView<HomePageController>
{

  Widget TaskView(String title, String startDate,String endDate, String information)
  {
    return Card();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("To DO",style: TextStyle(color: Colors.white, fontWeight : FontWeight.bold,fontSize: 28, fontStyle: FontStyle.italic),), centerTitle: true,backgroundColor: Colors.blueAccent),
      body: Stack(children: [Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
      ),Column(

      )]),

    );
  }

}