import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../application/support_provider.dart';
import '../../data/models/support_ticket_model.dart';

class TicketDetailScreen extends StatefulWidget {
  final String ticketId;

  const TicketDetailScreen({super.key, required this.ticketId});

  @override
  State<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final id = int.tryParse(widget.ticketId);
      if (id != null) {
        context.read<SupportProvider>().fetchTicketDetail(id);
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final body = _messageController.text.trim();
    if (body.isEmpty) return;

    _messageController.clear();
    final success = await context.read<SupportProvider>().sendMessage(body);

    if (success) {
      _scrollToBottom();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.somethingWentWrong),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final secondaryColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.supportTicketDetail),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Consumer<SupportProvider>(
        builder: (context, provider, _) {
          if (provider.isLoadingDetail) {
            return const Center(child: CircularProgressIndicator());
          }

          final ticket = provider.currentTicket;
          if (ticket == null) {
            return Center(
              child: Text(
                provider.error ?? l10n.somethingWentWrong,
                style: TextStyle(color: secondaryColor),
              ),
            );
          }

          // Auto-scroll when messages change
          _scrollToBottom();

          return Column(
            children: [
              // Ticket info header
              _buildTicketHeader(
                  ticket, isDark, textColor, secondaryColor, surfaceColor, l10n),
              Divider(height: 1, color: borderColor),

              // Messages
              Expanded(
                child: ticket.messages.isEmpty
                    ? Center(
                        child: Text(
                          l10n.supportNoMessages,
                          style: TextStyle(color: secondaryColor),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        itemCount: ticket.messages.length,
                        itemBuilder: (context, index) {
                          final message = ticket.messages[index];
                          return _buildMessageBubble(
                            message,
                            isDark,
                            textColor,
                            secondaryColor,
                            surfaceColor,
                          );
                        },
                      ),
              ),

              // Input bar
              if (!ticket.isClosed)
                _buildInputBar(isDark, surfaceColor, borderColor, textColor,
                    secondaryColor, l10n, provider.isSending)
              else
                _buildClosedBanner(l10n, surfaceColor, secondaryColor),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTicketHeader(
    SupportTicket ticket,
    bool isDark,
    Color textColor,
    Color secondaryColor,
    Color surfaceColor,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: surfaceColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  ticket.subject,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ),
              _buildStatusChip(ticket.status, l10n),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '#${ticket.id}',
                style: TextStyle(fontSize: 12, color: secondaryColor),
              ),
              const SizedBox(width: 12),
              _buildPriorityDot(ticket.priority),
              const SizedBox(width: 4),
              Text(
                _priorityLabel(ticket.priority, l10n),
                style: TextStyle(fontSize: 12, color: secondaryColor),
              ),
              if (ticket.orderDisplay != null) ...[
                const SizedBox(width: 12),
                Icon(Icons.receipt_outlined, size: 12, color: secondaryColor),
                const SizedBox(width: 4),
                Text(
                  ticket.orderDisplay!,
                  style: TextStyle(fontSize: 12, color: secondaryColor),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(TicketStatus status, AppLocalizations l10n) {
    Color bgColor;
    Color fgColor;
    String label;

    switch (status) {
      case TicketStatus.open:
        bgColor = AppColors.info.withValues(alpha: 0.1);
        fgColor = AppColors.info;
        label = l10n.supportStatusOpen;
      case TicketStatus.inProgress:
        bgColor = AppColors.warning.withValues(alpha: 0.1);
        fgColor = AppColors.warning;
        label = l10n.supportStatusInProgress;
      case TicketStatus.closed:
        bgColor = AppColors.offline.withValues(alpha: 0.1);
        fgColor = AppColors.offline;
        label = l10n.supportStatusClosed;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style:
            TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fgColor),
      ),
    );
  }

  Widget _buildPriorityDot(TicketPriority priority) {
    Color color;
    switch (priority) {
      case TicketPriority.low:
        color = AppColors.success;
      case TicketPriority.medium:
        color = AppColors.warning;
      case TicketPriority.high:
        color = AppColors.error;
    }
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  String _priorityLabel(TicketPriority priority, AppLocalizations l10n) {
    switch (priority) {
      case TicketPriority.low:
        return l10n.supportPriorityLow;
      case TicketPriority.medium:
        return l10n.supportPriorityMedium;
      case TicketPriority.high:
        return l10n.supportPriorityHigh;
    }
  }

  Widget _buildMessageBubble(
    TicketMessage message,
    bool isDark,
    Color textColor,
    Color secondaryColor,
    Color surfaceColor,
  ) {
    final isUser = message.authorRole == AuthorRole.user;
    final isSystem = message.authorRole == AuthorRole.system;

    if (isSystem) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              message.body,
              style: TextStyle(fontSize: 12, color: secondaryColor),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isUser
              ? AppColors.primary.withValues(alpha: 0.15)
              : surfaceColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isUser && message.authorName != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  message.authorName!,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            Text(
              message.body,
              style: TextStyle(fontSize: 14, color: textColor),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.createdAt),
              style: TextStyle(fontSize: 10, color: secondaryColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar(
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color textColor,
    Color secondaryColor,
    AppLocalizations l10n,
    bool isSending,
  ) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 8,
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBg : AppColors.lightBg,
        border: Border(top: BorderSide(color: borderColor)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              style: TextStyle(color: textColor, fontSize: 14),
              decoration: InputDecoration(
                hintText: l10n.supportTypeMessage,
                hintStyle: TextStyle(color: secondaryColor, fontSize: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: surfaceColor,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
              maxLines: null,
            ),
          ),
          const SizedBox(width: 4),
          isSending
              ? const Padding(
                  padding: EdgeInsets.all(12),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send_rounded),
                  color: AppColors.primary,
                ),
        ],
      ),
    );
  }

  Widget _buildClosedBanner(
    AppLocalizations l10n,
    Color surfaceColor,
    Color secondaryColor,
  ) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      color: surfaceColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_outlined, size: 16, color: secondaryColor),
          const SizedBox(width: 8),
          Text(
            l10n.supportTicketClosed,
            style: TextStyle(fontSize: 13, color: secondaryColor),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
