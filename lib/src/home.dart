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
        title: Text('Owl'),
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
          padding: EdgeInsets.all(15.0),
          child: StreamBuilder(
            stream: bloc.outDataStatus,
            builder: (contex, snap) {
              return Text(
                "${snap.data}",
                style: TextStyle(fontSize: 20.0, color: Colors.white),
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
          builder: (contex, snap) {
            return Container(
              padding: EdgeInsets.only(top: 10.0),
              child: Container(
                padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 5.0),
                margin: EdgeInsets.all(5.0),
                child: ListView.builder(
                  itemCount: snap.data == null ? 0 : bloc.listLenght(),
                  itemBuilder: (context, index) {
                    return buildCard(snap.data[index], bloc);
                  },
                ),
              ),
            );
          }),
    );
  }

  Widget buildCard(text, bloc) {
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
                      _newNamePlacaAlert(context, text);
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
                      bloc.showBubbleControl();
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

  _newNamePlacaAlert(BuildContext context, String text) {
    TextEditingController controller = new TextEditingController();

    AlertDialog ad = new AlertDialog(
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0)),
      content: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100.0)),
        height: 200.0,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
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
            Divider(),
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
                    onPressed: () {}),
              ],
            )
          ],
        ),
      ),
    );

    showDialog(context: context, child: ad);
  }
}
