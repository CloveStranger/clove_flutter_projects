# Clove Todo 日程规划项目开发计划

## 项目概述

**项目名称**: Clove Todo (日程规划应用)  
**技术栈**: Flutter (Dart)  
**目标平台**: iOS, Android, Desktop (macOS, Windows, Linux), HarmonyOS  
**项目类型**: 日程规划与提醒应用（本地工具 + 局域网同步）

### 项目目标

开发一款简洁、易用的日程规划应用，帮助用户管理日常事务和重要日程。支持本地数据存储，同一局域网下多设备同步，并提供智能提醒功能。所有数据存储在本地，局域网同步无需外部服务器。

---

## 核心功能需求

### 1. 日程规划功能 (MVP - 最小可行产品)

#### 1.1 创建日程

- [ ] 添加日程规划
  - 标题输入
  - 日期时间选择（开始时间、结束时间）
  - 地点信息（可选）
  - 备注/描述
  - 分类标签（工作、生活、学习、旅行等）
  - 优先级设置（高、中、低）
  - 重复规则（单次、每日、每周、每月、每年、自定义）

#### 1.2 提醒设置

- [ ] 提醒时间配置
  - 默认提醒：日程开始前 30 分钟
  - 自定义提醒时间（提前 5 分钟、15 分钟、30 分钟、1 小时、2 小时等）
  - 多时间点提醒（可设置多个提醒时间）
  - 提醒方式（通知、声音、震动）

#### 1.3 预设提醒模板

- [ ] 常用提醒模板
  - 登机提醒：提前 2 小时
  - 会议提醒：提前 15 分钟
  - 生日提醒：提前 1 天
  - 截止日期提醒：提前 1 天
  - 自定义模板保存

#### 1.4 日程管理

- [ ] 查看日程列表
  - 日历视图（月视图、周视图、日视图）
  - 列表视图（按日期分组）
  - 按分类筛选
  - 按优先级筛选
  - 搜索功能（关键词、标题、备注）
- [ ] 编辑日程
- [ ] 删除日程
- [ ] 批量操作（批量删除、批量导出）
- [ ] 日程完成状态标记

### 2. 通知提醒功能 (Phase 1)

#### 2.1 本地通知

- [ ] 系统通知集成
  - 使用平台原生通知 API
  - 通知标题和内容显示
  - 点击通知跳转到对应日程
  - 通知声音和震动设置
  - 通知优先级管理

#### 2.2 提醒调度

- [ ] 提醒任务管理
  - 根据日程时间自动计算提醒时间
  - 提醒任务队列管理
  - 重复日程的提醒处理
  - 提醒状态跟踪（已提醒、未提醒）

#### 2.3 通知中心

- [ ] 通知历史记录
- [ ] 待提醒日程列表
- [ ] 通知设置管理

### 3. 局域网同步功能 (Phase 2)

#### 3.1 设备发现与连接

- [ ] 局域网设备发现
  - 自动扫描同一局域网下的其他设备
  - 设备列表显示（设备名称、IP 地址）
  - 手动添加设备（IP 地址输入）
  - 设备连接状态显示

#### 3.2 数据同步

- [ ] 日程数据同步
  - 双向同步（发送和接收）
  - 冲突解决策略（时间戳优先、手动选择）
  - 增量同步（只同步变更数据）
  - 同步状态显示
  - 同步历史记录

#### 3.3 多端提醒

- [ ] 跨设备提醒
  - 手机设置日程后，同步到电脑端
  - 电脑端设置日程后，同步到手机端
  - 所有设备在对应时间收到提醒
  - 设备间提醒状态同步

#### 3.4 同步设置

- [ ] 同步配置
  - 启用/禁用局域网同步
  - 自动同步 vs 手动同步
  - 同步频率设置
  - 同步数据范围（全部/指定分类）

### 4. 数据管理 (Phase 1)

#### 4.1 数据存储

- [ ] 本地数据库（SQLite/Hive）
  - 日程数据持久化
  - 提醒任务存储
  - 同步状态记录
  - 设备信息存储

#### 4.2 数据备份与恢复

