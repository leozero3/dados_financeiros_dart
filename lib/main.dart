import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

main() {
  menu();
}

void menu() {
  print('############ Inicio #############');
  print('\nSelecione uma das opções abaixo');
  print('1 - Ver a cotaçãp de hoje');

  String option = stdin.readLineSync();

  switch (int.parse(option)) {
    case 1:
      today();
      break;
    default:
      print('\n\nOps, opção invalida. Selecione uma opção válida!!\n\n');
      menu();
      break;
  }
}

today() async {
  var data = await getData();
  print('\n\n################### HG Brasil - Contação ####################');
  print('${data['date']} => ${data['data']}');
}

Future getData() async {
  String url = 'https://api.hgbrasil.com/finance?key=76ef6611';
  http.Response response = await http.get(url);

  if (response.statusCode == 200) {
    var data = json.decode(response.body)['results']['currencies'];
    var usd = data['USD'];
    var eur = data['EUR'];
    var gbp = data['GBP'];
    var ars = data['ARS'];
    var btc = data['BTC'];

    Map formatedMap = Map();
    formatedMap['date'] = now();
    formatedMap['data'] =
        '${usd['name']}: ${usd['buy']} | ${eur['name']}: ${eur['buy']} | ${gbp['name']}: ${gbp['buy']} | ${ars['name']}: ${ars['buy']} |${btc['name']}: ${btc['buy']}';
    return formatedMap;
  } else
    throw ('Falhou');
}

String now() {
  var now = DateTime.now();
  return '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year.toString()}';
}