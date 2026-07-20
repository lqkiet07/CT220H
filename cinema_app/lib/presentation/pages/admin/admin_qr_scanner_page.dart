import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/theme/app_colors.dart';

enum ScannerState { scanning, valid, invalid }

class AdminQrScannerPage extends StatefulWidget {
  const AdminQrScannerPage({super.key});

  @override
  State<AdminQrScannerPage> createState() => _AdminQrScannerPageState();
}

class _AdminQrScannerPageState extends State<AdminQrScannerPage> {
  ScannerState _scannerState = ScannerState.scanning;
  String _scannedCode = '';
  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_scannerState != ScannerState.scanning) return;
    
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
      final String code = barcodes.first.rawValue!;
      _processScannedCode(code);
    }
  }

  void _processScannedCode(String code) {
    setState(() {
      _scannedCode = code;
      // Regex check format: TICKET-XXXXXX (6 digits)
      final bool isValid = RegExp(r'^TICKET-\d{6}$').hasMatch(code);
      if (isValid) {
        _scannerState = ScannerState.valid;
      } else {
        _scannerState = ScannerState.invalid;
      }
    });
  }

  void _resetScanner() {
    setState(() {
      _scannerState = ScannerState.scanning;
      _scannedCode = '';
    });
  }

  void _simulateScan() {
    // Generate a random ticket code to simulate a successful ticket scan
    final randomId = Random().nextInt(900000) + 100000;
    final mockTicketCode = 'TICKET-$randomId';
    _processScannedCode(mockTicketCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Soát Vé QR', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // 1. Live Camera Scanner View (only active when scanning)
          if (_scannerState == ScannerState.scanning)
            MobileScanner(
              controller: _scannerController,
              onDetect: _onDetect,
            ),

          // 2. Scanner Layout Overlay (view finder/scanning guidelines)
          if (_scannerState == ScannerState.scanning)
            _buildScannerOverlay(),

          // 3. Status View (Success or Error result)
          if (_scannerState != ScannerState.scanning)
            _buildStatusView(),
        ],
      ),
    );
  }

  Widget _buildScannerOverlay() {
    return Stack(
      children: [
        // Semi-transparent background surrounding the scanner box
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.6),
            BlendMode.srcOut,
          ),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Target Box Border Outline (animated or clean green/red corners)
        Align(
          alignment: Alignment.center,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white30, width: 2),
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),

        // Scanning Guidelines & Simulation Button
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 60.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Đưa mã QR trên vé vào khung hình',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Hệ thống sẽ tự động quét và xác thực',
                  style: TextStyle(color: Colors.white54, fontSize: 14),
                ),
                const SizedBox(height: 32),
                
                // NÚT GIẢ LẬP QUÉT - PHỤC VỤ PRESENTATION/DEMO MÁY ẢO
                ElevatedButton.icon(
                  onPressed: _simulateScan,
                  icon: const Icon(Icons.flash_on_rounded, color: Colors.black),
                  label: const Text(
                    'GIẢ LẬP QUÉT (DEMO)',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusView() {
    final bool isValid = _scannerState == ScannerState.valid;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: (isValid ? Colors.green : Colors.red).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isValid ? Icons.check_circle_rounded : Icons.cancel_rounded,
                size: 100,
                color: isValid ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              isValid ? 'VÉ HỢP LỆ' : 'VÉ KHÔNG HỢP LỆ',
              style: TextStyle(
                color: isValid ? Colors.green : Colors.red,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: [
                  const Text(
                    'Nội dung quét được:',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _scannedCode,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            
            // NÚT QUÉT TIẾP
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _resetScanner,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text(
                  'QUÉT VÉ TIẾP THEO',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
