// ===== ADDED BY ANTIGRAVITY =====
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class LivenessPage extends StatefulWidget {
  const LivenessPage({super.key});

  @override
  State<LivenessPage> createState() => _LivenessPageState();
}

class _LivenessPageState extends State<LivenessPage> {
  CameraController? _cameraController;
  late FaceDetector _faceDetector;
  bool _isInitializing = true;
  bool _isProcessing = false;
  String _message = "Silakan senyum ke kamera dan tekan tombol untuk verifikasi";

  @override
  void initState() {
    super.initState();
    _initDetector();
    _initCamera();
  }

  void _initDetector() {
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableClassification: true,
      ),
    );
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await _cameraController!.initialize();
    } catch (e) {
      setState(() {
        _message = "Gagal menginisialisasi kamera: $e";
      });
    } finally {
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    }
  }

  Future<void> _verifyLiveness() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized || _isProcessing) return;

    setState(() {
      _isProcessing = true;
      _message = "Memproses wajah...";
    });

    try {
      final XFile file = await _cameraController!.takePicture();
      final inputImage = InputImage.fromFilePath(file.path);
      final List<Face> faces = await _faceDetector.processImage(inputImage);

      if (faces.isEmpty) {
        setState(() {
          _message = "Wajah tidak terdeteksi. Silakan coba lagi.";
        });
      } else if (faces.length > 1) {
        setState(() {
          _message = "Terdeteksi lebih dari satu wajah. Pastikan hanya ada satu orang.";
        });
      } else {
        final Face face = faces.first;
        final double smilingProb = face.smilingProbability ?? 0.0;
        final double leftEyeOpenProb = face.leftEyeOpenProbability ?? 0.0;
        final double rightEyeOpenProb = face.rightEyeOpenProbability ?? 0.0;

        // Kriteria Liveness: wajah tersenyum dan mata terbuka
        if (smilingProb > 0.3 && leftEyeOpenProb > 0.5 && rightEyeOpenProb > 0.5) {
          setState(() {
            _message = "Verifikasi Wajah Berhasil!";
          });
          await Future.delayed(const Duration(seconds: 1));
          if (mounted) {
            Navigator.of(context).pop(true);
          }
        } else {
          setState(() {
            _message = "Gagal verifikasi. Silakan pastikan Anda tersenyum dan mata terbuka lebar.";
          });
        }
      }
    } catch (e) {
      setState(() {
        _message = "Terjadi kesalahan: $e";
      });
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verifikasi Liveness"),
      ),
      body: _isInitializing
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: _cameraController != null && _cameraController!.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: _cameraController!.value.aspectRatio,
                          child: CameraPreview(_cameraController!),
                        )
                      : const Center(child: Text("Kamera tidak tersedia")),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text(
                        _message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _isProcessing ? null : _verifyLiveness,
                        icon: _isProcessing
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.face),
                        label: const Text("VERIFIKASI WAJAH"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
// ===== END ADDED BY ANTIGRAVITY =====
