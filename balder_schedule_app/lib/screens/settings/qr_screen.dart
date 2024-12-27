import 'dart:io';
import 'package:balder_schedule_app/generated/l10n.dart';
import 'package:balder_schedule_app/globals.dart';
import 'package:balder_schedule_app/screens/settings/qr_scanner_screen.dart';
import 'package:balder_schedule_app/utils/cloud_functions.dart';
import 'package:balder_schedule_app/utils/margin_screen.dart';
import 'package:balder_schedule_app/widgets/page_header_child.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:path/path.dart' as path;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class QrScreen extends StatelessWidget {
  const QrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageHeaderChild(title: S.of(context).qrTitle),
      body: MarginScreen(child: const QrContent()),
    );
  }
}

class QrContent extends StatefulWidget {
  const QrContent({super.key});

  @override
  State<QrContent> createState() => _QrContentState();
}

class _QrContentState extends State<QrContent> {
  bool _isUploading = false;
  String? _downloadLink;

  Widget _buildQrCode(String? link) {
    if (link == null || link.isEmpty) {
      return const Center(
        child: Text(
          'Ссылка не доступна',
          style: TextStyle(color: Colors.red, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      );
    }

    return QrImageView(
      eyeStyle: QrEyeStyle(
        eyeShape: QrEyeShape.square,
        color: Theme.of(context).colorScheme.primary,
      ),
      dataModuleStyle: QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.square,
        color: Theme.of(context).colorScheme.secondary,
      ),
      data: link,
      version: QrVersions.auto,
      size: 364,
      gapless: false,
      errorStateBuilder: (context, error) {
        return const Center(
          child: Text(
            'Ошибка при создании QR-кода',
            style: TextStyle(color: Colors.red),
          ),
        );
      },
    );
  }

  Future<void> _uploadDatabase() async {
    final cloudFunctions = CloudFunctions();
    final filePath = path.join(dbPath, dbName);
    final file = File(filePath);

    if (!file.existsSync()) {
      setState(() {
        _isUploading = false;
      });
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      await cloudFunctions.uploadFile(filePath, dbName);
      final downloadLink = await cloudFunctions.generatePublicLink(dbName);

      setState(() {
        _downloadLink = downloadLink;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('База данных успешно отправлена!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при отправке базы данных: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  void _shareLink() async {
    if (_downloadLink != null) {
      try {
        await Share.share(_downloadLink!);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка при попытке поделиться: $e')),
          );
        }
      }
    }
  }

  Future<void> _handleShareButtonPress() async {
    await _uploadDatabase();
    if (_downloadLink != null) {
      _shareLink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Gap(12),
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      // Открытие экрана QR сканера
                      final scannedData = await Navigator.push<String>(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const QRScannerScreen()),
                      );

                      if (scannedData != null) {
                        final cloudFunctions = CloudFunctions();
                        try {
                          await cloudFunctions.downloadFile(
                              scannedData, path.join(dbPath, dbName));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Расписание обновлено')),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Ошибка при обновлении расписания')),
                          );
                        }
                      }
                    },
                    icon:
                        const Icon(Icons.video_camera_front_outlined, size: 18),
                    label: Text(S.of(context).scanNewScheduleTitle),
                  ),
                ),
                const Gap(12),
                Container(
                  width: 364,
                  height: 364,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: _buildQrCode(_downloadLink),
                  ),
                ),
                const Gap(12),
                // Единственная кнопка внизу
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isUploading ? null : _handleShareButtonPress,
                    icon: const Icon(Icons.share_outlined, size: 18),
                    label: Text(S.of(context).shareScheduleTitle),
                  ),
                ),
              ],
            ),
          ),
          const Gap(12),
        ],
      ),
    );
  }
}