- [ ] 本地备份

  - 数据导出（JSON、CSV）
  - 定期自动备份
  - 手动备份
  - 备份文件管理

- [ ] 数据恢复
  - 从备份文件恢复
  - 数据导入验证

### 5. 用户体验优化 (持续)

#### 5.1 UI/UX

- [ ] 现代化 Material Design 3 界面
- [ ] 深色模式支持
- [ ] 流畅的动画效果
- [ ] 直观的操作流程
- [ ] 响应式布局（适配不同屏幕尺寸）
- [ ] 日历组件集成

#### 5.2 交互优化

- [ ] 快速创建日程（常用模板）
- [ ] 手势操作（滑动删除、长按编辑）
- [ ] 快捷入口（桌面小组件）
- [ ] 键盘快捷键（桌面端）
- [ ] 拖拽操作（日历视图）

---

## 技术架构设计

本项目采用 **Clean Architecture** 架构模式，确保代码的可测试性、可维护性和可扩展性。

### 1. 架构概述

项目分为三个主要层次，依赖关系严格向内：

1. **Domain Layer** (内层) - 业务逻辑核心，不依赖任何外部库
2. **Data Layer** (中层) - 数据获取和持久化，实现 Domain 层的接口
3. **Presentation Layer** (外层) - UI 展示和用户交互

**依赖规则**: Domain → Data → Presentation（单向依赖）

### 2. 项目结构

```
lib/
├── main.dart                    # 应用入口
├── core/                        # 核心共享代码
│   ├── error/                  # 错误处理
│   │   ├── failures.dart       # 失败类型定义
│   │   └── exceptions.dart      # 异常类型
│   ├── network/                # 网络相关
│   │   └── network_info.dart   # 网络信息工具
│   ├── utils/                  # 工具类
│   │   ├── constants.dart      # 常量
│   │   ├── date_utils.dart     # 日期工具
│   │   └── validators.dart     # 验证器
│   └── theme/                  # 主题配置
│       └── app_theme.dart
├── features/                    # 功能模块（按功能组织）
│   ├── schedule/               # 日程功能
│   │   ├── domain/             # Domain 层
│   │   │   ├── entities/      # 实体（纯 Dart 类）
│   │   │   │   ├── schedule.dart
│   │   │   │   └── reminder.dart
│   │   │   ├── repositories/  # 仓库接口
│   │   │   │   └── schedule_repository.dart
│   │   │   └── usecases/      # 用例
│   │   │       ├── get_schedules.dart
│   │   │       ├── add_schedule.dart
│   │   │       ├── update_schedule.dart
│   │   │       └── delete_schedule.dart
│   │   ├── data/               # Data 层
│   │   │   ├── datasources/   # 数据源
│   │   │   │   ├── schedule_local_data_source.dart
│   │   │   │   └── schedule_remote_data_source.dart (局域网同步)
│   │   │   ├── models/         # 数据模型（DTO）
│   │   │   │   ├── schedule_model.dart (extends Schedule Entity)
│   │   │   │   └── reminder_model.dart
│   │   │   └── repositories/   # 仓库实现
│   │   │       └── schedule_repository_impl.dart
│   │   └── presentation/        # Presentation 层
│   │       ├── bloc/          # 状态管理
│   │       │   ├── schedule_bloc.dart
│   │       │   ├── schedule_event.dart
│   │       │   └── schedule_state.dart
│   │       ├── pages/        # 页面
│   │       │   ├── schedule_list_page.dart
│   │       │   ├── add_schedule_page.dart
│   │       │   └── schedule_detail_page.dart
│   │       └── widgets/      # 组件
│   │           ├── schedule_card.dart
│   │           └── calendar_widget.dart
│   ├── notification/          # 通知功能
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── notification.dart
│   │   │   ├── repositories/
│   │   │   │   └── notification_repository.dart
│   │   │   └── usecases/
│   │   │       ├── schedule_notification.dart
│   │   │       └── cancel_notification.dart
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── notification_local_data_source.dart
│   │   │   └── repositories/
│   │   │       └── notification_repository_impl.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       └── pages/
│   │           └── notifications_page.dart
│   ├── sync/                   # 局域网同步功能
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── device.dart
│   │   │   │   └── sync_record.dart
│   │   │   ├── repositories/
│   │   │   │   └── sync_repository.dart
│   │   │   └── usecases/
│   │   │       ├── discover_devices.dart
│   │   │       ├── sync_schedules.dart
│   │   │       └── resolve_conflict.dart
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── device_discovery_data_source.dart
│   │   │   │   └── sync_remote_data_source.dart
│   │   │   └── repositories/
│   │   │       └── sync_repository_impl.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       └── pages/
│   │           └── sync_settings_page.dart
│   └── settings/              # 设置功能
│       ├── domain/
│       ├── data/
│       └── presentation/
│           └── pages/
│               └── settings_page.dart
└── injection/                  # 依赖注入配置
    └── injection_container.dart
```

