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

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:jex_channel_api/model/jex_day_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'jex_model.g.dart';

///
/// Json model JExperts API - body response
///
/// This class uses generated sources (json_serializable). Before compiling or
/// running you must generate the sources. Read more about here:
/// https://flutter.dev/docs/development/data-and-backend/json
///
///   `flutter pub run build_runner build`
///   or
///   `flutter pub run build_runner watch`
@JsonSerializable()
class JExModel {
  // Example of data to be parsed:
  // {
  //   "dias":[
  //     {
  //       "diferencaHorasFormatado":"00:00",
  //       "isDiaUtil":false,
  //       "diferencaHoras":0.0,
  //       "nomeDiaSemana":"Dom",
  //       "apontado":0.0,
  //       "horasRecurso":0.0,
  //       "dataRecursoHabilitada":false,
  //       "dia":"28/02/2021"
  //     },
  //     {
  //       "diferencaHorasFormatado":"08:00",
  //       "isDiaUtil":true,
  //       "diferencaHoras":8.0,
  //       "eventos":[

  //       ],
  //       "nomeDiaSemana":"Seg",
  //       "apontado":0.0,
  //       "horasRecurso":8.0,
  //       "dataRecursoHabilitada":true,
  //       "dia":"01/03/2021"
  //     },
  //     {
  //       "diferencaHorasFormatado":"08:00",
  //       "isDiaUtil":true,
  //       "diferencaHoras":8.0,
  //       "eventos":[

  //       ],
  //       "nomeDiaSemana":"Ter",
  //       "apontado":0.0,
  //       "horasRecurso":8.0,
  //       "dataRecursoHabilitada":true,
  //       "dia":"02/03/2021"
  //     },
  //     {
  //       "diferencaHorasFormatado":"08:00",
  //       "isDiaUtil":true,
  //       "diferencaHoras":8.0,
  //       "eventos":[

  //       ],
  //       "nomeDiaSemana":"Qua",
  //       "apontado":0.0,
  //       "horasRecurso":8.0,
  //       "dataRecursoHabilitada":true,
  //       "dia":"03/03/2021"
  //     },
  //     {
  //       "diferencaHorasFormatado":"08:00",
  //       "isDiaUtil":true,
  //       "diferencaHoras":8.0,
  //       "eventos":[

  //       ],
  //       "nomeDiaSemana":"Qui",
  //       "apontado":0.0,
  //       "horasRecurso":8.0,
  //       "dataRecursoHabilitada":true,
  //       "dia":"04/03/2021"
  //     },
  //     {
  //       "diferencaHorasFormatado":"08:00",
  //       "isDiaUtil":true,
  //       "diferencaHoras":8.0,
  //       "eventos":[

  //       ],
  //       "nomeDiaSemana":"Sex",
  //       "apontado":0.0,
  //       "horasRecurso":8.0,
  //       "dataRecursoHabilitada":true,
  //       "dia":"05/03/2021"
  //     },
  //     {
  //       "diferencaHorasFormatado":"00:00",
  //       "isDiaUtil":false,
  //       "diferencaHoras":0.0,
  //       "nomeDiaSemana":"S\u00E1b",
  //       "apontado":0.0,
  //       "horasRecurso":0.0,
  //       "dataRecursoHabilitada":false,
  //       "dia":"06/03/2021"
  //     }
  //   ],
  //   "inicioFormatado":"28/02/2021",
  //   "fimFormatado":"07/03/2021"
  // }

  @JsonKey(name: 'dias')
  final List<JExDayModel> days;

  @JsonKey(name: 'inicioFormatado', fromJson: parseDateTime)
  final DateTime formatedStart;

  @JsonKey(name: 'fimFormatado', fromJson: parseDateTime)
  final DateTime formatedEnd;

  static DateTime parseDateTime(String date) =>
      DateFormat('dd/MM/yyyy').parse(date);

  ///
  /// The JExperts answer is a JS-Object, not a JSON.
  /// This method add quotes to JS-Object (stringify), to be JSON compliant.
  ///
  @visibleForTesting
  static String stringify(String jsObject) {
    // To undertand the regexp, consult https://regexr.com/5p7cs
    // (?!\b\d+\b) negative lookahead: do not match numbers (0, 00, 123)
    // (?!\b\d+\b) negative lookahead: do not match true
    // (?!\b\d+\b) negative lookahead: do not match false
    // (\b[A-zÀ-ú]+\b) match expression: \b matches a word boundary, where
    //                 word characters might be [A-zÀ-ú]+ lowercase and
    //                 uppercase characters with accents.
    String newString = jsObject.replaceAllMapped(
        RegExp(r'(?!\b\d+\b)(?!\btrue\b)(?!\bfalse\b)(\b[A-zÀ-ú]+\b)'),
        (Match match) => '"${match.group(0)}"');
    // Remove double quotes.
    newString =
        newString.replaceAllMapped(RegExp(r'("")'), (Match match) => '"');
    return newString;
  }

  JExModel({
    required this.days,
    required this.formatedStart,
    required this.formatedEnd,
  });
  factory JExModel.fromString(String json) {
    String stirngifyed = stringify(json);
    return JExModel.fromJson(jsonDecode(stirngifyed));
  }
  factory JExModel.fromJson(Map<String, dynamic> json) =>
      _$JExModelFromJson(json);
  Map<String, dynamic> toJson() => _$JExModelToJson(this);
}
