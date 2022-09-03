import 'dart:ui';
import 'dart:math' as math;

Color randomColor(){
  return Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(0.3);
}
String formatDuration(Duration d) {
  if (d == null) return "--:--";
  int minute = d.inMinutes;
  int second = (d.inSeconds > 60) ? (d.inSeconds % 60) : d.inSeconds;
  String format = "${(minute < 10) ? "0$minute" : "$minute"}:${(second < 10) ? "0$second" : "$second"}";
  return format;
}