### 3. 技术选型

#### 3.1 状态管理

- **推荐**: **flutter_bloc** (BLoC 模式)
- **原因**:
  - 符合 Clean Architecture 的分离原则
  - 易于测试（BLoC 可独立测试）
  - 清晰的状态管理流程
  - 支持复杂的状态转换

#### 3.2 依赖注入

- **推荐**: **get_it** + **injectable**
- **原因**:
  - 类型安全的依赖注入
  - 代码生成，减少样板代码
  - 支持单例和工厂模式
  - 便于测试时替换依赖

#### 3.3 错误处理

- **推荐**: **dartz** 或 **fpdart** (Either 类型)
- **原因**:
  - 函数式错误处理
  - 类型安全的错误处理
  - Repository 和 Use Case 返回 `Either<Failure, Data>`
  - 避免异常传播，显式错误处理

#### 3.4 本地存储

- **推荐**: **ObjectBox**
- **优势**:
  - ✅ 高性能 NoSQL 数据库，专为移动和桌面应用优化
  - ✅ 支持 iOS、Android、Desktop (macOS/Windows/Linux)
  - ✅ 支持 HarmonyOS（通过 Android 兼容层）
  - ✅ 零配置，开箱即用
  - ✅ 自动索引，查询性能优秀
  - ✅ 支持关系（Relations）和对象引用
  - ✅ 类型安全，代码生成
  - ✅ 支持数据同步（可用于局域网同步）
  - ✅ 内存占用小，适合移动设备
- **平台支持**:
  - iOS: 原生支持
  - Android: 原生支持
  - Desktop (macOS/Windows/Linux): 原生支持
  - HarmonyOS: 通过 Android 兼容层支持（需要测试验证）
  - ❌ Web: 不支持（已放弃 Web 平台）
- **实现**: LocalDataSource 层使用
- **依赖包**:

  ```yaml
  dependencies:
    objectbox: ^4.0.0
    objectbox_flutter_libs: ^4.0.0

  dev_dependencies:
    build_runner: ^2.4.0
    objectbox_generator: ^4.0.0
  ```

- **使用说明**:
  - 使用 `@Entity()` 注解定义实体类
  - 使用代码生成器生成数据库代码
  - 支持查询构建器，类型安全的查询
  - 支持事务和批量操作

##### ObjectBox 特性

- **高性能**: 比 SQLite 快 5-10 倍
- **简单易用**: 无需编写 SQL，纯 Dart 代码
- **关系支持**: 支持 To-One、To-Many、Many-To-Many 关系
- **查询优化**: 自动索引，支持复杂查询
- **数据同步**: 内置同步功能（可用于局域网同步）

##### 鸿蒙（HarmonyOS）平台说明

- **HarmonyOS 支持情况**:
  - HarmonyOS 应用通常通过 Android 兼容层运行
  - ObjectBox 在 HarmonyOS 上通常可以正常工作（通过 Android 兼容）
  - 建议在 HarmonyOS 设备上进行实际测试验证
  - ObjectBox 使用原生代码，兼容性较好

##### 数据迁移策略

如果未来需要切换数据库系统，建议：

