class FormData {
  static const String jsonForm = '''
[
  {
    "name": "name",
    "label": "Name",
    "hint": "Your name here",
    "type": "text",
    "validators": [
      {"value": "required", "label": "This field is required"}
    ]
  },
  {
    "name": "email",
    "label": "Email",
    "type": "email",
    "validators": [
      {"value": "required", "label": "This field is required"},
      {"value": "email", "label": "Enter a valid email"}
    ]
  },
  {
    "name": "salary",
    "label": "Salary",
    "hint": "Type salary here",
    "format": "\$",
    "type": "number",
    "validators": [
      {"value": "required", "label": "This field is required"}
    ]
  },
  {
    "name": "age",
    "label": "Age",
    "type": "number",
    "validators": [
      {"value": "required", "label": "This field is required"},
      {"value": "min:18", "label": "Age should be higher than 18"}
    ]
  },
  {
    "name": "isemplyed",
    "label": "Is employed",
    "type": "radio",
    "values": ["Yes", "No"],
    "validators": [
      {"value": "required", "label": "This field is required"}
    ]
  },
  {
    "name": "date",
    "label": "Select emplyment date",
    "type": "date",
    "validators": [
      {"value": "required", "label": "This field is required"}
    ]
  },
  {
    "name": "country",
    "label": "Choose country",
    "type": "dropdown",
    "options": [
      {"value": "USA", "label": "United States"},
      {"value": "CAN", "label": "Canada"},
      {"value": "MEX", "label": "Mexico"}
    ],
    "validators": [
      {"value": "required", "label": "This field is required"}
    ]
  },
  {
    "name": "comment",
    "label": "Comment optional",
    "type": "multiline",
    "lines": 5
  }
]
''';
}
