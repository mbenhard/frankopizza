import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../screens/screen.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import '../widgets/widget.dart';

class GroupModel {
  String text;
  int index;
  bool selected;

  GroupModel({required this.text, required this.index, required this.selected});
}

class languagePage extends StatefulWidget {
  @override
  _languagePageState createState() => _languagePageState();
}

class _languagePageState extends State<languagePage> {
  int _value2 = 0;
  int lang = 1;
  late int v;
  List<GroupModel> _group = [
    GroupModel(text: "SLOVENČINA", index: 1, selected: false),
    GroupModel(text: "ENGLISH", index: 2, selected: true),
    GroupModel(text: "DEUTSCH", index: 3, selected: false),
  ];

  // ignore: unnecessary_new
  List<RadioModel> sampleData = <RadioModel>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sampleData.add(RadioModel(
        true, Icons.account_balance, 'Option A', Colors.blue, Colors.grey));
    sampleData.add(
        RadioModel(false, Icons.receipt, 'Option B', Colors.blue, Colors.grey));
    sampleData.add(RadioModel(
        false, Icons.account_circle, 'Option C', Colors.blue, Colors.grey));
    sampleData.add(RadioModel(
        false, Icons.shopping_cart, 'Option D', Colors.blue, Colors.grey));
  }

  Widget makeRadioTiles() {
    List<Widget> list = <Widget>[];

    for (int i = 0; i < _group.length; i++) {
      list.add(Container(
        margin: const EdgeInsets.only(top: 5, bottom: 5),
        decoration: BoxDecoration(
            color: _group[i].selected
                ? const Color.fromARGB(255, 255, 255, 255)
                : Color(0xFF6C963F),
            borderRadius: const BorderRadius.all(
                Radius.circular(10.0) //         <--- border radius here
                )),
        child: RadioListTile(
          value: _group[i].index,
          groupValue: _value2,
          selected: _group[i].selected,
          onChanged: (val) {
            setState(() {
              for (int i = 0; i < _group.length; i++) {
                _group[i].selected = false;
              }
              _value2 = val!;
              _group[i].selected = true;
              lang = i;
              print(lang.toString());
            });
          },
          activeColor: Colors.white,
          controlAffinity: ListTileControlAffinity.trailing,
          title: Text(
            ' ${_group[i].text}',
            style: TextStyle(
                color: _group[i].selected ? Colors.black : Color(0xFFDADADA),
                fontWeight:
                    _group[i].selected ? FontWeight.bold : FontWeight.normal),
          ),
        ),
      ));
    }

    Column column = Column(
      children: list,
    );
    return column;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        //to make page scrollable
        child: CustomScrollView(
          reverse: true,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 60,
                          ),
                          Center(
                            child: Text(
                              "CHOOSE YOUR LANGUAGE ",
                              style: kHeadline,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Center(
                            child: Text(
                              "Choose your preferred language for ordering.",
                              style: kBodyText1,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          makeRadioTiles(),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MyTextButton(
                      buttonName: 'CONTINUE',
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => WelcomePage(v: lang),
                          ),
                        );
                      },
                      bgColor: Color(0xFF33481C),
                      textColor: Colors.white,
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomRadio extends StatefulWidget {
  List<RadioModel> sampleData = <RadioModel>[];

  CustomRadio(this.sampleData);

  @override
  createState() {
    return CustomRadioState(sampleData);
  }
}

class CustomRadioState extends State<CustomRadio> {
  List<RadioModel> sampleData = <RadioModel>[];

  CustomRadioState(this.sampleData);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: sampleData.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          //highlightColor: Colors.red,
          splashColor: Colors.blueAccent,
          onTap: () {
            setState(() {
              sampleData.forEach((element) => element.isSelected = false);
              sampleData[index].isSelected = true;
            });
          },
          child: RadioItem(sampleData[index]),
        );
      },
    );
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;

  RadioItem(this._item);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            height: 50.0,
            width: 50.0,
            child: Center(
              child: Icon(
                _item.icon,
                color:
                    _item.isSelected ? _item.selectedColor : _item.defaultColor,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10.0),
            child: Text(
              _item.text,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight:
                    _item.isSelected ? FontWeight.bold : FontWeight.normal,
                color:
                    _item.isSelected ? _item.selectedColor : _item.defaultColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  final IconData icon;
  final String text;
  final Color selectedColor;
  final Color defaultColor;

  RadioModel(this.isSelected, this.icon, this.text, this.selectedColor,
      this.defaultColor);
}
