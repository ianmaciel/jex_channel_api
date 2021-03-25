// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jex_day_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JExDayModel _$JExDayModelFromJson(Map<String, dynamic> json) {
  return JExDayModel(
    hoursDifferenceFormat:
        JExDayModel.parseHHMM(json['diferencaHorasFormatado'] as String),
    isBusinessDay: json['isDiaUtil'] as bool,
    difference: (json['diferencaHoras'] as num).toDouble(),
    reported: (json['apontado'] as num).toDouble(),
    resourceHours: (json['horasRecurso'] as num).toDouble(),
    resourceDataEnabled: json['dataRecursoHabilitada'] as bool,
    day: JExDayModel.parseDateTime(json['dia'] as String),
  );
}

Map<String, dynamic> _$JExDayModelToJson(JExDayModel instance) =>
    <String, dynamic>{
      'diferencaHorasFormatado': instance.hoursDifferenceFormat.inMicroseconds,
      'isDiaUtil': instance.isBusinessDay,
      'diferencaHoras': instance.difference,
      'apontado': instance.reported,
      'horasRecurso': instance.resourceHours,
      'dataRecursoHabilitada': instance.resourceDataEnabled,
      'dia': instance.day.toIso8601String(),
    };
