import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class RandomizerHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RandomizerHomePageState();
}

class RandomizerHomePageState extends State<RandomizerHomePage> {
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

  addOption(context) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
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

  @override
  Widget build(BuildContext context) {
    Function getRandom = options.length > 0
        ? () {
            getRandomObject(context);
          }
        : null;
    return Scaffold(
      appBar: AppBar(
        title: Text('The Randomizer'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
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
        ],
      ),
      bottomNavigationBar: MyButton(
        onPressed: getRandom,
      ),
    );
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
    Color color = Colors.blueGrey;
    if (onPressed != null) {
      color = Colors.blue;
    }
    return GestureDetector(
        onTap: onPressed,
        child: Container(
          height: 48,
          child: Center(
              child: Text(
            'Choose randomly',
            style: TextStyle(color: Colors.white),
          )),
          color: color,
        ));
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
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Spacer(),
              Text(
                "My options",
                style: TextStyle(fontSize: 24),
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.clear_all),
                tooltip: "remove all option",
                onPressed: onListDeleted,
              ),
            ],
          ),
          Divider(
            thickness: 2,
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
      ),
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
            onPressed: () {
              onPressed(context);
            },
          )
        ],
      ),
    );
  }
}
