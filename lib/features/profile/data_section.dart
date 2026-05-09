import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/translations.dart';
import '../../services/backup_service.dart';
import '../../services/share_card_service.dart';
import '../../state/body_photo_repository_provider.dart';
import '../../state/bodyweight_repository_provider.dart';
import '../../state/exercise_catalog_provider.dart';
import '../../state/preferences_provider.dart';
import '../../state/session_repository_provider.dart';
import '../../state/template_repository_provider.dart';

class DataSection extends ConsumerWidget {
  const DataSection({super.key});

  void _invalidateAll(WidgetRef ref) {
    ref.invalidate(pastSessionsProvider);
    ref.invalidate(templatesProvider);
    ref.invalidate(customExercisesProvider);
    ref.invalidate(bodyweightEntriesProvider);
    ref.invalidate(bodyPhotosProvider);
    ref.invalidate(experienceLevelProvider);
    ref.invalidate(healthEnabledProvider);
    ref.invalidate(notificationsEnabledProvider);
    ref.invalidate(restTimerSecondsProvider);
    ref.invalidate(inactivityNudgeDaysProvider);
    ref.invalidate(showRirProvider);
    ref.invalidate(profileNameProvider);
    ref.invalidate(profileHeightCmProvider);
    ref.invalidate(profileGoalProvider);
    ref.invalidate(localeTagProvider);
    ref.invalidate(themeModeTagProvider);
    ref.invalidate(weightUnitProvider);
    ref.invalidate(lengthUnitProvider);
  }

  Future<void> _exportCsvFlow(BuildContext context) async {
    final l = tr(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final csv = await BackupService.instance.exportSetsToCsv();
      final stamp = DateTime.now().toIso8601String().split('T').first;
      final result = await ShareCardService.instance.saveOrDownload(
        Uint8List.fromList(utf8.encode(csv)),
        'gymwhenyouready_sets_$stamp.csv',
      );
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            kIsWeb ? l.dataDownloaded : l.dataSavedTo(result),
          ),
        ),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(l.dataExportFailed(e.toString()))),
      );
    }
  }

  Future<void> _exportFlow(BuildContext context) async {
    final json = await BackupService.instance.exportToJsonString();
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (_) => _ExportDialog(json: json),
    );
  }

  Future<void> _importFlow(BuildContext context, WidgetRef ref) async {
    final l = tr(context);
    final messenger = ScaffoldMessenger.of(context);
    final json = await showDialog<String>(
      context: context,
      builder: (_) => const _ImportDialog(),
    );
    if (json == null) return;
    try {
      await BackupService.instance.importFromJsonString(json);
      _invalidateAll(ref);
      messenger.showSnackBar(
        SnackBar(content: Text(l.dataImportComplete)),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(l.dataImportFailed(e.toString()))),
      );
    }
  }

  Future<void> _deleteAllFlow(BuildContext context, WidgetRef ref) async {
    final l = tr(context);
    final messenger = ScaffoldMessenger.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(l.dataDeleteAllPrompt),
        content: Text(l.dataDeleteAllConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: Text(l.actionCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(dialogCtx).colorScheme.error,
              foregroundColor: Theme.of(dialogCtx).colorScheme.onError,
            ),
            onPressed: () => Navigator.pop(dialogCtx, true),
            child: Text(l.actionDeleteEverything),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await BackupService.instance.deleteAll();
    _invalidateAll(ref);
    messenger.showSnackBar(
      SnackBar(content: Text(l.dataAllDeleted)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = tr(context);
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.download_outlined),
          title: Text(l.dataExportJson),
          subtitle: Text(l.dataExportJsonHelp),
          onTap: () => _exportFlow(context),
        ),
        ListTile(
          leading: const Icon(Icons.table_chart_outlined),
          title: Text(l.dataExportCsv),
          subtitle: Text(l.dataExportCsvHelp),
          onTap: () => _exportCsvFlow(context),
        ),
        ListTile(
          leading: const Icon(Icons.upload_outlined),
          title: Text(l.dataImport),
          subtitle: Text(l.dataImportHelp),
          onTap: () => _importFlow(context, ref),
        ),
        ListTile(
          leading: Icon(
            Icons.delete_forever_outlined,
            color: Theme.of(context).colorScheme.error,
          ),
          title: Text(
            l.dataDeleteAll,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          subtitle: Text(l.dataDeleteAllHelp),
          onTap: () => _deleteAllFlow(context, ref),
        ),
      ],
    );
  }
}

class _ExportDialog extends StatelessWidget {
  const _ExportDialog({required this.json});
  final String json;

  @override
  Widget build(BuildContext context) {
    final l = tr(context);
    return AlertDialog(
      title: Text(l.dataBackupTitle),
      content: SizedBox(
        width: 600,
        child: SingleChildScrollView(
          child: SelectableText(
            json,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.actionClose),
        ),
        FilledButton.icon(
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: json));
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l.dataCopied)),
            );
          },
          icon: const Icon(Icons.copy),
          label: Text(l.actionCopy),
        ),
      ],
    );
  }
}

class _ImportDialog extends StatefulWidget {
  const _ImportDialog();

  @override
  State<_ImportDialog> createState() => _ImportDialogState();
}

class _ImportDialogState extends State<_ImportDialog> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null) {
      setState(() => _ctrl.text = data!.text!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = tr(context);
    return AlertDialog(
      title: Text(l.dataImportTitle),
      content: SizedBox(
        width: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l.dataImportWarning,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _ctrl,
              maxLines: 14,
              minLines: 6,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: l.dataImportHint,
              ),
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ],
        ),
      ),
      actions: [
        TextButton.icon(
          onPressed: _pasteFromClipboard,
          icon: const Icon(Icons.paste),
          label: Text(l.actionPaste),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.actionCancel),
        ),
        FilledButton.icon(
          onPressed: () {
            final text = _ctrl.text.trim();
            if (text.isEmpty) return;
            Navigator.pop(context, text);
          },
          icon: const Icon(Icons.check),
          label: Text(l.actionImport),
        ),
      ],
    );
  }
}
