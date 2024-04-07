import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:smarthome/Widget/widgets.dart';

class MqttService with ChangeNotifier {
  // MqttServerClient? client;

  final ValueNotifier<String> data = ValueNotifier<String>("");
  late MqttServerClient client;

  Future<void> connectToMqttServer() async {
    client = MqttServerClient('172.187.230.56', '1013');
    client.port = 1883;
    client.logging(on: true);

    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;
    client.onSubscribeFail = onSubscribeFail;

    try {
      await client.connect();
    } catch (e) {
      showToast('Exception: $e');
      print('Exceptionnnnn: $e');
      client.disconnect();
    }
  }

  void onConnected() {
    showToast('Connected to MQTT server');
    print("connect");
  }

  void onDisconnected() {
    showToast('Disconnected from MQTT server');
    print("disconnect");
  }

  void subscribed(String topic, void Function(String) onData) {
    if (client != null &&
        client.connectionStatus!.state == MqttConnectionState.connected) {
      client.subscribe(topic, MqttQos.atMostOnce);
      client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
        final pt =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        print("Topicccc: ${c[0].topic}, payload: $pt");
        onData(pt);
      });
    }
  }

  void onSubscribed(String topics) {
    client.subscribe(topics, MqttQos.atMostOnce);
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      print('Received message: topic is ${c[0].topic}, payload is $pt');
    });
  }

  void onSubscribeFail(String topic) {
    print('MQTT_LOGS:: Failed to subscribe $topic');
  }

  Future<void> publishMessage(String topic, String message) async {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
    print("Published message: $message to topic: $topic");
  }
}
