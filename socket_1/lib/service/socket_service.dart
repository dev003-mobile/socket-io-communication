import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';

class SocketService {
  static ValueNotifier<String> message = ValueNotifier<String>("");

  static Future<String?> getIpAddress() async {
    final info = NetworkInfo();
    return await info.getWifiIP();
  }

  static Future<Socket> connetSocket(String ip) async {
    return await Socket.connect(ip, 4040);
  }

  static Future<void> initialize(String ip) async {
    await ServerSocket.bind(ip, 4041).then((serverSocket) {
      log("Start server...");
      serverSocket.listen((socket) {
        socket.listen((event) {
          message.value = String.fromCharCodes(event);
          log("Message: $message");
        });
      });
    });
  }
}
