import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:async';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:rxdart/rxdart.dart';

class HomeController implements BlocBase {
  static const platform = const MethodChannel('erick.com.smartowl');

  List<String> _onlineBoards = new List<String>();

  MqttClient client = MqttClient('iot.eclipse.org', '');

  HomeController() {
    platform.setMethodCallHandler(_handleMethod);
    _mqttConnect();
  }

  var _dataStatusController = BehaviorSubject<String>(seedValue: "Aguarde...");

  Stream<String> get outDataStatus => _dataStatusController.stream;
  Sink<String> get inDataStatus => _dataStatusController.sink;

  var _dataChangeNameController = BehaviorSubject<String>(seedValue: "");

  Stream<String> get outChangeNameStatus => _dataChangeNameController.stream;
  Sink<String> get inChangeNameStatus => _dataChangeNameController.sink;

  var _dataOnlineBoardsController = BehaviorSubject<List<String>>();

  Stream<List<String>> get ouDataOnlineBoardsController =>
      _dataOnlineBoardsController.stream;
  Sink<List<String>> get _inDataOnlineBoardsController =>
      _dataOnlineBoardsController.sink;

  void ChangeNameText(String s) {
    inChangeNameStatus.add(s);
  }

  Future<void> listBoardReset() async {
    _onlineBoards.clear();
    _inDataOnlineBoardsController.add(_onlineBoards);
    print('Disconnecting');
    sendDataStatus('Disconnecting');
    client.disconnect();
    await MqttUtilities.asyncSleep(2);
    try {
      print('Connecting...');
      sendDataStatus('Connecting...');
      client = MqttClient('iot.eclipse.org', '');
      _mqttConnect();
    } on Exception catch (e) {
      print(e.toString());
      sendDataStatus('Erro: $e');
      client.disconnect();
    }
  }

  Future<bool> showBubbleControl(String boardName) async =>
      await platform.invokeMethod('StartBubble', boardName);

  void sendListOnlineBoards(String s) {
    if (!_onlineBoards.contains(s) && s.length >= 3) {
      _onlineBoards.add(s);
    }
    _inDataOnlineBoardsController.add(_onlineBoards);
  }

  void sendDataStatus(dynamic c) {
    inDataStatus.add(c);
  }

  Future<void> BoardChangeName(String boardName, String newName) async {
    print("###### DEBUG ###### ${boardName}");
    print("###### DEBUG ###### ${newName}");

    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    String pubTopic = 'smart-owl/setname/${boardName}';
    builder.addString(newName);
    client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload);
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    print(
        "******************** _handleMethod ****************** ${call.arguments}");

    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    String pubTopic = 'smart-owl/command/${call.arguments}';

    switch (call.method) {
      case "button_left":
        builder.addString(call.method);
        client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload);
        break;
      case "button_right":
        builder.addString(call.method);
        client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload);
        break;
      case "button_up":
        builder.addString(call.method);
        client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload);
        break;
      case "button_down":
        builder.addString(call.method);
        client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload);
        break;
      case "button_center":
        builder.addString(call.method);
        client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload);
        break;
      case "button_save":
        builder.addString(call.method);
        client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload);
        break;

      case "StartBubble":
        print(call.arguments);
        // sendData(call.arguments);
        return new Future.value(call.arguments);
    }
  }

  Future<int> _mqttConnect() async {
    await MqttUtilities.asyncSleep(3);

    client.logging(on: false);
    client.keepAlivePeriod = 20;

    MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier('Mqtt_MyClientUniqueId')
        .keepAliveFor(20) // Must agree with the keep alive set above or not set
        .withWillTopic(
            'willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    sendDataStatus('Conectando, aguarde...');
    client.connectionMessage = connMess;

    try {
      await client.connect();
    } on Exception catch (e) {
      sendDataStatus('Erro: $e');
      client.disconnect();
    }

    /// Check we are connected
    if (client.connectionStatus.state == ConnectionState.connected) {
      sendDataStatus('Conectado');
    } else {
      /// Use status here rather than state if you also want the broker return code.
      sendDataStatus(
          'Falha: ${client.connectionStatus}');
      client.disconnect();
    }

    /// Ok, lets try a subscription
    const String topic = 'smart-owl/online-boards'; // Not a wildcard topic
    client.subscribe(topic, MqttQos.atMostOnce);

    /// The client has a change notifier object(see the Observable class) which we then listen to to get
    /// notifications of published updates to each subscribed topic.
    client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload;
      final String pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      print('TOPIC >>> ${c[0].topic} PAYLOAD >>> $pt');
      sendListOnlineBoards(pt);
    });

    /// Lets publish to our topic
    // Use the payload builder rather than a raw buffer
    // print('Publishing our topic');

    /// Our known topic to publish to
    const String pubTopic = 'smart-owl/online-boards';
    // final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    // builder.addString('camera de seguranca 1');

    /// Subscribe to it
    client.subscribe(pubTopic, MqttQos.exactlyOnce);

    /// Publish it
    // client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload);
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  BuildContext context;
}
