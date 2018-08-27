class Utils {
  static bool isEqual(DateTime dt1, DateTime dt2){
    return dt1.year == dt2.year && dt1.month == dt2.month && dt1.day == dt2.day;
  }
}