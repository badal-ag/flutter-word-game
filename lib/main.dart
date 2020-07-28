import "package:flutter/material.dart";
import "package:random_words/random_words.dart";

void main() => runApp (new MyApp());

class MyApp extends StatelessWidget {
   @override
   
   Widget build(BuildContext context) {
      return new MaterialApp(
        title: 'Word Game',
        home: new RandomSentences(),   
      );
   }
}

class RandomSentences extends StatefulWidget {
    @override 
    createState() => new _RandomSentencesState();
}

class _RandomSentencesState extends State<RandomSentences> {
 
   final _sentences = <String>[];       // declaring that sentences will be a string
   final _funnies = new Set<String>();  // this is a string to add sentences seperately on a list
   final _biggerfont = const TextStyle(fontSize: 14.0);  // this will change the font size of the text  
 
  @override
  Widget build(BuildContext context) {
      return new Scaffold( 
        appBar: new AppBar(
          title: new Text('Word Game'),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.list) ,
              onPressed : _pushFunnies,
              ),
          ],
        ),
        body: _buildSentences(),
      );
  }

  void _pushFunnies() {                       // this is the function to make a list of saved funny sentences
     Navigator.of(context).push(
      new MaterialPageRoute(
         builder: (context) {
           final tiles = _funnies.map(
             (sentence) {
               return new ListTile(
                 title:new Text(
                   sentence,
                   style: _biggerfont,
                 ),
               );
             },  
           ); 
            final divided = ListTile.divideTiles(
              context: context,
              tiles: tiles,
            ).toList();

              return new Scaffold(
                appBar: new AppBar(
                  title: new Text('Saved Funny Sentences'),
                ),
                body: new ListView(children: divided),
              );  
         },
        ),
    );
  }
  
  String _getSentence() {
      final noun = new WordNoun.random();  // this function will generate a new noun each time the program is loaded
      final adjective = new WordAdjective.random(); // this will generate a new adjective each time program is loaded
      return  "The coder made a ${adjective.asCapitalized} app in Flutter for his ${noun.asCapitalized}"; 
  } // _getSentence

  Widget _buildRow(String sentence) {
    final alreadyFoundFunny = _funnies.contains(sentence);  // this will contain a sentence that we would like to add to our list
    return new ListTile(
      title: new Text(
        sentence,
        style: _biggerfont,
      ),

      trailing: new Icon(                   // add an icon just after the sentence to add them to our list
        alreadyFoundFunny ? Icons.thumb_up : Icons.thumb_down, //ternanry operator, if saved thumb up & if not thumb down
        color: alreadyFoundFunny ? Colors.green : Colors.red,     //turn the color of the icon to green if the sentence is saved else red color 
      ),

      onTap: () {      // If the icon is tapped and sentence not saved, then save it and change color & icon else if already saved, then do vice-versa
         setState(() {
              if (alreadyFoundFunny) {
                 _funnies.remove(sentence);
              } else {
                _funnies.add(sentence);
              }
         });
      },
    
    );
  }
  //build an infinite scrolling list

  Widget _buildSentences() {
    return new ListView.builder(   // An Item Builder callback is used to add sentences & dividers based on 
      padding: const EdgeInsets.all(16.0),       //when user scrolls down the view       
       itemBuilder: (context, i) {            // adds pixel divider before each row
          if(i.isOdd) return new Divider();       // Divides i by 2, then returns value into index. Counts how many sentences in List View
          final index = i ~/ 2;                // Checks to see if we have hit the end of sentence list 
          if (index >= _sentences.length) {        // If we have, then generate another 10 sentences
            for (int x = 0; x < 10; x++) {
              _sentences.add(_getSentence());
            }
          }
         return _buildRow(_sentences[index]);
       },  
    );
  }
}

//Stateless widgets are immutable, meaning their properties cannot be changed
//Stateful widgets are flexible, meaning their properties can be changed