1. **抽象数据访问层**: 在 Repository 接口和实现之间保持清晰的分离
2. **数据导出/导入**: 实现数据导出功能（JSON 格式），便于迁移
3. **版本管理**: ObjectBox 支持数据模型版本迁移

##### 实现示例

```dart
// lib/features/schedule/data/models/schedule_model.dart
import 'package:objectbox/objectbox.dart';

@Entity()
class ScheduleModel {
  @Id()
  int id = 0;

  String title;
  String? description;
  DateTime startTime;
  DateTime endTime;
  String? location;
  String categoryId;
  int priority; // 0=低, 1=中, 2=高
  bool isCompleted;
  DateTime createdAt;
  DateTime updatedAt;
  String? deviceId;

  ScheduleModel({
    this.id = 0,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    this.location,
    required this.categoryId,
    required this.priority,
    this.isCompleted = false,
    required this.createdAt,
    required this.updatedAt,
    this.deviceId,
  });
}

// lib/core/database/objectbox_service.dart
import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ObjectBoxService {
  static Store? _store;
  static Store get store {
    if (_store == null) {
      throw Exception('ObjectBox not initialized');
    }
    return _store!;
  }

  static Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/objectbox';

    _store = Store(
      getObjectBoxModel(),
      directory: path,
    );
  }

  static void close() {
    _store?.close();
    _store = null;
  }
}
```

#### 3.5 数据序列化

- **推荐**: 手动实现 JSON 序列化 + **json_serializable**（可选）
- **原因**:
  - ObjectBox 使用 `@Entity()` 注解，不需要 freezed
  - 仍然需要 JSON 序列化用于局域网同步
  - 可以手动实现 `toJson()` 和 `fromJson()` 方法
  - 或者使用 `json_serializable` 自动生成（推荐）
- **依赖包**:

  ```yaml
  dependencies:
    json_annotation: ^4.8.1

  dev_dependencies:
    build_runner: ^2.4.0
    json_serializable: ^6.7.1
  ```

- **说明**:
  - ObjectBox Model 需要实现 JSON 序列化用于局域网同步
  - Domain Entity 保持纯 Dart 类，不包含序列化逻辑

#### 3.6 通知功能

- **推荐**: **flutter_local_notifications**
- **原因**: 跨平台本地通知支持，功能完善
- **实现**: NotificationLocalDataSource 使用

#### 3.7 局域网同步

- **推荐**:
  - `network_info_plus` (获取网络信息)
  - `http` (HTTP 客户端和服务器)
  - 自定义 TCP/UDP 通信（可选）
- **原因**: 实现局域网内设备发现和数据同步
- **实现**: RemoteDataSource 层使用

#### 3.8 UI 组件库

- **推荐**: Flutter 原生 Material Design 3
- **日历**: table_calendar 或 syncfusion_flutter_calendar
- **日期选择**: intl, flutter_datetime_picker

#### 3.9 其他依赖

- **路由**: go_router (声明式路由)
- **国际化**: intl (i18n 支持)
- **图标**: cupertino_icons, material_icons
- **工具**: path_provider (文件路径), share_plus (分享功能)

### 4. 数据模型设计

#### 4.1 Domain Layer - Entities (实体)

Entities 是纯 Dart 类，不包含任何框架依赖，代表核心业务对象。

##### 4.1.1 Schedule Entity

```dart
// lib/features/schedule/domain/entities/schedule.dart
class Schedule {
  final String id;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final String? location;
  final String categoryId;
  final Priority priority;
  final RepeatRule? repeatRule;
  final List<Reminder> reminders;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? deviceId;

  const Schedule({
    required this.id,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    this.location,
    required this.categoryId,
    required this.priority,
    this.repeatRule,
    required this.reminders,
    this.isCompleted = false,
    required this.createdAt,
    required this.updatedAt,
    this.deviceId,
  });
}
```

##### 4.1.2 Reminder Entity

```dart
// lib/features/schedule/domain/entities/reminder.dart
class Reminder {
  final String id;
  final String scheduleId;
  final DateTime remindTime;
  final ReminderType type;
  final bool isTriggered;
  final int minutesBefore;

  const Reminder({
    required this.id,
    required this.scheduleId,
    required this.remindTime,
    required this.type,
    this.isTriggered = false,
    required this.minutesBefore,
  });
}
```

