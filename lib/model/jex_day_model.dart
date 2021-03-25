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

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'jex_day_model.g.dart';

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
class JExDayModel {
  // Example of data to be parsed:
  // {
  //   {
  //     "diferencaHorasFormatado":"00:00",
  //     "isDiaUtil":false,
  //     "diferencaHoras":0.0,
  //     "nomeDiaSemana":"Dom", // This will be ignored. We can get from "day"
  //     "apontado":0.0,
  //     "horasRecurso":0.0,
  //     "dataRecursoHabilitada":false,
  //     "dia":"28/02/2021"
  //   },
  // }

  @JsonKey(name: 'diferencaHorasFormatado', fromJson: parseHHMM)
  final Duration hoursDifferenceFormat;

  @JsonKey(name: 'isDiaUtil')
  final bool isBusinessDay;

  @JsonKey(name: 'diferencaHoras')
  final double difference;

  @JsonKey(name: 'apontado')
  final double reported;

  @JsonKey(name: 'horasRecurso')
  final double resourceHours;

  @JsonKey(name: 'dataRecursoHabilitada')
  final bool resourceDataEnabled;

  @JsonKey(name: 'dia', fromJson: parseDateTime)
  final DateTime day;

  @visibleForTesting
  static Duration parseHHMM(String duration) {
    // Check the duration content.
    if (!RegExp(r'\b[0-9][0-9]\b:\b[0-5][0-9]\b').hasMatch(duration)) {
      print('Unexpected duration format: "$duration (expecting 00:00~99:59)');

      // Do not break. Return empty duration and log it.
      log('Socket is null', name: (JExDayModel).toString());
      return Duration(hours: 0);
    }
    List<String> hhmm = duration.split(':');

    int hours = int.tryParse(hhmm[0]) ?? 0;
    int minutes = int.tryParse(hhmm[1]) ?? 0;
    return Duration(hours: hours, minutes: minutes);
  }

  static DateTime parseDateTime(String date) =>
      DateFormat('dd/MM/yyyy').parse(date);

  JExDayModel({
    required this.hoursDifferenceFormat,
    required this.isBusinessDay,
    required this.difference,
    required this.reported,
    required this.resourceHours,
    required this.resourceDataEnabled,
    required this.day,
  });
  factory JExDayModel.fromJson(Map<String, dynamic> json) =>
      _$JExDayModelFromJson(json);
  Map<String, dynamic> toJson() => _$JExDayModelToJson(this);
}
