import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_factory/form_factory/model/field_type_enum.dart';
import 'package:flutter_form_factory/form_factory/model/form_dynamic_field.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

final class FormFieldParser {
  static List<FormDynamicField> parseJsonFormFields(String jsonString) {
    List<dynamic> jsonData = jsonDecode(jsonString);
    var data = jsonData.map((field) => _parseJsonField(field)).toList();
    return data;
  }

  static EFieldType _fieldTypeFromString(String type) {
    switch (type) {
      case 'text':
        return EFieldType.text;
      case 'email':
        return EFieldType.email;
      case 'number':
        return EFieldType.number;
      case 'checkboxes':
        return EFieldType.checkboxes;
      case 'date':
        return EFieldType.date;
      case 'multiline':
        return EFieldType.multiline;
      case 'radio':
        return EFieldType.radio;
      case 'dropdown':
        return EFieldType.dropdown;
      default:
        throw Exception('Unsupported field type: $type');
    }
  }

  static FormDynamicField _parseJsonField(Map<String, dynamic> jsonField) {
    final fieldType = _fieldTypeFromString(jsonField['type']);

    List<Map<String, dynamic>> validators = (jsonField['validators'] != null)
        ? List<Map<String, dynamic>>.from(jsonField['validators'])
        : [];

    if (fieldType == EFieldType.date) {
      return FormDynamicField<DateTime>(
        name: jsonField['name'],
        label: jsonField['label'],
        type: fieldType,
        value: jsonField['value'] != null
            ? DateTime.parse(jsonField['value'])
            : null,
        values: (jsonField['values'] != null)
            ? List<String>.from(jsonField['values'])
            : const [],
        hint: jsonField['hint'],
        validators: (validators.isNotEmpty)
            ? _parseDateTimeValidators(validators)
            : const [],
      );
    } else if (fieldType == EFieldType.dropdown) {
      List<Map<String, dynamic>> options =
          List<Map<String, dynamic>>.from(jsonField['options']);
      return FormDynamicField<String>(
        name: jsonField['name'],
        label: jsonField['label'],
        hint: jsonField['hint'],
        type: fieldType,
        value: jsonField['value'] ?? '',
        validators: (validators.isNotEmpty)
            ? _parseStringValidators(validators)
            : const [],
        options: options,
      );
    } else {
      return FormDynamicField<String>(
        name: jsonField['name'],
        label: jsonField['label'],
        type: fieldType,
        value: jsonField['value'] ?? '',
        values: (jsonField['values'] != null)
            ? List<String>.from(jsonField['values'])
            : const [],
        hint: jsonField['hint'],
        format: jsonField['format'],
        lines: jsonField['lines'],
        validators: (validators.isNotEmpty)
            ? _parseStringValidators(validators)
            : const [],
      );
    }
  }

  static List<FormFieldValidator<dynamic>> _parseStringValidators(
      List<Map<String, dynamic>>? validators) {
    List<FormFieldValidator<dynamic>> parsedValidators = [];

    for (var validator in validators!) {
      if (validator['value'] == "required") {
        parsedValidators.add((dynamic value) {
          if (value == null || (value is String && value.isEmpty)) {
            return validator['label'];
          }
          return null;
        });
      } else if (validator['value'].startsWith("min:")) {
        int minValue = int.parse(validator['value'].split(":")[1]);
        parsedValidators.add(FormBuilderValidators.min(minValue));
      } else if (validator['value'] == "email") {
        parsedValidators.add((dynamic value) {
          if (value != null &&
              value is String &&
              !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
                  .hasMatch(value)) {
            return validator['label'];
          }
          return null;
        });
      }
      // Add more string-specific validators here
    }
    return parsedValidators;
  }

  static List<FormFieldValidator<dynamic>> _parseDateTimeValidators(
      List<Map<String, dynamic>>? validators) {
    List<FormFieldValidator<dynamic>> parsedValidators = [];

    for (var validator in validators!) {
      if (validator['value'] == "required") {
        parsedValidators.add((dynamic value) {
          if (value == null || value is! DateTime) {
            return validator['label'];
          }
          return null;
        });
      }
    }
    return parsedValidators;
  }
}
