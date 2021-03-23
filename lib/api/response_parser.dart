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

import 'dart:convert';
import 'package:flutter/cupertino.dart';

import 'package:jex_channel_api/model/jex_model.dart';

/// Channel returns a JavaScript code inside the response body.
///
/// This class parse the response to return desired data.
///
/// Response example;
/// throw 'allowScriptTagRemoting is false.';
/// (function(){
/// var r=window.dwr._[0];
/// //#DWR-INSERT
/// //#DWR-REPLY
/// r.handleCallback("16","0",{dias:[{diferencaHorasFormatado:"00:00",isDiaUtil:false,diferencaHoras:0.0,nomeDiaSemana:"Dom",apontado:0.0,horasRecurso:0.0,dataRecursoHabilitada:false,dia:"28/02/2021"},{diferencaHorasFormatado:"08:00",isDiaUtil:true,diferencaHoras:8.0,eventos:[],nomeDiaSemana:"Seg",apontado:0.0,horasRecurso:8.0,dataRecursoHabilitada:true,dia:"01/03/2021"},{diferencaHorasFormatado:"08:00",isDiaUtil:true,diferencaHoras:8.0,eventos:[],nomeDiaSemana:"Ter",apontado:0.0,horasRecurso:8.0,dataRecursoHabilitada:true,dia:"02/03/2021"},{diferencaHorasFormatado:"08:00",isDiaUtil:true,diferencaHoras:8.0,eventos:[],nomeDiaSemana:"Qua",apontado:0.0,horasRecurso:8.0,dataRecursoHabilitada:true,dia:"03/03/2021"},{diferencaHorasFormatado:"08:00",isDiaUtil:true,diferencaHoras:8.0,eventos:[],nomeDiaSemana:"Qui",apontado:0.0,horasRecurso:8.0,dataRecursoHabilitada:true,dia:"04/03/2021"},{diferencaHorasFormatado:"08:00",isDiaUtil:true,diferencaHoras:8.0,eventos:[],nomeDiaSemana:"Sex",apontado:0.0,horasRecurso:8.0,dataRecursoHabilitada:true,dia:"05/03/2021"},{diferencaHorasFormatado:"00:00",isDiaUtil:false,diferencaHoras:0.0,nomeDiaSemana:"S\u00E1b",apontado:0.0,horasRecurso:0.0,dataRecursoHabilitada:false,dia:"06/03/2021"}],inicioFormatado:"28/02/2021",fimFormatado:"07/03/2021"});
/// })();
class ResponseParser {
  final String jsCode;
  ResponseParser(this.jsCode);

  @visibleForTesting
  List<String> getLines() => jsCode.split('\n');

  @visibleForTesting
  String getHandleCallbackLine(List<String> lines) =>
      lines.firstWhere((String line) => line.startsWith('r.handleCallback('));

  @visibleForTesting
  String extractBodyContent(String cbLine) =>
      cbLine.substring(cbLine.indexOf('(') + 1, cbLine.lastIndexOf(')'));

  @visibleForTesting
  JExModel parseJsonBody(String jsObject) => JExModel.fromString(jsObject);

  @visibleForTesting
  String decodeIso8859_1(String isoString) =>
      latin1.decode(isoString.runes.toList());

  @visibleForTesting
  List<String> getHandleCallbackParameters(String bodyContent) {
    List<String> parameters = <String>[];

    // Extract the first two elements ""16","0", ..."
    // Get the first parameter and remove it from bodyContent.
    int nextComma = bodyContent.indexOf(',');
    parameters.add(bodyContent.substring(0, nextComma));
    bodyContent = bodyContent.substring(nextComma + 1);

    // Extract the second parameter and remove from bodyContent.
    nextComma = bodyContent.indexOf(',');
    parameters.add(bodyContent.substring(0, nextComma));
    bodyContent = bodyContent.substring(nextComma + 1);

    // Now, everything belogs to 3rd parameter.
    parameters.add(bodyContent);

    return parameters;
  }

  JExModel parse() {
    List<String> lines = getLines();
    String handleCallbackLine = getHandleCallbackLine(lines);
    String bodyContent = extractBodyContent(handleCallbackLine);
    List<String> parameters = getHandleCallbackParameters(bodyContent);

    // The JExperts API use ISO-8859-1
    String jsObjectBody = decodeIso8859_1(parameters[2]);
    return parseJsonBody(jsObjectBody);
  }
}
