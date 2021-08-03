import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class SessionManagement {
  static const String APP_KEY = "todo_app";
  static const String IS_LOGIN_KEY = "login_key";
  static const String WELCOME_KEY = "onBoarding_key";
  static const String IS_Guest = "guest_key";
  static const String NAME_KEY = "name_key";
  static const String TOKEN_KEY = "token_key";
  static const String IMAGE_KEY = "image_key";
  static const String HAS_CACHED_IMAGE = "cached_image";
  static const String LAST_CHANGE_DATE = "last_change_date";

  static Box<dynamic>? box;

  static Future<Box> get _instance async => box ??= await Hive.openBox(APP_KEY);

  static Future<Box?> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    box = await _instance;
    return box;
  }

  static bool isLoggedIn() => box!.get(IS_LOGIN_KEY, defaultValue: false);

  static bool sawOnBoarding() => box!.get(WELCOME_KEY, defaultValue: false);

  static bool isGuest() => box!.get(IS_Guest, defaultValue: false);

  static String getName() => box!.get(NAME_KEY);

  static String getToken() => box!.get(TOKEN_KEY);

  static File getImage() => box!.get(IMAGE_KEY);

  static bool hasCachedImage() =>
      box!.get(HAS_CACHED_IMAGE, defaultValue: false);

  static String getLastChangeDate() => box!.get(LAST_CHANGE_DATE);

  static void saveLastChangeDate(String date) =>
      box!.put(LAST_CHANGE_DATE, date);

  static void onSeenOnBoarding() => box!.put(WELCOME_KEY, true);

  static void cacheImage(File img) {
    box!.put(HAS_CACHED_IMAGE, true);
    box!.put(IMAGE_KEY, img);
  }

  static void createLoggedInSession(String name, String token) {
    box!.put(NAME_KEY, name);
    box!.put(TOKEN_KEY, token);
    box!.put(IS_LOGIN_KEY, true);
    box!.put(IS_Guest, false);
  }

  static void createGuestSession() {
    box!.put(NAME_KEY, "Guest");
    box!.put(IS_LOGIN_KEY, false);
    box!.put(IS_Guest, true);
  }
}