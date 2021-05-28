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

class _MyAppState extends State<MyApp> {

  final  List<int> cell  =  <int> [0,0,0,0,0,0,0,0,0];
  final Player firstPlayer = Player('Superman', Colors.blue);
  final Player secondPlayer = Player('WonderWoman', Colors.red);
  final int counter = 0;

  String someText = "ceva";

  @override
  Widget build(BuildContext context) {
    Color color = Colors.blue;
    final Game game = Game(firstPlayer,secondPlayer);
    final List<int> board = [0,1,2,3,4,5,6,7,8];
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
                  setState(() {
                    color = index.isOdd == 0 ? Colors.red : Colors.blue;
                    print('state changed');
                  });
                  if( board.contains(index) == false ){

                    print("not valid cell");

                  }else{
                    //color tile with player color
                    print(game._getCurrentPlayer().color);

                    game.run(index);
                    board.remove(index);
                    //check game status
                    if(game.getGameStatus() == 'off') {
                      //do something for the winners
                    }
                  }
                 //remove used cell preventing users to take partner cell
                },
                child: CustomContainer(

                  color: index.isOdd == 0 ? Colors.red : Colors.blue,
                  index: index,
                ),
              );
            }
        )
    );
  }
}

class CustomContainer extends StatefulWidget {
  const CustomContainer({Key ? key, required this.index, required this.color}) : super(key: key);
  final int index;
  final Color color;

  @override
  _CustomContainerState createState() => _CustomContainerState(index, color);
}

class _CustomContainerState extends State<CustomContainer> {

   _CustomContainerState(this.index,this.color);
   final Color color;
   final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: index.isOdd == 0 ? Colors.red : Colors.blue,
      alignment: Alignment.center,
      child: Text('$index'),
    );
  }
}


class Game {

  Game (this.firstPlayer, this.secondPlayer);

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
  final Player firstPlayer;
  final Player secondPlayer;
  static String _gameStatus = 'on';
  static int turn = 0 ;

   Player _getCurrentPlayer() {
     if(turn % 2 == 0) {
       return firstPlayer;
     } else {
       return secondPlayer;
     }
  }

  String getGameStatus()
  {
    return _gameStatus;
  }

  void run(int index)
  {
    turn++;
    Player currentPlayer = _getCurrentPlayer();
    String playerName = currentPlayer.name;
    print("is $playerName turn");
    if(!currentPlayer.numbers.contains(index)){
      currentPlayer.numbers.add(index);
      /**
       * create a new list with the winning keys and player chosen to spot if there are at least 3 duplicate
       *  value
       */
      for(int j=0; j < winningKeys.length; j++){
        List<int> newList = new List.from(currentPlayer.numbers)..addAll(winningKeys[j]);
        List<int> duplicateList = [];
        for(int i=0; i<newList.length; i++){

          //remove current value of the key to remain only with the value that should be checked
          List<int> checkedArray = newList;
          int checkedValue = checkedArray[i];
          checkedArray.removeAt(i);

          if(checkedArray.contains(checkedValue)){
            duplicateList.add(checkedValue);
          }

          //if duplicate list has 3 elements - set the winning path, set game status accordingli
          if(duplicateList.length == 3){
              print('found');
              String winner = currentPlayer.name;
              print("$winner is the big winner in $turn steps");
              _gameStatus = 'Off';
          }
        }
      }
    }
  }
}


class Player
{

  Player(this.name, this.color);

  String name;
  Color color;
  List<int> numbers = [];

}


