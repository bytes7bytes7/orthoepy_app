import 'package:flutter/material.dart';
import 'settings_screen.dart';
import 'quiz_screen.dart';
import 'components/custom_outlined_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key key,
    @required this.words,
  }) : super(key: key);

  final Map<String, int> words;

  @override
  Widget build(BuildContext context) {
    final String firstButtonTitle = 'Вразброс';
    final String secondButtonTitle = 'По порядку';
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Орфоэпия',
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomOutlinedButton(
              text: firstButtonTitle,
              onPressed: () {
                print(firstButtonTitle);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => QuizScreen(
                      words: words,
                      screenTitle: firstButtonTitle,
                      isRandom: true,
                    ),
                  ),
                );
              },
            ),
            CustomOutlinedButton(
              text: secondButtonTitle,
              onPressed: () {
                print(secondButtonTitle);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => QuizScreen(
                      words: words,
                      screenTitle: secondButtonTitle,
                      isRandom: false,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.settings),
        onPressed: () {
          print('Настройки');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => SettingsScreen(words: words),
            ),
          );
        },
      ),
    );
  }
}
