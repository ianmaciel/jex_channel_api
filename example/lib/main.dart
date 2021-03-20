// MIT License
//
// Copyright (c) 2021 Ian Koerich Maciel
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import 'package:flutter/material.dart';

import 'package:jex_channel_api/jex_channel_api.dart';

void main() {
  runApp(MyApp());
}

class LoginStatus extends StatefulWidget {
  @override
  _LoginStatusState createState() => _LoginStatusState();
}

class _LoginStatusState extends State<LoginStatus> {
  bool isLogged = false;
  JExChannel jExChannel = JExChannel();

  @override
  void initState() {
    super.initState();
    // Fill with your username / pasword.
    jExChannel.login('USERNAME', 'PASSWORD').then(loginCallback);
  }

  void loginCallback(bool result) {
    setState(() => isLogged = result);
  }

  @override
  Widget build(BuildContext context) => Container(
        child: Card(
          child: Text(isLogged ? 'Logged In' : 'Not Logged In'),
        ),
      );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'JExperts Demo',
        theme: ThemeData(
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'JExperts Channel API Demo'),
      );
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[LoginStatus()],
          ),
        ),
      );
}

// Login response headers
// HTTP/1.1 302 Found
// Server: nginx
// Date: Fri, 19 Mar 2021 02:28:01 GMT
// Content-Type: text/html;charset=ISO-8859-1
// Content-Length: 0
// Connection: keep-alive
// X-Content-Type-Options: nosniff
// X-XSS-Protection: 1; mode=block
// Cache-Control: no-cache, no-store, max-age=0, must-revalidate
// Pragma: no-cache
// Expires: 0
// Strict-Transport-Security: max-age=31536000 ; includeSubDomains
// X-Frame-Options: SAMEORIGIN
// Set-Cookie: JSESSIONID=D987AD272D5AC0201B523067CCE96A55; HttpOnly
// Set-Cookie: TIMEOUT_REQUEST=""
// Location: https://channel.certi.org.br/channel/projeto.do?action=projetosUsuario
// X-Frame-Options: SAMEORIGIN

// fetch("https://channel.certi.org.br/channel/dwr/call/plaincall/ApontamentoTimesheetAjax.getDadosAgendaPorComponenteAgenda.dwr", {
//   "headers": {
//     "accept": "*/*",
//     "accept-language": "pt,en-US;q=0.9,en;q=0.8",
//     "content-type": "text/plain",
//     "sec-ch-ua": "\"Google Chrome\";v=\"89\", \"Chromium\";v=\"89\", \";Not A Brand\";v=\"99\"",
//     "sec-ch-ua-mobile": "?0",
//     "sec-fetch-dest": "empty",
//     "sec-fetch-mode": "cors",
//     "sec-fetch-site": "same-origin"
//   },
//   "referrer": "https://channel.certi.org.br/channel/apontamento.do?action=novoApontamento",
//   "referrerPolicy": "strict-origin-when-cross-origin",
//   "body": "callCount=1\nwindowName=c0-param2\nc0-scriptName=ApontamentoTimesheetAjax\nc0-methodName=getDadosAgendaPorComponenteAgenda\nc0-id=0\nc0-e1=null:null\nc0-param0=Object_Object:{idUsuario:reference:c0-e1}\nc0-param1=date:1615170489736\nc0-param2=date:1615775289736\nbatchId=13\ninstanceId=0\npage=%2Fchannel%2Fapontamento.do%3Faction%3DnovoApontamento\nscriptSessionId=hK3V2fmV$8r6dsNE4oU7emZTWsn/k4Yj9xn-590R30Phc\n",
//   "method": "POST",
//   "mode": "cors",
//   "credentials": "include"
// });
