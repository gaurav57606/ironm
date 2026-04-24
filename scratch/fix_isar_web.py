import os
import re

def fix_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Regex to find id: -?1234567890123456789
    # We want to find integers that are too large for JS (more than 15 digits roughly)
    def replace_large_int(match):
        prefix = match.group(1)
        val_str = match.group(2)
        val = int(val_str)
        # JS safe integer limit is 2^53 - 1 = 9007199254740991
        # We'll use a simple modulo to keep it unique-ish but safe
        safe_val = val % 9007199254740991
        print(f"Replacing {val} with {safe_val} in {os.path.basename(filepath)}")
        return f"{prefix}{safe_val}"

    # Search for "id: <digits>"
    new_content = re.sub(r'(id: )(-?\d{16,})', replace_large_int, content)
    
    if new_content != content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        return True
    return False

models_dir = r'c:\Users\PC\Desktop\series_project\project1\rev2\ironbook_g\lib\data\models'
for filename in os.listdir(models_dir):
    if filename.endswith('.g.dart'):
        fix_file(os.path.join(models_dir, filename))
