import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'custom_render_message_widget.dart';
import 'service/socket_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool status = false;
  String? ipLocal;
  Socket? socketData;
  final TextEditingController ipAddress = TextEditingController();
  final TextEditingController message = TextEditingController();

  @override
  void initState() {
    super.initState();
    SocketService.getIpAddress().then((ip) async {
      setState(() {
        ipLocal = ip;
      });
      if (ip != null) {
        SocketService.initialize(ip);
        return CustomRenderMessageInfo.render(
          context: context, 
          color: Colors.orange,
          message: "Servidor iniciado!"
        );                                
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return ValueListenableBuilder(
      valueListenable: SocketService.message,
      builder: (_, value, __) {
        return Scaffold(
          backgroundColor: value == "azul" ? 
            Colors.blue : 
              value == "laranja" ? Colors.orange :
              value == "preto" ? Colors.black :
              value == "vermelho" ? Colors.red : Colors.white,
          body: SafeArea(
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: size.height * .04),
                  child: Text(
                    ipLocal ?? "",
                    style: TextStyle(
                      fontSize: size.height * .035,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ValueListenableBuilder<String>(
                  valueListenable: SocketService.message, 
                  builder: (_, value, __) => Align(
                  alignment: Alignment.center,
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: size.height * .035,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: size.height * .03,
                      horizontal: size.width * .04
                    ),
                    child: Visibility(
                      visible: status,
                      replacement: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          TextField(
                            style: TextStyle(
                              fontSize: size.height * .022,
                              color: Colors.black,
                              fontWeight: FontWeight.w600
                            ),
                            controller: ipAddress,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(15)
                            ],
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: size.height * .022,
                                fontWeight: FontWeight.w700,
                                color: Colors.black
                              ),
                              hintText: "IP Socket - 1",
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  color: Colors.black
                                )
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  color: Colors.black
                                )
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  color: Colors.black
                                )
                              )
                            ),
                          ),
                          SizedBox(height: size.height * .02),
                          SizedBox(
                            height: size.height * .1,
                            width: size.width,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (ipAddress.text.isEmpty) {
                                  CustomRenderMessageInfo.render(
                                    context: context, 
                                    message: "Informe um IP"
                                  );
                                } else {
                                  SocketService.connetSocket(ipAddress.text)
                                  .then((socket) {
                                    setState(() {
                                      status = true;
                                      socketData = socket;
                                    });
                                    return CustomRenderMessageInfo.render(
                                      context: context, 
                                      color: Colors.green,
                                      message: "Conectado!"
                                    );
                                  })
                                  .catchError((e) {
                                    return CustomRenderMessageInfo.render(
                                      context: context, 
                                      message: "Nenhum servidor ou IP inválido!"
                                    );
                                  });
                                }
                              }, 
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                )
                              ),
                              child: Text(
                                "Conectar",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.height * .02,
                                  fontWeight: FontWeight.w600
                                ),
                              )
                            ),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          SizedBox(
                            height: size.height * .14,
                            child: TextField(
                              maxLines: null,
                              minLines: 3,
                              style: TextStyle(
                                fontSize: size.height * .022,
                                color: Colors.black,
                                fontWeight: FontWeight.w600
                              ),
                              controller: message,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                  fontSize: size.height * .022,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black
                                ),
                                hintText: "Escreva algo...",
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    color: Colors.black
                                  )
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    color: Colors.black
                                  )
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    color: Colors.black
                                  )
                                )
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * .02),
                          SizedBox(
                            height: size.height * .1,
                            width: size.width,
                            child: ElevatedButton(
                              onPressed: () async {
                                socketData?.write(message.text);
                                message.clear();
                              }, 
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                )
                              ),
                              child: Text(
                                "Enviar",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.height * .02,
                                  fontWeight: FontWeight.w600
                                ),
                              )
                            ),
                          )
                        ],
                      )
                    )
                  ),
                )
              ],
            ),
          )
        );
      },
    );
  }
}