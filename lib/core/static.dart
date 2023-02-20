// ignore: slash_for_doc_comments

class Member {
  static String token = '';
}

class Cache {
  static Map<String, dynamic> storgeData = new Map<String, dynamic>();
  static Map setData(String key, dynamic data) {
    if (storgeData.containsKey(key)) {
      try {
        // data type map.
        storgeData[key].update(data);
      } catch (e) {
        storgeData[key] = data;
      }
    } else {
      storgeData[key] = data;
    }
    return storgeData[key];
  }

  static Map? getData(String key) {
    if (storgeData.containsKey(key)) {
      return storgeData[key];
    } else {
      return null;
    }
  }
}

/**
 *  set app routes.
 */
class R {
  static const root = "/";
  static const login = "/login";
  static const home = "/home";
  static const data = "/data";
  static const add = "/add";
  static const game = "/game";
  static const painter = "/painter";
  // static const edit = "/edit";
  // static const add = "/delete";
}
