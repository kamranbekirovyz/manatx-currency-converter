import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class SimpleLogPrinter extends LogPrinter {
  final Type? type;
  final bool printFunction;
  final bool printStack;

  SimpleLogPrinter({
    this.type,
    this.printFunction = true,
    this.printStack = false,
  });

  static const _levelEmojis = {
    Level.verbose: '',
    Level.debug: '🐛 ',
    Level.info: '💡 ',
    Level.warning: '❗ ',
    Level.error: '⛔ ',
    Level.wtf: '👾 ',
  };

  @override
  List<String> log(LogEvent event) {
    // var color = PrettyPrinter.levelColors[event.level];
    print(PrettyPrinter.doubleDivider);
    final emoji = _levelEmojis[event.level];
    final methodName = _getMethodName();
    final methodNameSection = printFunction ? '$methodName' : '';
    final stackLog = event.stackTrace.toString();

    String output = '$emoji';
    if (type != null) output += '$type';
    output += (type != null ? '.' : '') + '$methodNameSection';
    if (type != null && printFunction) output += ' - ';
    output += event.message.toString();
    if (printStack) output += '\nSTACK TRACE:\n' + stackLog.toString();

    final pattern = RegExp('.{1,800}'); // 800 (size of each chunk)
    List<String> result = [];

    for (var line in output.split('\n')) {
      result.addAll(pattern.allMatches(line).map((match) => match.group(0)!));
    }

    return result;
  }

  List<String> _formatStackTrace(StackTrace stackTrace, int methodCount) {
    final stackTraceRegex = RegExp(r'#[0-9]+[\s]+(.+) \(([^\s]+)\)');
    var lines = stackTrace.toString().split('\n');

    var formatted = <String>[];
    var count = 0;
    for (var line in lines) {
      var match = stackTraceRegex.matchAsPrefix(line);
      if (match != null) {
        if (match.group(2)!.startsWith('package:logger')) {
          continue;
        }
        var newLine = ("${match.group(1)}");
        formatted.add(newLine.replaceAll('<anonymous closure>', '()'));
        if (++count == methodCount) {
          break;
        }
      } else {
        formatted.add(line);
      }
    }
    return formatted;
  }

  String _getMethodName() {
    try {
      final currentStack = StackTrace.current;
      final formattedStacktrace = _formatStackTrace(currentStack, 3);
      final realFirstLine = formattedStacktrace.firstWhere((line) => line.contains(type.toString()));
      final methodName = realFirstLine.replaceAll('$type.', '');
      return methodName;
    } catch (e) {
      return '';
    }
  }
}

class ShouldLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) => kDebugMode;
}

Logger logger(
  Type type, {
  bool printFunction = true,
  bool printStack = false,
}) {
  return Logger(
    filter: ShouldLogFilter(),
    printer: SimpleLogPrinter(
      type: type,
      printFunction: printFunction,
      printStack: printStack,
    ),
    output: ConsoleOutput(),
  );
}

Logger get simpleLogger {
  return Logger(
    filter: ShouldLogFilter(),
    printer: SimpleLogPrinter(
      printFunction: false,
      printStack: false,
    ),
    output: ConsoleOutput(),
  );
}
