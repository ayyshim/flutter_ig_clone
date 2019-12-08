class Utility {

  static String clip_fullname({String name}) {
    return name.length < 11 ? name : '${name.substring(0, 11)}...';
  }

}