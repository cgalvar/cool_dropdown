import 'package:flutter/material.dart';
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

List<CoolDropdownItem<String>> dropdownItemList = [];

List<String> pokemons = [
  'pikachu',
  'charmander',
  'squirtle',
  'bullbasaur',
  'snorlax',
  'mankey',
  'psyduck',
  'meowth'
];
List<String> fruits = [
  'apple',
  'banana',
  'grapes',
  'lemon',
  'melon',
  'orange',
  'pineapple',
  'strawberry',
  'watermelon',
];

class _MyAppState extends State<MyApp> {
  List<CoolDropdownItem> pokemonMap = [];
  List<CoolDropdownItem> fruitDropdownItems = [];

  final fruitDropdownController = DropdownController();
  final pokemonDropdownController = DropdownController();
  final listDropdownController = DropdownController();

  @override
  void initState() {
    for (var i = 0; i < pokemons.length; i++) {
      pokemonMap.add(
        CoolDropdownItem<String>(
            label: '${pokemons[i]}',
            icon: Container(
              height: 25,
              width: 25,
              child: SvgPicture.asset(
                'assets/${pokemons[i]}.svg',
              ),
            ),
            value: '${pokemons[i]}'),
      );
    }
    for (var i = 0; i < fruits.length; i++) {
      fruitDropdownItems.add(CoolDropdownItem<String>(
          label: '${fruits[i]}',
          icon: Container(
            height: 25,
            width: 25,
            child: SvgPicture.asset(
              'assets/${fruits[i]}.svg',
            ),
          ),
          value: '${fruits[i]}'));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF6FCC76),
          title: Text('Cool Drop Down'),
        ),
        body: ListView(
          children: [
            SizedBox(
              height: 400,
            ),
            Center(
              child: CoolDropdown(
                controller: fruitDropdownController,
                dropdownList: fruitDropdownItems,
                onChange: (selectedItem) {
                  print(selectedItem);
                },
                onOpen: (isOpen) {
                  print('$isOpen');
                },
                resultOptions: ResultOptions(
                  width: 200,
                  icon: SizedBox(
                    width: 10,
                    height: 10,
                    child: CustomPaint(
                      painter: DropdownArrowPainter(),
                    ),
                  ),
                ),
                dropdownOptions: DropdownOptions(
                  width: 300,
                  height: 300,
                  gap: DropdownGap.all(5),
                  borderSide: BorderSide(width: 1, color: Colors.black),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  align: DropdownAlign.left,
                ),
                dropdownArrowOptions: DropdownArrowOptions(
                  width: 10,
                  height: 10,
                  borderRadius: 0,
                  arrowAlign: DropdownArrowAlign.left,
                ),
              ),
            ),
            SizedBox(
              height: 200,
            ),
            Center(
              child: CoolDropdown<String>(
                controller: pokemonDropdownController,
                // resultIcon: Container(), // if you don't want to use Icon you can set empty Container
                dropdownList: dropdownItemList,
                // isResultLabel: false,
                onChange: (a) {},
                // dropdownItemReverse: true,
                // labelIconGap: 20,
                // resultIcon: Container(
                //   width: 10,
                //   height: 10,
                //   child: SvgPicture.asset(
                //     'assets/dropdown-arrow.svg',
                //     semanticsLabel: 'Acme Logo',
                //     color: Colors.grey.withOpacity(0.7),
                //   ),
                // ),
              ),
            ),
            SizedBox(
              height: 200,
            ),
            Center(
              child: CoolDropdown(
                controller: listDropdownController,
                dropdownList: pokemonMap,
                onChange: (dropdownItem) {},
                // resultIcon: Container(
                //   width: 25,
                //   height: 25,
                //   child: Container(
                //     width: 25,
                //     height: 25,
                //     child: SvgPicture.asset(
                //       'assets/pokeball.svg',
                //     ),
                //   ),
                // ),
                // resultIconLeftGap: 0,
                // resultIconRotation: true,
                // resultIconRotationValue: 1,
                // isDropdownLabel: false,
                // isResultLabel: false,
                // isResultIconLabel: false,
                // selectedItemBD: BoxDecoration(
                //     border: Border(
                //         left: BorderSide(
                //             color: Colors.black.withOpacity(0.7), width: 3))),
              ),
            ),
            SizedBox(
              height: 400,
            ),
          ],
        ),
      ),
    );
  }
}
