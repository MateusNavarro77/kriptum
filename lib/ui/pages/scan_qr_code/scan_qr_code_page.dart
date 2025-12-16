import 'package:flutter/material.dart';
import 'package:kriptum/ui/pages/receive/receive_page.dart';
import 'package:kriptum/ui/tokens/spacings.dart';
import 'package:kriptum/ui/widgets/scan_qr_code_widget.dart';

class ScanQrCodePage extends StatelessWidget {
  const ScanQrCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Camera covering entire screen
          ScanQrCodeWidget(),
          // Content overlay with transparency
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacings.horizontalPadding,
                vertical: 20,
              ),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Scan QR Code',
                                style: TextStyle(fontSize: 24, color: Colors.white),
                              ),
                              Text(
                                'Use your camera to scan a QR code',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.close, color: Colors.white))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SegmentedButton(
                            onSelectionChanged: (p0) {
                              if (p0.isEmpty) return;
                              if (p0.first == 2) {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => ReceivePage(),
                                  ),
                                );
                              }
                            },
                            segments: const [
                              ButtonSegment<int>(value: 1, label: Text('Scan QR code')),
                              ButtonSegment<int>(value: 2, label: Text('Your QR code'))
                            ],
                            selected: const {
                              1
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
