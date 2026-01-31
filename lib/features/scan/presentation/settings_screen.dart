import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/scan_settings_provider.dart';

/// スキャン詳細設定画面
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(scanSettingsProvider);
    final notifier = ref.read(scanSettingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('スキャン詳細設定'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _buildSectionHeader(context, '基本設定'),
          ListTile(
            title: const Text('読み取り種別'),
            subtitle: Text(_getFilterName(settings.typeFilter)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showFilterDialog(context, notifier, settings.typeFilter),
          ),
          ListTile(
            title: const Text('スキャン範囲モード'),
            subtitle: Text(_getRangeModeName(settings.rangeMode)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showRangeModeDialog(context, notifier, settings.rangeMode),
          ),
          
          const Divider(),
          _buildSectionHeader(context, '1Dバリデーション（高度な設定）'),
          SwitchListTile(
            title: const Text('チェックデジット検証'),
            subtitle: const Text('JAN-13などの整合性を確認します'),
            value: settings.enableCheckDigit,
            onChanged: notifier.toggleCheckDigit,
          ),
          SwitchListTile(
            title: const Text('パリティチェック'),
            subtitle: const Text('簡易的なパリティ検証を行います'),
            value: settings.enableParityCheck,
            onChanged: notifier.toggleParityCheck,
          ),
          SwitchListTile(
            title: const Text('スタート/ストップ文字検証'),
            subtitle: const Text('コード端の不備を検知します'),
            value: settings.enableStartStopCheck,
            onChanged: notifier.toggleStartStopCheck,
          ),
          
          const Divider(),
          _buildSectionHeader(context, 'エクスポート設定'),
          ListTile(
            title: const Text('ログ送信先メールアドレス'),
            subtitle: Text(settings.exportEmail.isEmpty ? '未設定' : settings.exportEmail),
            trailing: const Icon(Icons.edit),
            onTap: () => _showEmailDialog(context, notifier, settings.exportEmail),
          ),
          
          const Divider(),
          _buildSectionHeader(context, 'その他'),
          ListTile(
            title: const Text('重複読み取りガード'),
            subtitle: Text('${settings.duplicateTimeoutMs} ms 以内は同一コードを無視'),
            onTap: () {
              // 簡単な数値入力ダイアログ等は省略（現状）
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _getFilterName(BarcodeTypeFilter filter) {
    switch (filter) {
      case BarcodeTypeFilter.auto: return '自動（1D/2D両方）';
      case BarcodeTypeFilter.only1D: return '1次元コードのみ';
      case BarcodeTypeFilter.only2D: return '2次元コードのみ';
    }
  }

  String _getRangeModeName(ScanRangeMode mode) {
    switch (mode) {
      case ScanRangeMode.singleNarrow: return '単一（中央の狭い範囲）';
      case ScanRangeMode.multiFull: return '複数（全画面）';
    }
  }

  void _showFilterDialog(BuildContext context, ScanSettingsNotifier notifier, BarcodeTypeFilter current) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('読み取り種別を選択'),
        children: BarcodeTypeFilter.values.map((v) => SimpleDialogOption(
          onPressed: () {
            notifier.updateTypeFilter(v);
            Navigator.pop(context);
          },
          child: Text(_getFilterName(v)),
        )).toList(),
      ),
    );
  }

  void _showRangeModeDialog(BuildContext context, ScanSettingsNotifier notifier, ScanRangeMode current) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('スキャン範囲を選択'),
        children: ScanRangeMode.values.map((v) => SimpleDialogOption(
          onPressed: () {
            notifier.updateRangeMode(v);
            Navigator.pop(context);
          },
          child: Text(_getRangeModeName(v)),
        )).toList(),
      ),
    );
  }

  void _showEmailDialog(BuildContext context, ScanSettingsNotifier notifier, String current) {
    final controller = TextEditingController(text: current);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('メールアドレス設定'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: '送信先メールアドレス',
            hintText: 'example@domain.com',
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              notifier.updateExportEmail(controller.text.trim());
              Navigator.pop(context);
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }
}
