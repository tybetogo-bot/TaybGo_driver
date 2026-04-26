enum TicketCategory {
  general('OTHER'),
  orderIssue('ORDER'),
  payment('PAYMENT'),
  delivery('DELIVERY'),
  accountIssue('ACCOUNT'),
  technical('OTHER'),
  other('OTHER');

  const TicketCategory(this.apiValue);
  final String apiValue;

  static TicketCategory fromApi(String value) {
    return TicketCategory.values.firstWhere(
      (e) => e.apiValue == value.toUpperCase(),
      orElse: () => TicketCategory.general,
    );
  }
}

enum TicketPriority {
  low('LOW'),
  medium('MEDIUM'),
  high('HIGH'),
  urgent('URGENT');

  const TicketPriority(this.apiValue);
  final String apiValue;

  static TicketPriority fromApi(String value) {
    return TicketPriority.values.firstWhere(
      (e) => e.apiValue == value.toUpperCase(),
      orElse: () => TicketPriority.medium,
    );
  }
}

enum TicketStatus {
  open('OPEN'),
  inProgress('IN_PROGRESS'),
  waitingOnCustomer('WAITING_ON_CUSTOMER'),
  resolved('RESOLVED'),
  closed('CLOSED');

  const TicketStatus(this.apiValue);
  final String apiValue;

  static TicketStatus fromApi(String value) {
    return TicketStatus.values.firstWhere(
      (e) => e.apiValue == value.toUpperCase(),
      orElse: () => TicketStatus.open,
    );
  }
}

enum AuthorRole {
  driver('DRIVER'),
  customer('CUSTOMER'),
  seller('SELLER'),
  staff('STAFF'),
  system('SYSTEM');

  const AuthorRole(this.apiValue);
  final String apiValue;

  static AuthorRole fromApi(String value) {
    return AuthorRole.values.firstWhere(
      (e) => e.apiValue == value.toUpperCase(),
      orElse: () => AuthorRole.driver,
    );
  }
}

/// Attachment on a ticket message
class TicketAttachment {
  final int id;
  final String url;
  final String? fileName;

  const TicketAttachment({required this.id, required this.url, this.fileName});

  factory TicketAttachment.fromJson(Map<String, dynamic> json) {
    return TicketAttachment(
      id: json['id'] ?? 0,
      url: json['file_url'] ?? json['url'] ?? json['file'] ?? '',
      fileName: json['file_name'] ?? json['filename'],
    );
  }
}

/// A single message within a ticket
class TicketMessage {
  final int id;
  final String body;
  final AuthorRole authorRole;
  final String? authorName;
  final DateTime createdAt;
  final List<TicketAttachment> attachments;

  const TicketMessage({
    required this.id,
    required this.body,
    required this.authorRole,
    this.authorName,
    required this.createdAt,
    this.attachments = const [],
  });

  factory TicketMessage.fromJson(Map<String, dynamic> json) {
    return TicketMessage(
      id: json['id'] ?? 0,
      body: json['body'] ?? json['content'] ?? json['message'] ?? '',
      authorRole: AuthorRole.fromApi(
        json['author_role'] ?? json['sender_type'] ?? 'USER',
      ),
      authorName: json['author_name'] ?? json['sender_name'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      attachments:
          (json['attachments'] as List?)
              ?.map((a) => TicketAttachment.fromJson(a))
              .toList() ??
          [],
    );
  }
}

/// A support ticket
class SupportTicket {
  final int id;
  final String subject;
  final TicketCategory category;
  final TicketPriority priority;
  final TicketStatus status;
  final int? orderId;
  final String? orderDisplay;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<TicketMessage> messages;

  const SupportTicket({
    required this.id,
    required this.subject,
    required this.category,
    required this.priority,
    required this.status,
    this.orderId,
    this.orderDisplay,
    required this.createdAt,
    required this.updatedAt,
    this.messages = const [],
  });

  factory SupportTicket.fromJson(Map<String, dynamic> json) {
    return SupportTicket(
      id: json['id'] ?? 0,
      subject: json['subject'] ?? json['title'] ?? '',
      category: TicketCategory.fromApi(json['category'] ?? 'GENERAL'),
      priority: TicketPriority.fromApi(json['priority'] ?? 'MEDIUM'),
      status: TicketStatus.fromApi(json['status'] ?? 'OPEN'),
      orderId: json['order'] ?? json['order_id'],
      orderDisplay: json['order_display'] ?? json['order_number'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      messages:
          (json['messages'] as List?)
              ?.map((m) => TicketMessage.fromJson(m))
              .toList() ??
          [],
    );
  }

  bool get isClosed =>
      status == TicketStatus.closed || status == TicketStatus.resolved;
}
