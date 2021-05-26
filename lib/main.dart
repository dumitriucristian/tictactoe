import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    title: 'Some app',
    home:MyApp(),

  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key ? key}) : super(key: key);



  @override
  _MyAppState createState() => _MyAppState();
}
class Game {

  Game ({Key ? key});

  final  List<List<int>> winningKeys = [
      [0,1,2],
      [3,4,5],
      [6,7,8],
      [0,3,6],
      [1,4,7],
      [2,5,8],
      [0,4,8],
      [2,4,6]
  ];

  final List<int> playerOne = [];
  final List<int> winnerKeys = [];
  final List<int> turn = [];

}
class _MyAppState extends State<MyApp> {

  final  List<int> cell  =  <int> [0,0,0,0,0,0,0,0,0];
  final Game game = Game();


  @override

  Widget build(BuildContext context) {

    print(game.winningKeys);
    return Scaffold(
      appBar: AppBar(
        title: const Text( 'some title'),
     ),
      body: GridView.builder(
          itemCount: cell.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 1,
            crossAxisSpacing: 1,
          ),
          itemBuilder: (BuildContext context, index) {
            return GestureDetector(

              onTap: (){
               // if user click for first time add to his index
                if(!game.playerOne.contains(index)){
                  game.playerOne.add(index);
                  /**
                   * create a new list with the winning keys and player chosen to spot if there are at least 3 duplicate
                    *  value
                    */
                  for(int j=0; j < game.winningKeys.length; j++){
                  //  print(j);

                    List<int> newList = new List.from(game.playerOne)..addAll(game.winningKeys[j]);
                    //print(newList);
                    List<int> duplicateList = [];
                    for(int i=0; i<newList.length; i++){

                      //remove current value of the key to remain only with the value that should be checked
                      List<int> checkedArray = newList;
                      int checkedValue = checkedArray[i];
                      checkedArray.removeAt(i);

                      if(checkedArray.contains(checkedValue)){
                        duplicateList.add(checkedValue);
                      }

                      //if duplicate list has 3 elements - set the winning path
                      if(duplicateList.length == 3){
                        print('found');
                        print(duplicateList);
                      }
                    }
                  }
                }
               // print(game.playerOne);
              },
              child: Container(
                color:Colors.blue,
                alignment: Alignment.center,
                child: Text('$index'),
              ),
            );
          }
      )
    );
  }
}


class Player {

  Player({required this.name});
  List<int> numbers = [];
  String name;
}