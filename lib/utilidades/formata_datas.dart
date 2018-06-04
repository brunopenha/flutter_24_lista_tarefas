import 'package:intl/intl.dart';

String formataData(){
  var hoje = DateTime.now();
  var formatador = new DateFormat("EEE, MMM d, ''yy");
  String formatado = formatador.format(hoje);

  return formatado;
}