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


  Future<QueryResult> createBook(dynamic variable) async {
    final String mutation = r"""
                    mutation createBook($author: String!, $title: String!) {
                      createBook(author: $author, title: $title) {
                        author
                        title
                      }
                    }
                  """;
    final MutationOptions options = MutationOptions(
      documentNode: gql(mutation),
      variables: variable,
    );
    return await widget.client.mutate(options);
  }

  buildContainer() {
    return Container(
        child: RaisedButton(
      onPressed: () async {
        final QueryResult queryResult = await createBook({"author": "AUTOR MUITO ZIKA", "title": "LIVRO MUITO ZIKA"});
        print(queryResult.data);
      },
      child: Text('MUTATION'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GraphQL para Flutter'),
      ),
      body: buildContainer(),
    );
  }
}
