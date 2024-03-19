import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

class WebScrapingExample extends StatefulWidget {
  @override
  _WebScrapingExampleState createState() => _WebScrapingExampleState();
}

class _WebScrapingExampleState extends State<WebScrapingExample> {
  String musica = 'Carregando...';
  String banda = 'Carregando...';
  String textFromWebsite = 'Carregando...';
  String ajustado = '';
  bool cifra = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  String transformToSlug(String text) {
    return text.toLowerCase().replaceAll(' ', '-');
  }

  Future<void> fetchData() async {
    String input_banda = "NX Zero";
    String input_musica = "Cedo Ou Tarde";
    String busca_banda = transformToSlug(input_banda);
    print(busca_banda);
    String busca_musica = transformToSlug(input_musica);
    final url = 'https://www.cifraclub.com.br/' +
        busca_banda +
        '/' +
        busca_musica +
        '/';
    print(url);
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final document = parser.parse(response.body);

      var divElement = document.querySelector('pre');
      print(divElement);

      if (divElement != null) {
        String text = "";
        final childElements = divElement.querySelectorAll('*');
        //print(childElements);
        for (var child in childElements) {
          //print(child.text);
          // print(child.localName);
          // Imprimir o localName de cada elemento
          if (child.localName == 'b') {
            cifra = true;
          }
          setState(() {
            text += child.text;
          });
          // print(text);
        }

        final boldTextElements = divElement
            .getElementsByTagName('b'); // pega todos os elementos b do texto

        String boldText = '';
        for (var element in boldTextElements) {
          // listagem dos elementos b
          // print(element);
          boldText += element.text;
        }

        textFromWebsite = (divElement.text);
      }

      var Name = document.querySelector('h1.t1');
      var Band = document.querySelector('h2.t3 a');
      if (Name != null) {
        setState(() {
          musica = Name.innerHtml.toString();
        });
      }

      if (Band != null) {
        setState(() {
          banda = Band.innerHtml.toString();
        });
      }
    } else {
      setState(() {
        musica = 'Falha ao carregar a página';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: Text(
          musica + " - " + banda,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              child: Column(
                children: [
                  //Text(musica),
                  //Text(banda),
                  Text(
                    textFromWebsite,
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    ajustado,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: WebScrapingExample(),
  ));
}
