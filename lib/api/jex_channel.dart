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

import 'package:html/dom.dart';
import 'package:html/parser.dart';

import 'package:http/http.dart' as http;
import 'package:jex_channel_api/api/response_parser.dart';
import 'package:jex_channel_api/core/dwr.dart';
import 'package:requests/requests.dart';

class JExChannel {
  bool _isLogged = false;
  String? scriptSessionId;
  String? jExpToken;
  String? jwt;

  bool get isLogged => _isLogged;

  late final String baseAddress;
  JExChannel({this.baseAddress = 'https://channel.certi.org.br/channel'});

  Future<void> _addCookie(String name, String value) async {
    CookieJar cookies =
        await Requests.getStoredCookies(Requests.getHostname(baseAddress));
    cookies[name] = Cookie(name, value);
    await Requests.setStoredCookies(Requests.getHostname(baseAddress), cookies);
  }

  Future<bool> login(String username, String password) async {
    const String endpoint = 'login.do?action=logar';

    http.Response response = await Requests.post(
      '$baseAddress/$endpoint',
      queryParameters: <String, dynamic>{
        'action': 'logar',
        'url': 'Lw==',
      },
      body: <String, dynamic>{
        'username': username,
        'password': password,
        'jexptoken': null,
      },
      //bodyEncoding: RequestBodyEncoding.FormURLEncoded,
    );

    // Parse erros
    _isLogged = response.success && !_hasErrors(response.body);
    if (!_isLogged) {
      return false;
    }

    ResponseParser responseParser = ResponseParser(await _generateId());
    String sessionId = responseParser.parse();
    scriptSessionId = Dwr(sessionId).scriptSessionId;
    await _addCookie('DWRSESSIONID', sessionId);
    return _isLogged;
  }

  Element? _errorElement(String body) {
    Document doc = parse(body);
    List<Element> elements =
        doc.getElementsByTagName('col-md-12 pll msg-error');
    return elements.isEmpty ? null : elements.first;
  }

  bool _hasErrors(String body) {
    if (_errorElement(body) == null) {
      return false;
    }
    return true;
  }

  String _parseErrorMessage(String body) {
    // Look for "col-md-12 pll msg-error".
    if (!_hasErrors(body)) {
      throw Exception(
          'Should not try to parse error message when there are no error.');
    }
    Element element = _errorElement(body)!;
    return element.firstChild.toString();
  }

  Future<String> _generateId() async {
    const String endpoint = 'dwr/call/plaincall/__System.generateId.dwr';

    http.Response response = await Requests.post(
      '$baseAddress/$endpoint',
      body: '''callCount=1
c0-scriptName=__System
c0-methodName=generateId
c0-id=0
batchId=0
instanceId=0
page=%2Fchannel%2Fapontamento.do%3Faction%3DnovoApontamento
scriptSessionId=
windowName=c0-param2
''',
      bodyEncoding: RequestBodyEncoding.PlainText,
    );
    return response.content();
  }

  Future<String> getProjects() async {
    const String endpoint = 'projeto.do?action=projetosUsuario';

    if (!isLogged) {
      throw Exception('Unauthenticated');
    }

    http.Response response = await Requests.post(
      '$baseAddress/$endpoint',
      body: 'action: projetosUsuario',
      //  'callCount=1\\nwindowName=c0-param2\\nc0-scriptName=ApontamentoTimesheetAjax\\nc0-methodName=getDadosAgendaPorComponenteAgenda\\nc0-id=0\\nc0-e1=null:null\\nc0-param0=Object_Object:{idUsuario:reference:c0-e1}\\nc0-param1=date:1614564154087\\nc0-param2=date:1615168954087\\nbatchId=16\\ninstanceId=0\\npage=%2Fchannel%2Fapontamento.do%3Faction%3DnovoApontamento\\nscriptSessionId=$scriptSessionId\\n',
      bodyEncoding: RequestBodyEncoding.PlainText,
    );

    return response.content();
  }