##### 4.1.3 Device Entity

```dart
// lib/features/sync/domain/entities/device.dart
class Device {
  final String id;
  final String name;
  final String ipAddress;
  final int port;
  final DeviceType type;
  final bool isConnected;
  final DateTime? lastSyncTime;

  const Device({
    required this.id,
    required this.name,
    required this.ipAddress,
    required this.port,
    required this.type,
    this.isConnected = false,
    this.lastSyncTime,
  });
}
```

#### 4.2 Data Layer - Models (数据模型)

Models 使用 ObjectBox 的 `@Entity()` 注解，包含数据库映射逻辑。同时需要实现与 Domain Entity 的转换方法。

##### 4.2.1 Schedule Model (ObjectBox)

```dart
// lib/features/schedule/data/models/schedule_model.dart
import 'package:objectbox/objectbox.dart';
import '../../domain/entities/schedule.dart';
import '../../domain/entities/reminder.dart';

@Entity()
class ScheduleModel {
  @Id()
  int id = 0; // ObjectBox 使用 int 作为 ID

  String title;
  String? description;
  DateTime startTime;
  DateTime endTime;
  String? location;
  String categoryId;
  int priority; // 0=低, 1=中, 2=高
  String? repeatRuleJson; // 序列化的重复规则
  bool isCompleted;
  DateTime createdAt;
  DateTime updatedAt;
  String? deviceId;

  // ObjectBox 关系：一个 Schedule 可以有多个 Reminder
  @Backlink()
  final reminders = ToMany<ReminderModel>();

  ScheduleModel({
    this.id = 0,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    this.location,
    required this.categoryId,
    required this.priority,
    this.repeatRuleJson,
    this.isCompleted = false,
    required this.createdAt,
    required this.updatedAt,
    this.deviceId,
  });

  // 从 Domain Entity 创建 Model
  factory ScheduleModel.fromEntity(Schedule schedule) {
    return ScheduleModel(
      id: int.tryParse(schedule.id) ?? 0,
      title: schedule.title,
      description: schedule.description,
      startTime: schedule.startTime,
      endTime: schedule.endTime,
      location: schedule.location,
      categoryId: schedule.categoryId,
      priority: schedule.priority.index,
      repeatRuleJson: schedule.repeatRule?.toJson(),
      isCompleted: schedule.isCompleted,
      createdAt: schedule.createdAt,
      updatedAt: schedule.updatedAt,
      deviceId: schedule.deviceId,
    );
  }

  // 转换为 Domain Entity
  Schedule toEntity() {
    return Schedule(
      id: id.toString(),
      title: title,
      description: description,
      startTime: startTime,
      endTime: endTime,
      location: location,
      categoryId: categoryId,
      priority: Priority.values[priority],
      repeatRule: repeatRuleJson != null
          ? RepeatRule.fromJson(repeatRuleJson!)
          : null,
      reminders: reminders.map((r) => r.toEntity()).toList(),
      isCompleted: isCompleted,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deviceId: deviceId,
    );
  }

  // JSON 序列化（用于局域网同步）
  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'location': location,
      'categoryId': categoryId,
      'priority': priority,
      'repeatRule': repeatRuleJson,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deviceId': deviceId,
    };
  }

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: int.tryParse(json['id'] ?? '0') ?? 0,
      title: json['title'],
      description: json['description'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      location: json['location'],
      categoryId: json['categoryId'],
      priority: json['priority'],
      repeatRuleJson: json['repeatRule'],
      isCompleted: json['isCompleted'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      deviceId: json['deviceId'],
    );
  }
}
```

##### 4.2.2 Reminder Model (ObjectBox)

