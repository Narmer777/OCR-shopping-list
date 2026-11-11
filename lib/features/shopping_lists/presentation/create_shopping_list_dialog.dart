import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../widgets/app_action_button.dart';

class CreateShoppingListDialog extends StatefulWidget {
  const CreateShoppingListDialog({super.key});

  @override
  State<CreateShoppingListDialog> createState() =>
      _CreateShoppingListDialogState();
}

class _CreateShoppingListDialogState extends State<CreateShoppingListDialog> {
  static const _maxNameLength = 50;

  final _nameController = TextEditingController();
  bool _submitted = false;

  bool get _canCreate => _nameController.text.trim().isNotEmpty;

  void _submit() {
    if (!_canCreate || _submitted) return;
    _submitted = true;
    Navigator.of(context).pop(_nameController.text.trim());
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: colors.onSurface, width: 2),
    );

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface,
            border: Border.all(color: colors.onSurface, width: 2),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: colors.onSurface, offset: const Offset(4, 4)),
            ],
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Semantics(
                  header: true,
                  child: Text.rich(
                    const TextSpan(
                      text: 'Новый ',
                      children: [
                        TextSpan(
                          text: 'список',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    style: TextStyle(
                      fontFamily: 'Lora',
                      fontSize: 24,
                      height: 1.2,
                      fontWeight: FontWeight.w700,
                      color: colors.onSurface,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _nameController,
                  autofocus: true,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.done,
                  maxLength: _maxNameLength,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  cursorColor: colors.primary,
                  decoration: InputDecoration(
                    labelText: 'Название',
                    hintText: 'Продукты на неделю',
                    filled: true,
                    fillColor: colors.surface,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    enabledBorder: border,
                    focusedBorder: border,
                    floatingLabelStyle: TextStyle(color: colors.onSurface),
                  ),
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 24),
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    AppActionButton(
                      label: 'Отмена',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    AppActionButton(
                      label: 'Создать',
                      isPrimary: true,
                      onPressed: _canCreate ? _submit : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