  Future<String> getProjectAjax() async {
    const String endpoint =
        'dwr/call/plaincall/ProjetoAjax.listarPorUsuarioAreaApontamento.dwr';

    if (!isLogged) {
      throw Exception('Unauthenticated');
    }
    http.Response response = await Requests.post(
      '$baseAddress/$endpoint',
      headers: <String, String>{
        'accept': '*/*',
        'accept-language': 'pt,en-US;q=0.9,en;q=0.8',
        'content-type': 'text/plain',
        'Origin': 'https://channel.certi.org.br',
        'sec-ch-ua':
            'Google Chrome";v="89", "Chromium";v="89", ";Not A Brand";v="99"',
        'sec-ch-ua-mobile': '?0',
        'sec-ch-ua-platform': 'Linux',
        'Sec-Fetch-Dest': 'empty',
        'Sec-fetch-Mode': 'cors',
        'Sec-Fetch-Site': 'same-origin',
        'Referer':
            'https://channel.certi.org.br/channel/apontamento.do?action=novoApontamento',
        'User-Agent':
            'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36',
      },
      body: '''callCount=1
windowName=c0-param2
c0-scriptName=ApontamentoTimesheetAjax
c0-methodName=getDadosAgendaPorComponenteAgenda
c0-id=0
c0-e1=null:null
c0-param0=Object_Object:{idUsuario:reference:c0-e1}
c0-param1=date:1681042482791
c0-param2=date:1681647282791
batchId=3
instanceId=0
page=%2Fchannel%2Fapontamento.do%3Faction%3DnovoApontamento
scriptSessionId=$scriptSessionId
''',
      bodyEncoding: RequestBodyEncoding.PlainText,
      withCredentials: true,
    );

    ResponseParser responseParser = ResponseParser(response.content());
    return responseParser.parse();
  }

  Future<String> checkAppointmentConflict() async {
    const String endpoint =
        'dwr/call/plaincall/ApontamentoAjax.verificarApontamentoSobreposto.dwr';

    if (!isLogged) {
      throw Exception('Unauthenticated');
    }
    http.Response response = await Requests.post(
      '$baseAddress/$endpoint',
      headers: <String, String>{
        'accept': '*/*',
        'accept-language': 'pt,en-US;q=0.9,en;q=0.8',
        'content-type': 'text/plain',
        'Origin': 'https://channel.certi.org.br',
        'sec-ch-ua':
            'Google Chrome";v="89", "Chromium";v="89", ";Not A Brand";v="99"',
        'sec-ch-ua-mobile': '?0',
        'sec-ch-ua-platform': 'Linux',
        'Sec-Fetch-Dest': 'empty',
        'Sec-fetch-Mode': 'cors',
        'Sec-Fetch-Site': 'same-origin',
        'Referer':
            'https://channel.certi.org.br/channel/apontamento.do?action=novoApontamento',
        'User-Agent':
            'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36',
      },
      body: '''callCount=1
windowName=c0-param2
c0-scriptName=ApontamentoAjax
c0-methodName=verificarApontamentoSobreposto
c0-id=0
c0-param0=string:13%2F04%2F2023
c0-param1=string:08%3A01
c0-param2=string:09%3A02
c0-param3=string:
c0-param4=string:
batchId=31
instanceId=0
page=%2Fchannel%2Fapontamento.do%3Faction%3DnovoApontamento
scriptSessionId=$scriptSessionId
''',
      bodyEncoding: RequestBodyEncoding.PlainText,
      withCredentials: true,
    );

    ResponseParser responseParser = ResponseParser(response.content());
    return responseParser.parse();
  }

  Future<String> createAppointment() async {
    const String endpoint = 'apontamento.do';

    if (!isLogged) {
      throw Exception('Unauthenticated');
    }
    http.Response response = await Requests.post(
      '$baseAddress/$endpoint',
      headers: <String, String>{
        'accept': '*/*',
        'accept-language': 'pt,en-US;q=0.9,en;q=0.8',
        'content-type': 'application/x-www-form-urlencoded',
        'Origin': 'https://channel.certi.org.br',
        'sec-ch-ua':
            'Google Chrome";v="89", "Chromium";v="89", ";Not A Brand";v="99"',
        'sec-ch-ua-mobile': '?0',
        'sec-ch-ua-platform': 'Linux',
        'Sec-Fetch-Dest': 'empty',
        'Sec-fetch-Mode': 'cors',
        'Sec-Fetch-Site': 'same-origin',
        'Referer':
            'https://channel.certi.org.br/channel/apontamento.do?action=novoApontamento',
        'User-Agent':
            'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36',
      },
      body: <String, String?>{
        'apontamento.id': '',
        'participanteSelecionado': '',
        'destino': 'timesheet',
        'key': '-1',
        'idUsuario': '',
        'retornaHomologacao': '',
        'superiorStaff': '',
        'action': 'salvar',
        'destinoForward': '',
        'IEA': '',
        'apontamento.comentario': 'teste',
        'tipoApontamento': '2',
        'areaProjeto': '53',
        'apontamento.projetosSelecionado': '0',
        'centro_de_custo': '',
        'apontamento.idTipoAtividadeProjeto': '-1',
        'apontamento.notificacaoSelecionada': '0',
        'apontamento.idTarefa': '0',
        'areaOperacao': '53',
        'apontamento.idOperacao': '0',
        'apontamento.clientesSelecionado': '0',
        'apontamento.idTipoAtividadeOperacao': '0',
        'apontamento.idPassoWorkflow': '0',
        'apontamento.idTicket': '0',
        'apontamento.idTarefaTicket': '0',
        'apontamento.clienteSelecionadoAvulso': '1',
        'apontamento.tipoOperacaoSelecionado': '0',
        'apontamento.idTipoAtividadeAvulso': '-1',
        'apontamento.isHoraExtraSelecionada': '0',
        'data': '13/04/2023',
        'apontamento.horaInicio': '08:01',
        'apontamento.horaFim': '09:05',
        'apontamento.duracao': '01:04',
        'jexptoken': '$jExpToken',
      },
      bodyEncoding: RequestBodyEncoding.FormURLEncoded,
      withCredentials: true,
    );

    return response.body.toString();
  }

