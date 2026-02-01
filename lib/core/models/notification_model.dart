class NotificationModel {
  final int id;
  final String title;
  final String body;
  final Map<String, dynamic>? data;
  final bool isRead;
  final DateTime? readAt;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.data,
    required this.isRead,
    this.readAt,
    required this.createdAt,
  });

  /// Helper to read a value from the data payload
  String? dataValue(String key) {
    if (data == null) return null;
    return data![key]?.toString();
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    // data can be a Map, a String, or null from the API
    Map<String, dynamic>? parsedData;
    final rawData = json['data'];
    if (rawData is Map<String, dynamic>) {
      parsedData = rawData;
    } else if (rawData is String) {
      // Legacy: if it was stored as a JSON string, ignore it
      parsedData = null;
    }

    return NotificationModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      data: parsedData,
      isRead: json['is_read'] as bool? ?? false,
      readAt: json['read_at'] != null
          ? DateTime.tryParse(json['read_at'] as String)?.toLocal()
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String).toLocal()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'data': data,
      'is_read': isRead,
      'read_at': readAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  NotificationModel copyWith({
    int? id,
    String? title,
    String? body,
    Map<String, dynamic>? data,
    bool? isRead,
    DateTime? readAt,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      data: data ?? this.data,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
