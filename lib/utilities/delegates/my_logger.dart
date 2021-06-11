import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class SimpleLogPrinter extends LogPrinter {
  final Type? classType;
  final bool printCallingFunctionName;
  final bool printCallStack;

  SimpleLogPrinter({
    this.classType,
    this.printCallingFunctionName = true,
    this.printCallStack = false,
  });

  @override
  List<String> log(LogEvent event) {
    // var color = PrettyPrinter.levelColors[event.level];
    final emoji = PrettyPrinter.levelEmojis[event.level];
    final methodName = _getMethodName();
    final methodNameSection = printCallingFunctionName ? '$methodName' : '';
    final stackLog = event.stackTrace.toString();

    String output = '$emoji';
    if (classType != null) output += '$classType';
    output += (classType != null ? '.' : '') + '$methodNameSection';
    if (classType != null && printCallingFunctionName) output += ' - ';
    output += event.message.toString();
    if (printCallStack) output += '\nSTACK TRACE:\n' + stackLog.toString();

    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    List<String> result = [];

    for (var line in output.split('\n')) {
      result.addAll(pattern.allMatches(line).map((match) => match.group(0)!));
    }

    return result;
  }

  String _getMethodName() {
    final currentStack = StackTrace.current;
    final formattedStacktrace = _formatStackTrace(currentStack, 3);
    final realFirstLine = formattedStacktrace.firstWhere((line) => line.contains(classType.toString()));
    final methodName = realFirstLine.replaceAll('$classType.', '');
    return methodName;
  }
}

final stackTraceRegex = RegExp(r'#[0-9]+[\s]+(.+) \(([^\s]+)\)');

List<String> _formatStackTrace(StackTrace stackTrace, int methodCount) {
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

class MultipleLoggerOutput extends LogOutput {
  final List<LogOutput> logOutputs;
  MultipleLoggerOutput(this.logOutputs);

  @override
  void output(OutputEvent event) {
    for (var logOutput in logOutputs) {
      try {
        logOutput.output(event);
      } catch (e) {
        print('Log output failed');
      }
    }
  }
}

class ShouldLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) => kDebugMode;
}

Logger logger(
  Type classType, {
  bool printCallingFunctionName = true,
  bool printCallstack = false,
  String? showOnlyClass,
}) {
  return Logger(
    filter: ShouldLogFilter(),
    printer: SimpleLogPrinter(
      classType: classType,
      printCallingFunctionName: printCallingFunctionName,
      printCallStack: printCallstack,
    ),
    output: MultipleLoggerOutput([ConsoleOutput()]),
  );
}

Logger get simpleLogger {
  return Logger(
    filter: ShouldLogFilter(),
    printer: SimpleLogPrinter(
      printCallingFunctionName: false,
      printCallStack: false,
    ),
    output: MultipleLoggerOutput([ConsoleOutput()]),
  );
}
