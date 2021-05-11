import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dersAdi;
  int dersKredi = 1;
  double dersHarfDegeri = 4;
  List<Ders> tumDersler;
  var formKey = GlobalKey<FormState>();
  double ortalama = 0;
  static int sayac = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tumDersler = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Ortalama Hesabla"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          if (formKey.currentState.validate()) {
            formKey.currentState.save();
          }
        },
      ),
      body: OrientationBuilder(builder: (context, orientaion) {
        if (orientaion == Orientation.portrait) {
          return uygulamaGovdesi();
        } else
          return uygulamaGovdesiLandscape();
      }),
    );
  }

  Widget uygulamaGovdesi() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          //Static form tutan container
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            //color: Colors.purple.shade400,
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Ders Adi",
                      hintText: "Ders Adina giriniz",
                      hintStyle: TextStyle(fontSize: 22),
                      labelStyle: TextStyle(fontSize: 21),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.purple, width: 2)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.purple, width: 2)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide:
                              BorderSide(color: Colors.purple, width: 2)),
                    ),
                    validator: (girilenDeger) {
                      if (girilenDeger.length > 0) {
                        return null;
                      } else
                        return "Ders adi bos olamaz!";
                    },
                    onSaved: (kaydedilecekDeger) {
                      dersAdi = kaydedilecekDeger;
                      setState(() {
                        tumDersler.add(
                          Ders(dersAdi, dersHarfDegeri, dersKredi,
                              rastGeleRenkOlustur()),
                        );
                        ortalama = 0;
                        ortalamayiHesaplac();
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            items: dersKrediItems(),
                            value: dersKredi,
                            onChanged: (secilenKredi) {
                              setState(() {
                                dersKredi = secilenKredi;
                              });
                            },
                          ),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.purple, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                      Container(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<double>(
                              items: dersHarfDegerleriItems(),
                              value: dersHarfDegeri,
                              onChanged: (secilenHarf) {
                                setState(() {
                                  dersHarfDegeri = secilenHarf;
                                });
                              }),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.purple, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.teal,
              border: BorderDirectional(
                top: BorderSide(color: Colors.purple.shade500, width: 2),
                bottom: BorderSide(color: Colors.purple.shade500, width: 2),
              ),
            ),

            margin: EdgeInsets.symmetric(vertical: 10),
            height: 70,
            //color: Colors.blue,
            child: Center(
                child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                      text: tumDersler.length == 0
                          ? " Lutfen ders ekleyin."
                          : "Ortalama : ",
                      style: TextStyle(fontSize: 40, color: Colors.black54)),
                  TextSpan(
                      text: tumDersler.length == 0
                          ? " "
                          : "${ortalama.toStringAsFixed(2)}",
                      style: TextStyle(
                          fontSize: 40,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            )),
          ),
          //dinamik liste tutan kontainer
          Expanded(
            child: Container(
              // decoration: BoxDecoration(
              //   border: BorderDirectional(
              //     top: BorderSide(color: Colors.purple.shade500, width: 2),
              //     bottom: BorderSide(color: Colors.purple.shade500, width: 2),
              //   ),
              // ),
              //color: Colors.lightGreenAccent.shade700,
              child: ListView.builder(
                itemBuilder: _listeElemanlariniOlustur,
                itemCount: tumDersler.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget uygulamaGovdesiLandscape() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  //color: Colors.purple.shade400,
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Ders Adi",
                            hintText: "Ders Adina giriniz",
                            hintStyle: TextStyle(fontSize: 22),
                            labelStyle: TextStyle(fontSize: 21),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.purple, width: 2)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.purple, width: 2)),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide:
                                    BorderSide(color: Colors.purple, width: 2)),
                          ),
                          validator: (girilenDeger) {
                            if (girilenDeger.length > 0) {
                              return null;
                            } else
                              return "Ders adi bos olamaz!";
                          },
                          onSaved: (kaydedilecekDeger) {
                            dersAdi = kaydedilecekDeger;
                            setState(() {
                              tumDersler.add(
                                Ders(dersAdi, dersHarfDegeri, dersKredi,
                                    rastGeleRenkOlustur()),
                              );
                              ortalama = 0;
                              ortalamayiHesaplac();
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  items: dersKrediItems(),
                                  value: dersKredi,
                                  onChanged: (secilenKredi) {
                                    setState(() {
                                      dersKredi = secilenKredi;
                                    });
                                  },
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 4),
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.purple, width: 2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                            Container(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<double>(
                                    items: dersHarfDegerleriItems(),
                                    value: dersHarfDegeri,
                                    onChanged: (secilenHarf) {
                                      setState(() {
                                        dersHarfDegeri = secilenHarf;
                                      });
                                    }),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 4),
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.purple, width: 2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      border: BorderDirectional(
                        top:
                            BorderSide(color: Colors.purple.shade500, width: 2),
                        bottom:
                            BorderSide(color: Colors.purple.shade500, width: 2),
                      ),
                    ),

                    margin: EdgeInsets.all(10),
                    //color: Colors.blue,
                    child: Center(
                        child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: tumDersler.length == 0
                                  ? " Lutfen ders ekleyin."
                                  : "Ortalama : ",
                              style: TextStyle(
                                  fontSize: 40, color: Colors.black54)),
                          TextSpan(
                              text: tumDersler.length == 0
                                  ? " "
                                  : "${ortalama.toStringAsFixed(2)}",
                              style: TextStyle(
                                  fontSize: 40,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )),
                  ),
                ),
              ],
            ),
            flex: 1,
          ),
          Expanded(
            child: Container(
              // decoration: BoxDecoration(
              //   border: BorderDirectional(
              //     top: BorderSide(color: Colors.purple.shade500, width: 2),
              //     bottom: BorderSide(color: Colors.purple.shade500, width: 2),
              //   ),
              // ),
              //color: Colors.lightGreenAccent.shade700,
              child: ListView.builder(
                itemBuilder: _listeElemanlariniOlustur,
                itemCount: tumDersler.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<int>> dersKrediItems() {
    List<DropdownMenuItem<int>> krediler = [];
    for (int i = 1; i <= 10; i++) {
      // var aa = DropdownMenuItem<int>(
      //   value: i,
      //   child: Text("$i Kredi"),
      // );
      // krediler.add(aa);
      krediler.add(
        DropdownMenuItem<int>(
          value: i,
          child: Text(
            "$i Kredi",
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    }
    return krediler;
  }

  List<DropdownMenuItem<double>> dersHarfDegerleriItems() {
    List<DropdownMenuItem<double>> harfler = [];
    harfler.add(DropdownMenuItem(
      child: Text("AA", style: TextStyle(fontSize: 20)),
      value: 4,
    ));
    harfler.add(DropdownMenuItem(
      child: Text("BA", style: TextStyle(fontSize: 20)),
      value: 3.5,
    ));
    harfler.add(DropdownMenuItem(
      child: Text("BB", style: TextStyle(fontSize: 20)),
      value: 3,
    ));
    harfler.add(DropdownMenuItem(
      child: Text("CB", style: TextStyle(fontSize: 20)),
      value: 2.5,
    ));
    harfler.add(DropdownMenuItem(
      child: Text("CC", style: TextStyle(fontSize: 20)),
      value: 2,
    ));
    harfler.add(DropdownMenuItem(
      child: Text("DC", style: TextStyle(fontSize: 20)),
      value: 1.5,
    ));
    harfler.add(DropdownMenuItem(
      child: Text("DD", style: TextStyle(fontSize: 20)),
      value: 1,
    ));
    harfler.add(DropdownMenuItem(
      child: Text("FF", style: TextStyle(fontSize: 20)),
      value: 0,
    ));
    return harfler;
  }

  Widget _listeElemanlariniOlustur(BuildContext context, int index) {
    sayac++;
    debugPrint(sayac.toString());
    return Dismissible(
      key: Key(sayac.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        setState(() {
          tumDersler.removeAt(index);
          ortalamayiHesaplac();
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: tumDersler[index].renk, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.all(4),
        child: ListTile(
          leading: Icon(
            Icons.done,
            size: 36,
            color: tumDersler[index].renk,
          ),
          title: Text(tumDersler[index].ad),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            color: tumDersler[index].renk,
          ),
          subtitle: Text(tumDersler[index].kredi.toString() +
              " : Kredi ders not deger" +
              tumDersler[index].harfDegeri.toString()),
        ),
      ),
    );
  }

  void ortalamayiHesaplac() {
    double toplamNot = 0;
    double toplamKredi = 0;
    for (var oAnkiDers in tumDersler) {
      var kredi = oAnkiDers.kredi;
      var harfDegeri = oAnkiDers.harfDegeri;

      toplamNot = toplamNot + (harfDegeri * kredi);
      toplamKredi += kredi;
    }
    ortalama = toplamNot / toplamKredi;
  }

  Color rastGeleRenkOlustur() {
    return Color.fromARGB(150 + Random().nextInt(105), Random().nextInt(255),
        Random().nextInt(255), Random().nextInt(255));
  }
}

class Ders {
  String ad;
  double harfDegeri;
  int kredi;
  Color renk;

  Ders(this.ad, this.harfDegeri, this.kredi, this.renk);
}
