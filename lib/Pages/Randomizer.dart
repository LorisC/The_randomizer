import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RandomizerHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RandomizerHomePageState();

}

class RandomizerHomePageState extends State<RandomizerHomePage>{
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('The Randomizer'),),
    );
  }

}
