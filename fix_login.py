
import os
p = "lib/screens/auth/login_screen.dart"
with open(p) as f:
    content = f.read()

# Fix 1: remove the unused local variables (lines 76-77)
content = content.replace("    final isDark = Theme.of(context).brightness == Brightness.dark;\n    final _demoEmail = 'demo@bytebudget.io';\n    final _demoPass = 'demo1234';\n    return Scaffold(", "    final isDark = Theme.of(context).brightness == Brightness.dark;\n    return Scaffold(")

# Fix 2: replace the demo display line
content = content.replace("Text('Demo: $_demoEmail / $_demoPass', style: TextStyle(color: Colors.blue[700], fontSize: 12))", "Text('Demo: $demoEmail / $demoPass', style: TextStyle(color: Colors.blue[700], fontSize: 12))")

# Fix 3: fix the InkWell Container with withOpacity -> withValues(alpha: 0.12)
content = content.replace("color: Colors.white.withOpacity(0.12)", "color: Colors.white.withValues(alpha: 0.12)")

# Fix 4: fix the closing brackets on the last line (was with 4 closing parens + 1 extra)
# The last line currently: ]))))));
# Should be: ])))));
# Actually the current last line is "      ])))));") which is correct for:
# Scaffold( ... Column(...) Form(...) Padding(...) Container(...) Row(...]) ... 
# Let's check the last 3 lines and fix if needed

with open(p, 'w') as f:
    f.write(content)
print("fixed")
