import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Post.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  // Future<Map> _recuperarPreco() async {
  //   String url = "https://blockchain.info/ticker";
  //   http.Response response = await http.get(url);
  //   return json.decode(response.body);
  // }

  String _urlBase = "https://jsonplaceholder.typicode.com";

  Future<List<Post>> _recuperaPostagem() async{
    http.Response response = await http.get(_urlBase + "/posts");
    var dadosJson = json.decode(response.body);

    List<Post> postagens = List();
    for (var post in dadosJson) {
      Post p = Post(post["userId"], post["id"], post["title"], post["body"]);
      postagens.add(p);
    }
    return postagens;
  }
  _post() async {
    var corpo = json.encode(
      {
        "userId": 1,
        "id": 1,
        "title": "Foda pra caralhoooooo",
        "body": "Eu não uso gucci  eu só sou um persona"
      }
    );
    http.Response response = await http.post(
      _urlBase + "/posts",
      headers: {
        "Content-type": "application/json; charset=UTF-8"
      },
      body: corpo,
    );
    print("Resposta: ${response.statusCode}");
    print("Resposta: ${response.body}");
  }

  _put() async {
     var corpo = json.encode(
      {
        "userId": 120,
        "id": null,
        "title": "Foda pra caralhoooooo alt",
        "body": "Eu não uso gucci  eu só sou um persona alt"
      }
    );
    http.Response response = await http.put(
      _urlBase + "/posts/2",
      headers: {
        "Content-type": "application/json; charset=UTF-8"
      },
      body: corpo
    );
    print("Resposta: ${response.statusCode}");
    print("Resposta: ${response.body}");
  }
  
  _patch() async {
    var corpo = json.encode(
      {
        "userId": 120,
        "id": null,
        "title": "Foda pra caralhoooooo alt",
        "body": "Eu não uso gucci  eu só sou um persona alt"
      }
    );
    http.Response response = await http.patch(
      _urlBase + "/posts/2",
      headers: {
        "Content-type": "application/json; charset=UTF-8"
      },
      body: corpo
    );
    print("Resposta: ${response.statusCode}");
    print("Resposta: ${response.body}");
  }
  _delete(){

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consumo de serviço avançado"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                RaisedButton(
                  child: Text("Salvar"),
                  onPressed: _post,
                ),
                RaisedButton(
                  child: Text("Atualizar"),
                  onPressed: _put,
                ),
                RaisedButton(
                  child: Text("Remover"),
                  onPressed: _post,
                )
              ],
            ),
            Expanded(
              child: FutureBuilder<List<Post>>(
                future: _recuperaPostagem(),
                builder: (context, snapshot){          
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                      break;
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        print("Erro ao carregar os dados");
                      } else {
                        // double valor = snapshot.data["BRL"]["buy"];
                        // resultado = "preço do bitcoin: ${valor.toString()}";
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index){
                            List<Post> lista = snapshot.data;
                            Post post = lista[index];
                            return ListTile(
                              title: Text(post.title),
                              subtitle: Text(post.id.toString()),
                            );
                          },
                        );
                      }
                      break;
                    case ConnectionState.active:
                  }         
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}