  Future<void> getJexpToken() async {
    const String endpoint = 'apontamento.do';

    if (!isLogged) {
      throw Exception('Unauthenticated');
    }
    http.Response response = await Requests.get(
      '$baseAddress/$endpoint',
      queryParameters: {
        'action': 'novoApontamento',
      },
      headers: <String, String>{
        'accept': '*/*',
        'accept-language': 'pt,en-US;q=0.9,en;q=0.8',
        'Origin': 'https://channel.certi.org.br',
        'sec-ch-ua':
            'Google Chrome";v="89", "Chromium";v="89", ";Not A Brand";v="99"',
        'X-Content-Type-Options': '?0',
        'sec-ch-ua-platform': 'Linux',
        'Sec-Fetch-Dest': 'document',
        'Sec-fetch-Mode': 'navigate',
        'Sec-Fetch-Site': 'same-origin',
        'Sec-Fetch-User': '?1',
        'Referer': 'https://channel.certi.org.br/channel/login.do',
        'User-Agent':
            'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36',
      },
      bodyEncoding: RequestBodyEncoding.FormURLEncoded,
      withCredentials: true,
    );

    // Find jexptoken:
    jExpToken = _parseJexpToken(response.body.toString());

    // Find jwt:
    jwt = _parseJwt(response.body.toString());

    if (jExpToken == null ||
        jExpToken!.isEmpty ||
        jwt == null ||
        jwt!.isEmpty) {
      throw Exception('Invalid token. JEXPTOKEN=$jExpToken, JWP=$jwt');
    }
  }

  /// Parse the JEXPTOKEN token from html file.
  /// the token is included in a script inside the HTML with the following pattern:
  /// ```
  /// 	var JEXPTOKEN =  "AABBCCCDDE";
  /// ```
  String _parseJexpToken(String html) => html
      .split('\n')
      .where((str) => str.startsWith('	var JEXPTOKEN = '))
      .first
      .split('"')
      .elementAt(1);

  /// Parse the jwt token from html file.
  /// the JWT token is included in a script inside the HTML with the following pattern:
  /// ```
  /// 		var JWT = "AABBCCCDDE";
  /// ```
  String _parseJwt(String html) => html
      .split('\n')
      .where((str) => str.startsWith('	var JWT = '))
      .first
      .split('"')
      .elementAt(1);

  /// Não está funcionando.
  Future<String> getAppointments() async {
    const String endpoint =
        'dwr/call/plaincall/ApontamentoTimesheetAjax.getDadosAgendaPorComponenteAgenda.dwr';

    if (!isLogged) {
      throw Exception('Unauthenticated');
    }

    http.Response response = await Requests.post(
      '$baseAddress/$endpoint',
      headers: <String, String>{
        'accept': '*/*',
        'accept-language': 'pt,en-US;q=0.9,en;q=0.8',
        'content-type': 'text/plain',
        'Origin': 'https://channel.certi.org.br',
        'Referer':
            'https://channel.certi.org.br/channel/apontamento.do?action=novoApontamento',
        'sec-ch-ua':
            'Google Chrome";v="89", "Chromium";v="89", ";Not A Brand";v="99"',
        'sec-ch-ua-mobile': '?0',
        'sec-ch-ua-platform': 'Linux',
        'Sec-Fetch-Dest': 'empty',
        'Sec-fetch-Mode': 'cors',
        'Sec-Fetch-Site': 'same-origin',
      },
      body: '''callCount=1
windowName=c0-param2
c0-scriptName=ApontamentoTimesheetAjax
c0-methodName=getDadosAgendaPorComponenteAgenda
c0-id=0
c0-e1=null:null
c0-param0=Object_Object:{idUsuario:reference:c0-e1}
c0-param1=date:1681060133380
c0-param2=date:1681664933380
batchId=20
instanceId=0
page=%2Fchannel%2Fapontamento.do%3Faction%3DnovoApontamento
scriptSessionId=$scriptSessionId
          ''',
      bodyEncoding: RequestBodyEncoding.PlainText,
      withCredentials: true,
    );

    return response.content();
  }
}
