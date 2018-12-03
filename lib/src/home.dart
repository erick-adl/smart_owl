import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:smart_owl/src/home-controller.dart';

class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final HomeController bloc = BlocProvider.of<HomeController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Owl'),
        centerTitle: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          bloc.mqttReset();
        },
        child: Icon(Icons.refresh),
        elevation: 3.0,
        backgroundColor: Colors.red,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
          child: StreamBuilder(
            stream: bloc.outDataStatus,
            builder: (contex, snap) {
              return Text(
                "${snap.data}",
                style: TextStyle(fontSize: 15.0, color: Colors.white),
              );
            },
          ),
          height: 50.0,
        ),
        shape: CircularNotchedRectangle(),
        color: Colors.red,
      ),
      body: StreamBuilder(
          stream: bloc.ouDataOnlineBoardsController,
          builder: (contex, AsyncSnapshot<List<String>> snap) {
            if (!snap.hasData || snap.data.length == 0) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              );
            } else if (snap.hasError) {
              return Center(child: Text("Erro ao conectar..."));
            } else {
              return Container(
                padding: EdgeInsets.only(top: 10.0),
                child: Container(
                  padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 5.0),
                  margin: EdgeInsets.all(5.0),
                  child: ListView.builder(
                    itemCount: snap.data == null ? 0 : snap.data.length,
                    itemBuilder: (context, index) {
                      return buildCard(snap.data[index], bloc);
                    },
                  ),
                ),
              );
            }
          }),
    );
  }

  Widget buildCard(text, HomeController bloc) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 3.0),
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey),
      padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 5.0),
      margin: EdgeInsets.all(5.0),
      child: Column(
        children: <Widget>[
          Text(
            text,
            style: TextStyle(fontSize: 26.0, color: Colors.black),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 40.0,
                  child: RaisedButton(
                    child: Text(
                      "Editar nome",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0)),
                    onPressed: () {
                      _newNamePlacaAlert(context, text, bloc);
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 40.0,
                  child: RaisedButton(
                    child: Text(
                      "Iniciar",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0)),
                    onPressed: () {
                      bloc.showBubbleControl(text.toString());
                    },
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  _newNamePlacaAlert(BuildContext context, String text, HomeController bloc) {
    TextEditingController controller = new TextEditingController();

    AlertDialog ad = new AlertDialog(
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0)),
      content: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100.0)),
        height: 210.0,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(4.0),
              child: Text(
                text,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.withOpacity(0.5),
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              margin:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 1.0),
              child: Row(
                children: <Widget>[
                  new Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Novo nome da placa...",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton(
                    color: Colors.red,
                    child: Text(
                      "Salvar",
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                    textColor: Colors.white,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0)),
                    onPressed: () async {
                      bloc.BoardChangeName(text, controller.text);
                      bloc.ChangeNameText();
                      print(text);
                      print(controller.text);
                      await Future.delayed(
                          const Duration(seconds: 2), () => "2");
                      bloc.mqttReset();
                      Navigator.pop(context);
                    }),
              ],
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: StreamBuilder(
                stream: bloc.outChangeNameStatus,
                builder: (contex, snap) {
                  return Text(
                    "${snap.data}",
                    style: TextStyle(fontSize: 15.0, color: Colors.red),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );

    showDialog(context: context, child: ad);
  }
}
