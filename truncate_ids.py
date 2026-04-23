import os
import re

def truncate_large_ints(content):
    # Regex to find integer literals that are too large for JS
    # Max safe JS int is 9007199254740991 (16 digits)
    # We'll find any integer with 16 or more digits and truncate it to 15 digits.
    def replace_match(match):
        val = match.group(0)
        # If it's a negative number, keep the sign
        sign = '-' if val.startswith('-') else ''
        digits = val.lstrip('-')
        if len(digits) >= 16:
            return sign + digits[:15]
        return val

    return re.sub(r'-?\d{16,}', replace_match, content)

def process_directory(directory):
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.g.dart'):
                filepath = os.path.join(root, file)
                with open(filepath, 'r', encoding='utf-8') as f:
                    content = f.read()
                
                new_content = truncate_large_ints(content)
                
                if new_content != content:
                    print(f"Truncated large ints in {filepath}")
                    with open(filepath, 'w', encoding='utf-8') as f:
                        f.write(new_content)

if __name__ == "__main__":
    process_directory('lib/data/models')
