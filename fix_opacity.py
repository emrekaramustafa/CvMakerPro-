import os
import re

def process_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # Replace .withOpacity(x) with .withValues(alpha: x)
    new_content = re.sub(r'\.withOpacity\s*\(\s*([^)]+)\s*\)', r'.withValues(alpha: \1)', content)

    if new_content != content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        return True
    return False

dir_path = 'lib'
count = 0
for root, _, files in os.walk(dir_path):
    for filename in files:
        if filename.endswith('.dart'):
            filepath = os.path.join(root, filename)
            if process_file(filepath):
                count += 1

print(f"Replaced .withOpacity with .withValues in {count} files.")
