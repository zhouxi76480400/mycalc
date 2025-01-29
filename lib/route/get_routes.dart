import 'package:flutter/cupertino.dart';
import 'package:mycalc/home/home_page.dart';
import 'package:mycalc/task/add_task_page.dart';

class GetRoutes {
  static const String home = "/";

  static const String addTask = "/add_task";

  static Map<String, WidgetBuilder> routes = {
    home: (_) => HomePage(),
    addTask: (_) => AddTaskPage(),
  };

  static Route<dynamic>? myOnGenerateRoute(RouteSettings settings) {
    print("myOnGenerateRoute: ${settings.name}");
    return CupertinoPageRoute(builder: GetRoutes.routes[settings.name]!);
  }
}
