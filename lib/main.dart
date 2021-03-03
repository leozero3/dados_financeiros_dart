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
  print('2 - Registrar a cotaçãp de hoje');
  print('3 - Ver cotações registradas');

  String option = stdin.readLineSync();

  switch (int.parse(option)) {
    case 1:
      today();
      break;
    case 2:
      registerData();
      break;
    case 3:
      listData();
      break;
    default:
      print('\n\nOps, opção invalida. Selecione uma opção válida!!\n\n');
      menu();
      break;
  }
}

Future registerData() async {
  var hgData = await getData();
  dynamic fileData = readFile();

  fileData = (fileData != null && fileData.length > 0
      ? json.decode(fileData)
      : List());

  bool exist = false;
  fileData.forEach((data) {
    if (data['date'] == now()) exist = true;
  });
  if (!exist) {
    fileData.add({'date': now(), 'data': '${hgData['data']}'});

    Directory dir = Directory.current;
    File file = File(dir.path + '/meu_arquivo.txt');
    RandomAccessFile raf = file.openSync(mode: FileMode.write);

    raf.writeStringSync(json.encode(fileData));
    raf.flushSync();
    await raf.close();

    print('dados salvos *******************');
  }
  else {
    print(' \n\n\ Registro Não adicionado');
  }
}

void listData() {
  dynamic fileData = readFile();

  fileData = (fileData != null && fileData.length > 0 ? json.decode(fileData) : List());

  print('\n\n######################### Listagem das cotaçoes #########################');
  
  fileData.forEach((data){
    print('${data['date']} => ${data['data']}');
  });
}

String readFile() {
  Directory dir = Directory.current;
  File file = File(dir.path + '/meu_arquivo.txt');

  if(!file.existsSync()){
    print('Arquivo não encontrado!');
    return null;
  }
  return file.readAsStringSync();
}

void today() async {
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
  } else {
    throw ('Falhou');
  }
}

String now() {
  var now = DateTime.now();
  return '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year.toString()}';
}
