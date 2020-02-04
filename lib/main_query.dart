import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  runApp(MaterialApp(title: "GQL App", home: HomePage()));
}

class HomePage extends StatefulWidget {
  final HttpLink httpLink = HttpLink(uri: "http://192.168.0.10:4000/");
  GraphQLClient client;

  HomePage() {
    this.client = GraphQLClient(
      cache: InMemoryCache(),
      link: httpLink,
    );
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  dynamic variable = {"author": "AUTOR MUITO ZIKA", "title": "LIVRO MUITO ZIKA"};

  Future<QueryResult> books(dynamic variable) async {
    final String query = r"""
                    query {
                      books {
                        author
                        title
                      }
                    }
                  """;
    final QueryOptions options = QueryOptions(documentNode: gql(query), variables: variable);
    return await widget.client.query(options);
  }

  Future<dynamic> getBooks(dynamic variable) async {
    return (await books(variable) as QueryResult).data;
  }

  buildContainer() {
    return Column(
      children: <Widget>[
        Container(
          height: 200,
            child: FutureBuilder(
                future: getBooks(this.variable),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                  }
                  if (snapshot.hasData) {
                    print(snapshot.data);
                    List<dynamic> listItems = snapshot.data["books"];
                    return ListView.builder(
                        itemCount: listItems.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Text(listItems[index]["title"]);
                        });
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })),
        RaisedButton(
          onPressed: () async {
            setState(() {
              this.variable = {"author": "AUTOR MUITO INCRIVEL", "title": "LIVRO MUITO INCRIVEL"};
              print(this.variable);
            });
          },
          child: Text('MUTATION'),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildContainer(),
    );
  }
}
