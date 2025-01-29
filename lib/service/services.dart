import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'd_b_service.dart';

class Services {
  static Future<void> initServices() async {
    if (kDebugMode) {
      print("starting services");
    }
    await Get.putAsync<DBService>(() async {
      print("starting services return");
      return DBService().init();
    }, permanent: true);
    if (kDebugMode) {
      print("services ready");
    }
  }
}