```dart
// lib/features/schedule/data/models/reminder_model.dart
import 'package:objectbox/objectbox.dart';
import '../../domain/entities/reminder.dart';

@Entity()
class ReminderModel {
  @Id()
  int id = 0;

  final schedule = ToOne<ScheduleModel>(); // 反向关系
  DateTime remindTime;
  int type; // ReminderType 的索引
  bool isTriggered;
  int minutesBefore;

  ReminderModel({
    this.id = 0,
    required this.remindTime,
    required this.type,
    this.isTriggered = false,
    required this.minutesBefore,
  });

  factory ReminderModel.fromEntity(Reminder reminder) {
    return ReminderModel(
      id: int.tryParse(reminder.id) ?? 0,
      remindTime: reminder.remindTime,
      type: reminder.type.index,
      isTriggered: reminder.isTriggered,
      minutesBefore: reminder.minutesBefore,
    );
  }

  Reminder toEntity() {
    return Reminder(
      id: id.toString(),
      scheduleId: schedule.target?.id.toString() ?? '',
      remindTime: remindTime,
      type: ReminderType.values[type],
      isTriggered: isTriggered,
      minutesBefore: minutesBefore,
    );
  }
}
```

**注意**:

- ObjectBox 使用 `int` 作为主键，而 Domain Entity 使用 `String`，需要在转换时处理
- ObjectBox 支持关系（ToOne、ToMany），可以更好地表示数据关联
- 仍然需要 JSON 序列化用于局域网同步

#### 4.3 Repository 接口 (Domain Layer)

```dart
// lib/features/schedule/domain/repositories/schedule_repository.dart
abstract class ScheduleRepository {
  Future<Either<Failure, List<Schedule>>> getSchedules();
  Future<Either<Failure, Schedule>> getScheduleById(String id);
  Future<Either<Failure, Schedule>> addSchedule(Schedule schedule);
  Future<Either<Failure, Schedule>> updateSchedule(Schedule schedule);
  Future<Either<Failure, void>> deleteSchedule(String id);
  Future<Either<Failure, List<Schedule>>> getSchedulesByDateRange(
    DateTime start,
    DateTime end,
  );
}
```

#### 4.4 Use Case 示例

```dart
// lib/features/schedule/domain/usecases/add_schedule.dart
class AddSchedule {
  final ScheduleRepository repository;

  AddSchedule(this.repository);

  Future<Either<Failure, Schedule>> call(Schedule schedule) async {
    return await repository.addSchedule(schedule);
  }
}
```

---

## 开发计划与里程碑

### Phase 1: MVP 基础功能 (2-3 周)

**目标**: 实现基本的日程规划和通知提醒功能

#### Week 1: 项目搭建与基础架构

- [ ] 项目初始化与依赖配置（Clean Architecture 相关包）
- [ ] Clean Architecture 项目结构搭建
- [ ] Core 层实现（错误处理、工具类）
- [ ] Domain 层实现（Entities、Repository 接口、Use Cases）
- [ ] Data 层实现（Models、Data Sources、Repository 实现）
- [ ] 依赖注入配置（get_it + injectable）
- [ ] 基础主题与 UI 设计
- [ ] 日历组件集成

#### Week 2: 核心日程功能

- [ ] Presentation 层实现（BLoC、Pages、Widgets）
- [ ] 首页日历视图实现
- [ ] 添加/编辑日程页面
- [ ] 日程列表页面
- [ ] 日程详情页面
- [ ] 提醒设置功能
- [ ] 基础数据持久化（LocalDataSource）

#### Week 3: 通知功能与测试

- [ ] 通知功能 Domain 层实现
- [ ] 通知功能 Data 层实现（NotificationLocalDataSource）
- [ ] 本地通知服务实现
- [ ] 提醒调度逻辑（Use Case）
- [ ] 通知中心页面
- [ ] 预设提醒模板
- [ ] 数据验证与错误处理
- [ ] 单元测试（Domain Use Cases、Repository）
- [ ] Widget 测试（Presentation Layer）
- [ ] UI 测试与优化

**交付物**: 可用的基础日程规划应用（单机版）

---

### Phase 2: 局域网同步功能 (2-3 周)

**目标**: 实现同一局域网下多设备同步

#### Week 1: 设备发现与连接

