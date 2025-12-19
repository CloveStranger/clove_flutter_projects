import 'dart:io';
import 'package:yaml/yaml.dart';

/// 检查测试覆盖率是否达到最低要求
///
/// 使用方法:
///   dart run tool/check_coverage.dart [minimum_coverage]
///
/// 优先级:
///   1. 命令行参数
///   2. .coverage_config.yaml 文件
///   3. 默认值 80%
double _getMinimumCoverage(List<String> args) {
  // 1. 检查命令行参数
  if (args.isNotEmpty) {
    final argValue = double.tryParse(args[0]);
    if (argValue != null) return argValue;
  }

  // 2. 检查配置文件（从项目根目录查找）
  final scriptDir = Directory.current;
  final configFile = File('${scriptDir.path}/.coverage_config.yaml');
  if (configFile.existsSync()) {
    try {
      final content = configFile.readAsStringSync();
      final yaml = loadYaml(content);
      if (yaml is Map && yaml['minimum_coverage'] != null) {
        final configValue = yaml['minimum_coverage'];
        if (configValue is num) {
          return configValue.toDouble();
        }
      }
    } catch (e) {
      // 配置文件解析失败，使用默认值
    }
  }

  // 3. 默认值
  return 80.0;
}

void main(List<String> args) {
  final minimumCoverage = _getMinimumCoverage(args);

  final coverageFile = File('coverage/lcov.info');

  if (!coverageFile.existsSync()) {
    print('❌ 覆盖率文件未找到。请先运行: flutter test --coverage');
    exit(1);
  }

  final content = coverageFile.readAsStringSync();
  final lines = content.split('\n');

  int totalLines = 0;
  int coveredLines = 0;
  String? currentFile;

  for (final line in lines) {
    if (line.startsWith('SF:')) {
      // SF:source_file
      currentFile = line.substring(3);
    } else if (line.startsWith('LF:')) {
      // LF:total_lines_found
      final linesFound = int.tryParse(line.substring(3)) ?? 0;
      totalLines += linesFound;
    } else if (line.startsWith('LH:')) {
      // LH:lines_hit
      final linesHit = int.tryParse(line.substring(3)) ?? 0;
      coveredLines += linesHit;
    }
  }

  if (totalLines == 0) {
    print('⚠️  未找到覆盖率数据');
    exit(1);
  }

  final coveragePercent = (coveredLines / totalLines) * 100;

  print('📊 测试覆盖率报告');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('总行数: ${totalLines.toInt()}');
  print('已覆盖: ${coveredLines.toInt()}');
  print('覆盖率: ${coveragePercent.toStringAsFixed(2)}%');
  print('最低要求: ${minimumCoverage.toStringAsFixed(2)}%');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

  if (coveragePercent >= minimumCoverage) {
    print('✅ 覆盖率达标！');
    exit(0);
  } else {
    print('❌ 覆盖率未达标！需要至少 ${minimumCoverage.toStringAsFixed(2)}%');
    exit(1);
  }
}
