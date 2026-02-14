import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/providers/order_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../application/support_provider.dart';
import '../../data/models/support_ticket_model.dart';

class CreateTicketScreen extends StatefulWidget {
  const CreateTicketScreen({super.key});

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  String? _selectedOrderId;

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<SupportProvider>();
    final ticket = await provider.createTicket(
      subject: _subjectController.text.trim(),
      category: TicketCategory.orderIssue,
      priority: TicketPriority.low,
      message: _messageController.text.trim(),
      orderId:
          _selectedOrderId != null ? int.tryParse(_selectedOrderId!) : null,
    );

    if (!mounted) return;

    if (ticket != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.supportTicketCreated),
          backgroundColor: AppColors.success,
        ),
      );
      context.pop();
    } else if (provider.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error!),
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
        title: Text(l10n.supportCreateTicket),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Consumer<SupportProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order selector
                  _buildSectionLabel(l10n.supportRelatedOrder, secondaryColor),
                  const SizedBox(height: 8),
                  _buildOrderDropdown(
                      isDark, surfaceColor, borderColor, textColor, l10n),
                  const SizedBox(height: 20),

                  // Subject
                  _buildSectionLabel(l10n.supportSubject, secondaryColor),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _subjectController,
                    style: TextStyle(color: textColor, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: l10n.supportSubjectHint,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.supportSubjectRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Message
                  _buildSectionLabel(l10n.supportMessage, secondaryColor),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _messageController,
                    style: TextStyle(color: textColor, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: l10n.supportMessageHint,
                      alignLabelWithHint: true,
                    ),
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.supportMessageRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: provider.isCreating ? null : _submit,
                      child: provider.isCreating
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(l10n.supportSubmitTicket),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionLabel(String label, Color color) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }

  Widget _buildOrderDropdown(
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color textColor,
    AppLocalizations l10n,
  ) {
    final orderProvider = context.watch<OrderProvider>();
    final allOrders = [...orderProvider.activeOrders, ...orderProvider.completedOrders];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          isExpanded: true,
          value: _selectedOrderId,
          hint: Text(
            l10n.supportSelectOrder,
            style: TextStyle(
                color: isDark
                    ? AppColors.darkTextHint
                    : AppColors.lightTextHint,
                fontSize: 14),
          ),
          dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightBg,
          style: TextStyle(color: textColor, fontSize: 14),
          items: [
            DropdownMenuItem<String?>(
              value: null,
              child: Text(l10n.supportNoOrder,
                  style: TextStyle(color: textColor, fontSize: 14)),
            ),
            ...allOrders.map((order) => DropdownMenuItem<String?>(
                  value: order.id,
                  child: Text(
                    '${l10n.orderId} #${order.id}',
                    style: TextStyle(color: textColor, fontSize: 14),
                  ),
                )),
          ],
          onChanged: (value) => setState(() => _selectedOrderId = value),
        ),
      ),
    );
  }

}
