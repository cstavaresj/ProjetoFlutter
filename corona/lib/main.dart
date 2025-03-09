import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int casos;
  int mortes;
  int recuperados;
  String dataworld;
  bool carregado = false;

  getInfoData() async {
    String url = "https://api.covid19api.com/summary";
    http.Response response;
    response = await http.get(url);
    if (response.statusCode == 200) {
      var decodeJson = jsonDecode(response.body);
      return decodeJson['Countries'];
    }
  }

  getInfoVirus() async {
    String url = "https://api.covid19api.com/summary";
    http.Response response;
    response = await http.get(url);
    if (response.statusCode == 200) {
      var decodeJson = jsonDecode(response.body);
      return decodeJson['Global'];
    }
  }

  @override
  void initState() {
    super.initState();
    getInfoData().then((map2) {
      setState(() {
        dataworld = map2[0]['Date'];
        carregado = true;
      });
    });

    getInfoVirus().then((map) {
      setState(() {
        casos = map['TotalConfirmed'];
        mortes = map['TotalDeaths'];
        recuperados = map['TotalRecovered'];
        carregado = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String infoDaApi = dataworld.toString(); //Informação que chega da API
    List<String> listInfoDaApi = infoDaApi
        .split('T'); //Cria uma lista com os elementos separados por 'T'
    String data =
        listInfoDaApi.first; //A Data é o primeiro elemento da ListInfoDaApi
    List<String> listData = data
        .split('-'); //Cria uma lista com os elementos da Data separados por '-'
    var dia = listData.last; //O Dia é o ultimo elemento da ListData
    var mes = listData[1]; //O Mes é o segundo elemento da ListData [0,1,2]
    var ano = listData.first; //O Ano é o primeiro elemento da ListData
    String horaCompleta = listInfoDaApi
        .last; //A hora completa é o segundo elemento da ListInfoDaApi
    List<String> listHoraCompleta = horaCompleta
        .split('.'); //Cria uma lista separando as informaçoes desnecessárias
    String hora = listHoraCompleta
        .first; //A hora é o primeiro elemento da ListHoraCompleta
    List<String> listHoraDividida =
        hora.split(':'); //Cria uma lista separando hora, minutos e segundos
    int hh = int.parse(listHoraDividida.first) -
        3; //hh são as horas, o primeiro elemento da ListHoraDividida. Foi transformado de texto para inteiro para diminuir as 3h do UTC -3
    var mm = listHoraDividida[
        1]; //mm são os minutos, o segundo elemento da ListHoraDividida
    //FIM DA FORMATAÇÃO DAS DATAS

    //FORMATAÇÃO DOS NUMEROS
    String numeroConfirmados = casos.toString();
    String numeroRecuperados = recuperados.toString();
    String numeroMortes = mortes.toString();

    List<String> numeroConfirmadosCompleto = numeroConfirmados.split('');
    List<String> numeroRecuperadosCompleto = numeroRecuperados.split('');
    List<String> numeroMortesCompleto = numeroMortes.split('');

//Numero de casos confirmados formatado com os pontos
    String covidConfirmados = numeroConfirmadosCompleto[0] +
        numeroConfirmadosCompleto[1] +
        '.' +
        numeroConfirmadosCompleto[2] +
        numeroConfirmadosCompleto[3] +
        numeroConfirmadosCompleto[4] +
        '.' +
        numeroConfirmadosCompleto[5] +
        numeroConfirmadosCompleto[6] +
        numeroConfirmadosCompleto[7];

//Numero de casos recuperados formatado com os pontos
    String covidRecuperados = numeroRecuperadosCompleto[0] +
        '.' +
        numeroRecuperadosCompleto[1] +
        numeroRecuperadosCompleto[2] +
        numeroRecuperadosCompleto[3] +
        '.' +
        numeroRecuperadosCompleto[4] +
        numeroRecuperadosCompleto[5] +
        numeroRecuperadosCompleto[6];

//Numero de mortes formatado com os pontos
    String covidMortes = numeroMortesCompleto[0] +
        numeroMortesCompleto[1] +
        numeroMortesCompleto[2] +
        '.' +
        numeroMortesCompleto[3] +
        numeroMortesCompleto[4] +
        numeroMortesCompleto[5];

//Numero de mortes formatado com o final mil
    String covidRanking = numeroMortesCompleto[0] +
        numeroMortesCompleto[1] +
        numeroMortesCompleto[2] +
        ' mil';

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'CASOS DE COVID-19 NO MUNDO',
        ),
      ),
      backgroundColor: Colors.green[100],
      body: SingleChildScrollView(
        child: Center(
          child: carregado
              ? Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      color: Colors.orange[100],
                      child: Text(
                        'Atualizado em $dia/$mes/$ano às $hh:$mm',
                        style: TextStyle(
                            color: Colors.orange[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                    Container(
                      color: Colors.blue,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(25),
                            child: Text(
                              "Confirmados: $covidConfirmados",
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.green,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(25),
                            child: Text(
                              "Recuperados: $covidRecuperados",
                              style: TextStyle(fontSize: 25),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.grey,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(25),
                            child: Text(
                              "Mortes: $covidMortes",
                              style: TextStyle(fontSize: 25),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Text(
                                '\n\nPANDEMIAS QUE MAIS MATARAM NO MUNDO \n',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              DataTable(
                                columns: [
                                  DataColumn(
                                      label: Text(
                                    '#',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  )),
                                  DataColumn(
                                      label: Text(
                                    'Nome',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  )),
                                  DataColumn(
                                      label: Text(
                                    'Mortes',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  )),
                                ],
                                rows: [
                                  DataRow(cells: [
                                    DataCell(Text(
                                      '1',
                                      style: TextStyle(fontSize: 18),
                                    )),
                                    DataCell(Text(
                                      'Peste Negra',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    DataCell(Text(
                                      '200 Mi',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text(
                                      '2',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    DataCell(Text(
                                      'Varíola',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    DataCell(Text(
                                      '56 Mi',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text(
                                      '3',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    DataCell(Text(
                                      'Gripe Espanhola',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    DataCell(Text(
                                      '40-50 Mi',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text(
                                      '4',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    DataCell(Text(
                                      'Praga de Justiniano',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    DataCell(Text(
                                      '30-50 Mi',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text(
                                      '5',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    DataCell(Text(
                                      'HIV/AIDS',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    DataCell(Text(
                                      '25-35 Mi',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text(
                                      '6',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    DataCell(Text(
                                      'A Terceira Praga',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    DataCell(Text(
                                      '12 Mi',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text(
                                      '7',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    DataCell(Text(
                                      'Praga de Antonine',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    DataCell(Text(
                                      '5 Mi',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text(
                                      '8',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    DataCell(Text(
                                      'Praga do séc XVII',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    DataCell(Text(
                                      '3 Mi',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text(
                                      '9',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    DataCell(Text(
                                      'Gripe Asiática',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    DataCell(Text(
                                      '1.1 Mi',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text(
                                      '10',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    DataCell(Text(
                                      'Gripe Russa',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    DataCell(Text(
                                      '1 Mi',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text(
                                      '11',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    DataCell(Text(
                                      'Gripe de Hong Kong',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    DataCell(Text(
                                      '1 Mi',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text(
                                      '12',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    DataCell(Text(
                                      'Cólera',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    DataCell(Text(
                                      '1 Mi',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text(
                                      '13',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    DataCell(Text(
                                      'Varíola Japonesa',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    DataCell(Text(
                                      '1 Mi',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text(
                                      '14',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    )),
                                    DataCell(Text(
                                      'COVID-19',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    )),
                                    DataCell(Text(
                                      '$covidRanking',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    )),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text(
                                      '15',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    DataCell(Text(
                                      'Pragas do séc XVIII',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    DataCell(Text(
                                      '600 mil',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text(
                                      '16',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    DataCell(Text(
                                      'Gripe Suína',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    DataCell(Text(
                                      '200 mil',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text(
                                      '17',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    DataCell(Text(
                                      'Febre Amarela',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    DataCell(Text(
                                      '100-150 mil',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text(
                                      '18',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    DataCell(Text(
                                      'Ebola',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    DataCell(Text(
                                      '11 mil',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text(
                                      '19',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    DataCell(Text(
                                      'MERS',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    DataCell(Text(
                                      '850',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text(
                                      '20',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    DataCell(Text(
                                      'SARS',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    DataCell(Text(
                                      '770',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                  ]),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
                  ],
                )
              : Container(
                  child: Center(
                    child: Text(
                      "Carregando... Verifique sua conexão",
                      style: TextStyle(fontSize: 50),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
