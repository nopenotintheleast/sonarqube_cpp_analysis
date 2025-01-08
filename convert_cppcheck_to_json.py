import xml.etree.ElementTree as ET
import json
import sys

if len(sys.argv) != 3:
    print("Usage: python3 convert_cppcheck_to_json.py <input_xml> <output_json>")
    sys.exit(1)

input_file = sys.argv[1]
output_file = sys.argv[2]

tree = ET.parse(input_file)
root = tree.getroot()

issues = []
for error in root.findall('errors/error'):
    message = error.get('msg')
    severity = error.get('severity').upper()

    for location in error.findall('location'):
        file = location.get('file')
        line = int(location.get('line'))

        issues.append({
            "engineId": "cppcheck",
            "ruleId": error.get('id'),
            "severity": "MAJOR" if severity in ["ERROR", "WARNING"] else "INFO",
            "type": "CODE_SMELL",
            "primaryLocation": {
                "message": message,
                "filePath": file,
                "textRange": {
                    "startLine": line,
                    "endLine": line
                }
            }
        })

output = {"issues": issues}

with open(output_file, "w") as f:
    json.dump(output, f, indent=4)

