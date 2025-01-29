import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:mycalc/route/get_routes.dart';
import 'package:mycalc/service/Services.dart';

Future<void> main() async {
  debugPaintSizeEnabled = false;
  await Services.initServices();
  runApp(GetMaterialApp(
    title: "MyTasks",
    debugShowCheckedModeBanner: false,
    initialRoute: GetRoutes.home,
    routes: GetRoutes.routes,
    onGenerateRoute: (RouteSettings settings) {
      return GetRoutes.myOnGenerateRoute(settings);
    },
  ));
}
