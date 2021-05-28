import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    title: 'Some app',
    home: CustomContainer(
      color: Colors.blue,
    ),
  ));
}

class CustomContainer extends StatefulWidget {
  const CustomContainer({required this.color, Key? key}) : super(key: key);
  final Color color;

  @override
  _CustomContainerState createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> {
  static List<int> cell = <int>[0, 0, 0, 0, 0, 0, 0, 0, 0];

  Color color = Colors.blue;
  int clicked = 10;

  final Player firstPlayer = Player('Superman', Colors.blue);
  final Player secondPlayer = Player('WonderWoman', Colors.red);
  final int counter = 0;

  @override
  Widget build(BuildContext context) {
    final Game game = Game(firstPlayer, secondPlayer);
    final Player currentPlayer = game._getCurrentPlayer();
    final GridView board = GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
      ),
      itemCount: cell.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              print(game.getGameStatus());
              if (game.availableMoves() > 0 && game.isValidMove(index)) {
                //set player - set one for first player set two for the second player
                game.run(index);
                cell[index] = (currentPlayer.name == 'Superman') ? 1 : 2;
              } else {
                print('that move has been done already');
              }

              if (game.getGameStatus() == 'off') {
                print(game.winner);
                showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: const Text('Game Over'),
                          content: Text(game.winner),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Ok'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, 'Cancel');
                                setState(() {
                                  cell = <int>[0, 0, 0, 0, 0, 0, 0, 0, 0];
                                  game.resetGame();
                                });
                              },
                              child: const Text('Play Again'),
                            ),
                          ],
                        ));
              }
            });
          },
          child: Container(
            color: cell[index] == 0
                ? Colors.blue
                : cell[index] == 1
                    ? Colors.red
                    : Colors.green,
            child: Text('$index'),
          ),
        );
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('some text'),
      ),
      body: board,
    );
  }
}

class Game {
  Game(this.firstPlayer, this.secondPlayer);

  final List<List<int>> winningKeys = <List<int>>[
    <int>[0, 1, 2],
    <int>[3, 4, 5],
    <int>[6, 7, 8],
    <int>[0, 3, 6],
    <int>[1, 4, 7],
    <int>[2, 5, 8],
    <int>[0, 4, 8],
    <int>[2, 4, 6]
  ];

  static List<int> winnerKeys = <int>[];
  final Player firstPlayer;
  final Player secondPlayer;
  static String _gameStatus = 'on';
  String winner = '';
  static int turn = 0;
  static List<int> playedMove = <int>[];

  void resetGame() {
    _gameStatus = 'on';
    playedMove = <int>[];
    winnerKeys = <int>[];
    firstPlayer.moves = <int>[];
    secondPlayer.moves = <int>[];
    turn = 0;
  }

  void setWinner(String winnerMessage) {
    winner = winnerMessage;
  }

  bool isValidMove(int index) {
    if (playedMove.contains(index)) {
      return false;
    } else {
      playedMove.add(index);
      return true;
    }
  }

  int availableMoves() {
    return 9 - playedMove.length;
  }

  Player _getCurrentPlayer() {
    return (turn.isOdd) ? firstPlayer : secondPlayer;
  }

  String getGameStatus() {
    return _gameStatus;
  }

  void run(int index) {
    turn++;

    final Player currentPlayer = _getCurrentPlayer();
    final String playerName = currentPlayer.name;
    print('is $playerName turn');
    if (!currentPlayer.moves.contains(index)) {
      currentPlayer.moves.add(index);
      print(currentPlayer.moves);
      /**
       * create a new list with the winning keys and player chosen
       * to spot if there are at least 3 duplicate value
       */
      for (int j = 0; j < winningKeys.length; j++) {
        final List<int> newList = List<int>.from(currentPlayer.moves)..addAll(winningKeys[j]);
        final List<int> duplicateList = <int>[];
        for (int i = 0; i < newList.length; i++) {
          //remove current value of the key to remain only with the value that should be checked
          final List<int> checkedArray = newList;
          final int checkedValue = checkedArray[i];
          checkedArray.removeAt(i);

          if (checkedArray.contains(checkedValue)) {
            duplicateList.add(checkedValue);
          }

          //if duplicate list has 3 elements - set the winning path, set game status accordingli
          if (duplicateList.length == 3) {
            print('found');
            final String winner = currentPlayer.name;
            print('$winner is the big winner');
            _gameStatus = 'off';
            setWinner('$winner is the big winner');
          }

          //set draw
          if (_gameStatus == 'on' && availableMoves() == 0) {
            _gameStatus = 'off';
            setWinner('This is a draw');
          }
        }
      }
    }
  }
}

class Player {
  Player(this.name, this.color);
  String name;
  Color color;
  List<int> moves = <int>[];
}
