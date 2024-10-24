import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_factory/form_factory/model/field_type_enum.dart';
import 'package:flutter_form_factory/form_factory/model/form_dynamic_field.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

final class FormFieldParser {
  static List<FormDynamicField> parseJsonFormFields(String jsonString) {
    List<dynamic> jsonData = jsonDecode(jsonString);
    return jsonData.map((field) => _parseJsonField(field)).toList();
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
        validators: (jsonField['validators'] != null)
            ? _parseDateTimeValidators(
                List<String>.from(jsonField['validators']))
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
        validators:
            _parseStringValidators(List<String>.from(jsonField['validators'])),
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
        validators: (jsonField['validators'] != null)
            ? _parseStringValidators(List<String>.from(jsonField['validators']))
            : const [],
      );
    }
  }

  static List<FormFieldValidator<dynamic>> _parseStringValidators(
      List<String> validators) {
    List<FormFieldValidator<dynamic>> parsedValidators = [];
    for (var validator in validators) {
      if (validator == "required") {
        parsedValidators.add((dynamic value) {
          if (value == null || (value is String && value.isEmpty)) {
            return 'This field is required';
          }
          return null;
        });
      } else if (validator.startsWith("min:")) {
        int minValue = int.parse(validator.split(":")[1]);
        parsedValidators.add(FormBuilderValidators.min(minValue));
      } else if (validator == "email") {
        parsedValidators.add((dynamic value) {
          if (value != null &&
              value is String &&
              !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
                  .hasMatch(value)) {
            return 'Enter a valid email';
          }
          return null;
        });
      }
      // Add more string-specific validators here
    }
    return parsedValidators;
  }

  static List<FormFieldValidator<dynamic>> _parseDateTimeValidators(
      List<String> validators) {
    List<FormFieldValidator<dynamic>> parsedValidators = [];
    for (var validator in validators) {
      if (validator == "required") {
        parsedValidators.add((dynamic value) {
          if (value == null || value is! DateTime) {
            return 'This field is required';
          }
          return null;
        });
      }
      // Add more DateTime-specific validators here
    }
    return parsedValidators;
  }
}
