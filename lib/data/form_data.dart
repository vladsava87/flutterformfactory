class FormData {
  static const String jsonForm = '''
[
  {
    "name": "name",
    "label": "Name",
    "hint": "Your name here",
    "type": "text",
    "validators": ["required"]
  },
  {
    "name": "email",
    "label": "Email",
    "type": "email",
    "validators": ["required", "email"]
  },
  {
    "name": "salary",
    "label": "Salary",
    "hint": "Type salary here",
    "format": "\$",
    "type": "number",
    "validators": ["required"]
  },
  {
    "name": "age",
    "label": "Age",
    "type": "number",
    "validators": ["required", "min:18"]
  },
  {
    "name": "isemplyed",
    "label": "Is employed",
    "type": "radio",
    "values": ["Yes", "No"],
    "validators": ["required"]
  },
  {
    "name": "date",
    "label": "Select emplyment date",
    "type": "date",
    "validators": ["required"]
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
    "validators": ["required"]
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
