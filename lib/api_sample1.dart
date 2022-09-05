import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    home: MyHomePage(),
  ));
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map data = {};
  List userData =[];

  Future getData() async {
    http.Response response = await http.get(Uri.parse('https://reqres.in/api/users?page=2'));
    print('getdataは走っています');
    if (response.statusCode == 200) {
      print('ifはtrueです');
      data = json.decode(response.body); //json->Mapオブジェクトに格納
      setState(() { //状態が変化した場合によばれる
        userData = data["data"]; //Map->Listに必要な情報だけ格納
      });
    }else{
      throw Exception('Failed to load userlist');
    }
    }
     

  @override
      void initState() {
        super.initState();
        print('initstateできています');
        getData();
      }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(     
        title: const Text('API練習'),
        backgroundColor: Colors.green,       
      ),
      body: ListView.builder(
        itemCount: userData == null ? 0 : userData.length,
        itemBuilder: (BuildContext context, int index) { //ここに表示したい内容をindexに応じて
            return Card( //cardデザインを定義:material_design
              child: Row(
                children: <Widget>[
                  CircleAvatar( //ユーザプロフィール画像に使う用のクラス
                    backgroundImage: NetworkImage(userData[index]["avatar"]),
                    //NetworkImage()はHTTPで画像をとってくる。これはプロフィール画像。
                  ),
                   Text("${userData[index]["first_name"]} ${userData[index]["last_name"]}")
                ],
              ),
            );
          },
      ),
    );
  }
}