- [ ] 同步功能 Domain 层实现（Entities、Repository 接口、Use Cases）
- [ ] 同步功能 Data 层实现（DeviceDiscoveryDataSource、SyncRemoteDataSource）
- [ ] 设备发现服务实现
- [ ] 网络扫描功能
- [ ] 设备列表 UI（Presentation Layer）
- [ ] 设备连接管理
- [ ] 连接状态显示

#### Week 2: 数据同步实现

- [ ] 同步服务架构设计（Repository 实现）
- [ ] HTTP 服务器实现（接收同步请求，RemoteDataSource）
- [ ] HTTP 客户端实现（发送同步请求，RemoteDataSource）
- [ ] 数据序列化/反序列化（Model 层）
- [ ] 冲突解决机制（Use Case）
- [ ] 增量同步逻辑（Use Case）

#### Week 3: 多端提醒与优化

- [ ] 跨设备提醒实现
- [ ] 同步状态管理
- [ ] 同步设置页面
- [ ] 同步历史记录
- [ ] 错误处理与重试机制
- [ ] 性能优化
- [ ] 集成测试

**交付物**: 支持局域网同步的完整应用

---

### Phase 3: 高级功能与优化 (1-2 周)

**目标**: 用户体验优化和高级功能

- [ ] 深色模式
- [ ] 数据备份与恢复
- [ ] 桌面小组件
- [ ] 键盘快捷键（桌面端）
- [ ] 性能优化
- [ ] 国际化支持
- [ ] 更多提醒模板

---

## UI/UX 设计思路

### 设计原则

1. **简洁直观**: 界面简洁，操作流程清晰
2. **快速创建**: 减少操作步骤，支持快速创建日程
3. **视觉反馈**: 清晰的视觉反馈和状态提示
4. **时间可视化**: 直观的日历视图展示日程安排

### 主要页面设计

#### 1. 首页 (Home) - 日历视图

- 顶部：当前日期显示，快速切换（今天、本周、本月）
- 中间：日历组件（月视图/周视图/日视图切换）
  - 日程以点或条形式显示在对应日期
  - 点击日期查看该日期的所有日程
- 底部：快速添加按钮（浮动按钮）
- 侧边：日程列表（可选）

#### 2. 添加/编辑日程页 (Add/Edit Schedule)

- 标题输入框
- 日期时间选择器（开始时间、结束时间）
- 地点输入（可选）
- 分类选择（图标网格）
- 优先级选择（高、中、低）
- 重复规则设置
- 提醒设置
  - 提醒模板快速选择
  - 自定义提醒时间
  - 多时间点提醒
- 备注/描述输入
- 保存/取消按钮

#### 3. 日程列表页 (Schedule List)

- 顶部筛选栏（日期范围、分类、优先级）
- 搜索框
- 按日期分组的日程列表
- 每个日程卡片显示：标题、时间、地点、分类、优先级
- 滑动删除
- 长按编辑
- 点击查看详情

#### 4. 日程详情页 (Schedule Detail)

- 日程完整信息显示
- 编辑按钮
- 删除按钮
- 完成/未完成切换
- 提醒状态显示

#### 5. 通知中心 (Notifications)

- 待提醒日程列表
- 已提醒历史记录
- 通知设置
- 清除通知

#### 6. 同步设置页 (Sync Settings)

- 局域网同步开关
- 设备列表（已连接设备）
- 扫描设备按钮
- 手动添加设备
- 同步设置（自动/手动、同步频率）
- 同步历史记录

#### 7. 设置页 (Settings)

- 提醒模板管理
- 通知设置（声音、震动）
- 数据备份/恢复
- 主题设置（深色/浅色）
- 关于

---

## 开发规范

### 代码规范

- 遵循 Dart/Flutter 官方代码规范
- 使用 `flutter_lints` 进行代码检查
- 函数和类添加注释
- 使用有意义的变量和函数名

### Git 提交规范

- `feat`: 新功能
- `fix`: 修复 bug
- `docs`: 文档更新
- `style`: 代码格式调整
- `refactor`: 代码重构
- `test`: 测试相关
- `chore`: 构建/工具相关

### 分支管理

