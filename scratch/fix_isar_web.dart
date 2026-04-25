
import 'dart:io';

void main() {
  final dir = Directory('lib');
  if (!dir.existsSync()) return;

  final files = dir.listSync(recursive: true).where((f) => f.path.endsWith('.g.dart'));

  for (var file in files) {
    if (file is File) {
      String content = file.readAsStringSync();
      
      // Look for id: -?[0-9]{16,}
      final regex = RegExp(r'id: (-?[0-9]{16,})');
      
      bool modified = false;
      final newContent = content.replaceAllMapped(regex, (match) {
        final valStr = match.group(1)!;
        // We need to provide a value that JS can represent exactly.
        // The error message suggested 358741778409288704 for 358741778409288680.
        // A simple way is to use a number with fewer significant digits.
        // But Isar needs these to be stable.
        // Let's just use the suggested nearest values if possible, or just append ' // ignore: avoid_js_rounded_ints'? 
        // No, the compiler error is the issue.
        
        // Let's try to just use a smaller number that is still likely unique.
        // Or better, let's just use the suggested nearest value by parsing and rounding?
        // JS safe range is 2^53 - 1.
        
        modified = true;
        print('Found large ID in ${file.path}: $valStr');
        
        // Use only the first 14 digits to stay within JS safe integer range (2^53 - 1)
        String sign = valStr.startsWith('-') ? '-' : '';
        String absoluteVal = valStr.startsWith('-') ? valStr.substring(1) : valStr;
        String safeVal = absoluteVal.substring(0, 14);
        
        return 'id: $sign$safeVal';
      });

      if (modified) {
        file.writeAsStringSync(newContent);
        print('Updated ${file.path}');
      }
    }
  }
}
