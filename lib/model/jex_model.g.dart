// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jex_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JExModel _$JExModelFromJson(Map<String, dynamic> json) {
  return JExModel(
    days: (json['dias'] as List<dynamic>)
        .map((e) => JExDayModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    formatedStart: JExModel.parseDateTime(json['inicioFormatado'] as String),
    formatedEnd: JExModel.parseDateTime(json['fimFormatado'] as String),
  );
}

Map<String, dynamic> _$JExModelToJson(JExModel instance) => <String, dynamic>{
      'dias': instance.days,
      'inicioFormatado': instance.formatedStart.toIso8601String(),
      'fimFormatado': instance.formatedEnd.toIso8601String(),
    };
