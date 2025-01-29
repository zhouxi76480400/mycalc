import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil {
  static void toast(String title) async {
    var result = await Fluttertoast.showToast(
        msg: title,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        // backgroundColor: Colors.red,
        // textColor: Colors.white,
        fontSize: 16.0);
    print(result);
  }
}
