/*
 * Copyright (c) 2021 Ian Koerich Maciel
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import 'package:requests/requests.dart';

class JExChannel {
  bool _isLogged = false;
  bool get isLogged => _isLogged;

  late final String baseAddress;
  JExChannel({this.baseAddress = 'https://channel.certi.org.br/channel'});

  Future<bool> login(String username, String password) async {
    const String endpoint = 'login.do';

    Response response = await Requests.post(
      '$baseAddress/$endpoint',
      body: <String, String>{'username': username, 'password': password},
      bodyEncoding: RequestBodyEncoding.FormURLEncoded,
    );

    _isLogged = response.success;
    return _isLogged;
  }

  Future<String> getAppointments() async {
    const String endpoint =
        'dwr/call/plaincall/ApontamentoTimesheetAjax.getDadosAgendaPorComponenteAgenda.dwr';

    if (!isLogged) {
      throw Exception('Unauthenticated');
    }

    Response response = await Requests.post(
      '$baseAddress/$endpoint',
      body:
          'callCount=1\\nwindowName=c0-param2\\nc0-scriptName=ApontamentoTimesheetAjax\\nc0-methodName=getDadosAgendaPorComponenteAgenda\\nc0-id=0\\nc0-e1=null:null\\nc0-param0=Object_Object:{idUsuario:reference:c0-e1}\\nc0-param1=date:1614564154087\\nc0-param2=date:1615168954087\\nbatchId=16\\ninstanceId=0\\npage=%2Fchannel%2Fapontamento.do%3Faction%3DnovoApontamento\\nscriptSessionId=hK3V2fmV\$8r6dsNE4oU7emZTWsn/606e9xn-IbkKjqMWr\\n',
      bodyEncoding: RequestBodyEncoding.PlainText,
    );

    return response.content();
  }
}
