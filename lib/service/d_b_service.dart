import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';

import '../model/task_model.dart';

class DBService extends GetxService {
  static const String kCalName = "mycalc";

  // late Box dbBox;

  Future<DBService> init() async {
    if (kDebugMode) {
      print("DBService Hive init");
    }
    WidgetsFlutterBinding.ensureInitialized();
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDirectory.path);
    Hive.registerAdapter(TaskModelAdapter());

    await Hive.openBox<TaskModel>(kCalName);
    if (kDebugMode) {
      // print("DBService Hive ready $dbBox");
    }
    return this;
  }
}
