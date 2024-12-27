import 'dart:io';
import 'package:balder_schedule_app/generated/l10n.dart';
import 'package:balder_schedule_app/globals.dart';
import 'package:balder_schedule_app/screens/settings/qr_scanner_screen.dart';
import 'package:balder_schedule_app/services/permission_camera.dart';
import 'package:balder_schedule_app/utils/cloud_functions.dart';
import 'package:balder_schedule_app/utils/margin_screen.dart';
import 'package:balder_schedule_app/widgets/flash/snackbar_handler.dart';
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
      return const SizedBox();
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
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при генерации кода: $e')),
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
      _showShareDialog();
    }
  }

  // Открытие модального окна с QR-кодом и кнопкой "Поделиться ссылкой"
  void _showShareDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(S.of(context).shareScheduleTitle),
                const Gap(12),
                _buildQrCode(_downloadLink),
                const Gap(12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _shareLink,
                    icon: const Icon(Icons.share_outlined),
                    label: Text('Поделиться ссылкой'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
                // Проверяем, что устройство не является телефоном
                if (Platform.isAndroid || Platform.isIOS) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final cameraAvailable =
                            await PermissionCamera.checkCameraPermission(
                                context);

                        if (cameraAvailable && context.mounted) {
                          // Открытие экрана QR сканера
                          final scannedData = await Navigator.push<String>(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const QRScannerScreen()),
                          );

                          if (scannedData != null) {
                            final cloudFunctions = CloudFunctions();

                            if (context.mounted) {
                              SnackbarHandler.handleAction(
                                context,
                                () async {
                                  await cloudFunctions.downloadFile(
                                      scannedData, path.join(dbPath, dbName));
                                },
                                'Расписание обновлено',
                                'Ошибка при обновлении расписания',
                              );
                            }
                          }
                        }
                      },
                      icon: const Icon(Icons.video_camera_front_outlined,
                          size: 18),
                      label: Text(S.of(context).scanNewScheduleTitle),
                    ),
                  ),
                  const Gap(12),
                ],
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: _isUploading ? null : _handleShareButtonPress,
                    child: Text(S.of(context).shareScheduleTitle),
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
