import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SoundRecorder {
  FlutterSoundRecorder? _audioRecorder;
  bool _isRecordInitialized = false;
  bool get isRecording => _audioRecorder!.isRecording;
  int audioNumber = 1;

  Future<void> init() async {
    _audioRecorder = FlutterSoundRecorder();
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException(
          "Microphone Permission is not granted");
    }

    await _audioRecorder!.openAudioSession();
    _isRecordInitialized = true;
  }

  void dispose() {
    if (!_isRecordInitialized) return;
    _audioRecorder?.closeAudioSession();
    _audioRecorder = null;
    _isRecordInitialized = false;
  }


Future<void> _record() async {
  if (!_isRecordInitialized) return;

  final appDocumentsDirectory = await getApplicationDocumentsDirectory();
  final String folderName = 'my_audio_folder';
  final String fileName = 'audio-$audioNumber.wav';

  final folderPath = '${appDocumentsDirectory.path}/$folderName';
  final filePath = '$folderPath/$fileName';

  Directory(folderPath).createSync(recursive: true);

  final pathToSaveAudio = '$folderPath/$fileName';

  await _audioRecorder!.startRecorder(
    toFile: pathToSaveAudio,
    codec: Codec.pcm16WAV, // Use WAV codec for audio recording
  );

  print(filePath);
  audioNumber++;
}

Future<void> _stop() async {
  if (!_isRecordInitialized) return;
  
  await _audioRecorder!.stopRecorder();

  final appDocumentsDirectory = await getApplicationDocumentsDirectory();
  final String folderName = 'my_audio_folder';
  final String fileName = 'audio-$audioNumber.wav';

  final folderPath = '${appDocumentsDirectory.path}/$folderName';
  final filePath = '$folderPath/$fileName';

  final pathToSaveAudio = '$folderPath/$fileName';

  // Read the audio file as bytes
  final audioBytes = File(pathToSaveAudio).readAsBytesSync();

  // Convert audio bytes to Base64 string
  final audioBase64 = base64Encode(audioBytes);

  // Send audioBase64 to Flask server
  final ngrokUrl = 'https://0131-156-192-20-83.ngrok-free.app';
  final apiUrl = '$ngrokUrl/api/predict';

  final response = await http.post(Uri.parse(apiUrl), body: {'audio': audioBase64});
  if (response.statusCode == 200) {
    print(response);
  } else {
    print('Error sending audio to Flask server');
  }
}

  Future<void> toggleRecording() async {
    if (_audioRecorder!.isStopped) {
      await _record();
    } else {
      await _stop();
    }
  }
}