- `main`: 主分支（稳定版本）
- `develop`: 开发分支
- `feature/*`: 功能分支
- `fix/*`: 修复分支

---

## 测试计划

### 单元测试

- [ ] **Domain Layer 测试**
  - [ ] Use Cases 测试（Mock Repository）
  - [ ] Entities 测试
- [ ] **Data Layer 测试**
  - [ ] Repository 实现测试（Mock Data Sources）
  - [ ] Data Sources 测试（Mock 数据库/网络）
  - [ ] Models 测试（JSON 序列化/反序列化）
- [ ] **Core 层测试**
- [ ] 工具函数测试
  - [ ] 错误处理测试
  - [ ] 提醒时间计算测试

### Widget 测试

- [ ] **Presentation Layer 测试**
  - [ ] BLoC 测试（事件和状态转换）
- [ ] 主要页面组件测试
- [ ] 可复用组件测试
  - [ ] 日历组件测试

### 集成测试

- [ ] 完整用户流程测试（创建日程 -> 提醒 -> 完成）
- [ ] 数据持久化测试（LocalDataSource + Repository）
- [ ] 局域网同步测试（多设备场景，RemoteDataSource + Repository）
- [ ] 通知功能测试（NotificationDataSource + Repository）
- [ ] 端到端测试（从 UI 到数据库的完整流程）

---

## 风险评估与应对

### 技术风险

1. **局域网同步稳定性**

   - 风险：网络不稳定、设备断线
   - 应对：实现重试机制、离线队列、连接状态检测

2. **通知功能兼容性**

   - 风险：不同平台通知 API 差异
   - 应对：使用成熟的跨平台通知库，充分测试各平台

3. **数据冲突处理**

   - 风险：多设备同时修改同一日程
   - 应对：实现时间戳优先策略，提供手动解决冲突界面

4. **性能问题**

   - 风险：大量日程数据影响性能
   - 应对：数据分页加载，优化数据库查询，使用索引

### 功能风险

1. **功能过于复杂**

   - 应对：优先实现 MVP，逐步迭代

2. **用户体验不佳**

   - 应对：收集用户反馈，持续优化 UI/UX

3. **同步延迟**

   - 应对：实现实时同步机制，显示同步状态

---

## 后续优化方向

1. **智能功能**（本地实现）

   - 智能日程建议（基于历史数据）
   - 日程冲突检测
   - 时间安排优化建议

2. **高级提醒**

   - 位置提醒（到达/离开某地时提醒）
   - 天气提醒（根据天气调整提醒）
   - 智能提醒时间（根据用户习惯调整）

3. **集成功能**（本地处理）

   - 日历导入/导出（iCal 格式）
   - 日程分享（生成链接或二维码）
   - 语音输入创建日程

4. **数据分析**

   - 日程统计（完成率、时间分布）
   - 习惯分析
   - 效率报告

---

## 项目时间线总结

| 阶段    | 时间   | 主要任务       | 状态   |
| ------- | ------ | -------------- | ------ |
| Phase 1 | 2-3 周 | MVP 基础功能   | 待开始 |
| Phase 2 | 2-3 周 | 局域网同步功能 | 待开始 |
| Phase 3 | 1-2 周 | 高级功能与优化 | 待开始 |

**预计总开发时间**: 5-8 周（MVP 到完整功能）

---

## 参考资料

- [Flutter 官方文档](https://docs.flutter.dev/)
- [Material Design 3](https://m3.material.io/)
- [flutter_bloc 文档](https://bloclibrary.dev/)
- [get_it 文档](https://pub.dev/packages/get_it)
- [injectable 文档](https://pub.dev/packages/injectable)
- [dartz 文档](https://pub.dev/packages/dartz)
- [ObjectBox 文档](https://docs.objectbox.io/)
- [ObjectBox Flutter 文档](https://docs.objectbox.io/flutter)
- [json_serializable 文档](https://pub.dev/packages/json_serializable)
- [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)
- [table_calendar](https://pub.dev/packages/table_calendar)

---

**文档版本**: v2.0  
**最后更新**: 2024  
**维护者**: 开发团队
