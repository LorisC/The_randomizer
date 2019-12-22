import 'dart:math';

import 'package:flutter/material.dart';

import 'Pages/Randomizer.dart';

void main() => runApp(TheRandomizerApp());

class TheRandomizerApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EnouApps The Randomizer',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: RandomizerHomePage(),
    );
  }
}


class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<String> options = [];
  TextEditingController controller = TextEditingController();
  String currentWord = "";

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        currentWord = controller.text;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  addOption() {
    if (currentWord.isNotEmpty)
      setState(() {
        options.add(currentWord);
        controller.text = "";
      });
  }

  Future<void> getRandomObject(context) {
    return showDialog(
        context: context,
        builder: (BuildContext bContext) {
          Random rand = new Random(DateTime.now().millisecondsSinceEpoch);
          return MyRandomAlert(
            randomOption: options.elementAt(
              rand.nextInt(options.length),
            ),
          );
        });
  }

  FloatingActionButton myFloatingActionButton() {
    if (options.isNotEmpty)
      return FloatingActionButton(
        child: Icon(Icons.repeat),
        onPressed: () {
          getRandomObject(context);
        },
      );
    return FloatingActionButton(
      child: Icon(Icons.repeat),
      onPressed: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        child: Column(
          children: <Widget>[
            MyList(
              options: options,
              onItemDeleted: (num idx) {
                setState(() {
                  options.removeAt(idx);
                });
              },
              onListDeleted: () {
                setState(() {
                  options.clear();
                });
              },
            ),
            MyTextField(
              controller: controller,
              onPressed: addOption,
            ),
            MyButton(
              onPressed: options.isEmpty
                  ? null
                  : () {
                      getRandomObject(context);
                    },
            )
          ],
        ),
      ),
    ));
  }
}

class MyOptionItem extends StatelessWidget {
  final String name;
  final Function onPressed;

  const MyOptionItem({Key key, this.name, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      trailing: IconButton(
        icon: Icon(Icons.clear),
        onPressed: onPressed,
        tooltip: "remove",
      ),
    );
  }
}

class MyRandomAlert extends StatelessWidget {
  final String randomOption;

  const MyRandomAlert({Key key, this.randomOption}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    return AlertDialog(
      title: Text("I choose this for you. I hope you'll enjoy it"),
      content: Container(
        height: media.size.height / 4,
        width: media.size.width / 4,
        child: Center(
          child: Text(
            randomOption,
            style: TextStyle(
              fontSize: 34,
            ),
          ),
        ),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  final Function onPressed;

  const MyButton({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      child: Text('Choose randomly'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(32),
        ),
      ),
      color: Colors.blue,
      disabledColor: Colors.blueGrey,
    );
  }
}

class MyList extends StatelessWidget {
  final List<String> options;
  final Function onItemDeleted;
  final Function onListDeleted;

  const MyList({Key key, this.options, this.onItemDeleted, this.onListDeleted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide()),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Spacer(),
              Text("My options", style: TextStyle(fontSize: 24),),
              Spacer(),
              IconButton(
                icon: Icon(Icons.clear_all),
                tooltip: "remove all option",
                onPressed: onListDeleted,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: options.length,
            itemBuilder: (context, idx) {
              return MyOptionItem(
                name: options.elementAt(idx),
                onPressed: () {
                  onItemDeleted(idx);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class MyTextField extends StatelessWidget {
  final Function onPressed;
  final TextEditingController controller;

  const MyTextField({Key key, this.onPressed, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(9.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(36),
                  ),
                ),
                labelText: "Option",
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add_circle_outline, size: 40, color: Colors.blue),
            onPressed: onPressed,
          )
        ],
      ),
    );
  }
}

/*
*  Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: data.size.width,
          height: data.size.height,
          child:  Column(
            children: <Widget>[
              Container(
                height: data.size.height / 90 * 100,
                child: ListView.builder(
                    itemCount: objectToRandomize.length,
                    itemBuilder: (context, idx) {
                      return ListTile(
                        title: Text(objectToRandomize[idx]),
                      );
                    }),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    TextField(
                      controller: controller,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: addTextToRandomizeObject,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: myFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,*/
