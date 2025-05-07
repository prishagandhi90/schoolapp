import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';

class VoiceController extends GetxController {
  final stt.SpeechToText speech = stt.SpeechToText();
  final AudioRecorder audioRecorder = AudioRecorder();
  final AudioPlayer player = AudioPlayer();

  bool isListening = false;
  bool isRecording = false;
  bool isPlaying = false;

  String recognizedText = '';
  String translatedText = '';
  String? filePath;

  int seconds = 0;
  late DateTime startTime;
  late Timer timer;

  Future<void> startListeningAndRecording() async {
    try {
      bool available = await speech.initialize();
      bool hasPermission = await audioRecorder.hasPermission();

      if (available && hasPermission) {
        recognizedText = '';
        translatedText = '';
        isListening = true;
        isRecording = true;
        seconds = 0;
        startTime = DateTime.now();

        Directory? dir;

        if (Platform.isAndroid) {
          dir = Directory('/storage/emulated/0/Download');
          if (!(await dir.exists())) {
            dir = await getExternalStorageDirectory();
          }
        } else {
          dir = await getApplicationDocumentsDirectory();
        }

        filePath = p.join(dir!.path, 'voice_${DateTime.now().millisecondsSinceEpoch}.m4a');

        await audioRecorder.start(const RecordConfig(encoder: AudioEncoder.aacLc, sampleRate: 48000, bitRate: 128000), path: filePath!);

        timer = Timer.periodic(const Duration(seconds: 1), (_) {
          seconds = DateTime.now().difference(startTime).inSeconds;
          update();
        });

        speech.listen(
          onResult: (result) {
            recognizedText = result.recognizedWords;
            update();
          },
          localeId: '', // auto detect
        );

        update();
      } else {
        Get.snackbar('Error', 'Microphone permission not granted or Speech not available');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to start listening and recording: $e');
    }
  }

  Future<void> stopListeningAndRecording() async {
    try {
      if (isListening) await speech.stop();
      if (isRecording) await audioRecorder.stop();

      isListening = false;
      isRecording = false;

      timer.cancel();
      update();

      if (filePath != null) {
        await _transcribeAndTranslateAudio(filePath!);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to stop: $e');
    }
  }

  Future<void> togglePlayback() async {
    if (filePath == null || !File(filePath!).existsSync()) return;

    if (isPlaying) {
      await player.pause();
    } else {
      await player.setFilePath(filePath!);
      await player.play();
      player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          isPlaying = false;
          update();
        }
      });
    }

    isPlaying = !isPlaying;
    update();
  }

  Future<void> _transcribeAndTranslateAudio(String audioPath) async {
    try {
      String transcribedText = await translateAudioToEnglish(audioPath);
      if (transcribedText.isNotEmpty) {
        recognizedText = transcribedText;
        // await translateAudioToEnglish(audioPath);
      } else {
        translatedText = 'No text recognized from audio.';
        update();
      }
    } catch (e) {
      translatedText = 'Audio processing error: $e';
      update();
    }
  }

  // Future<String> _convertAudioToText(String audioPath) async {
  //   File audioFile = File(audioPath);
  //   List<int> audioBytes = await audioFile.readAsBytes();
  //   String audioBase64 = base64Encode(audioBytes);
  //   try {
  //     final initialResponse = await http.post(
  //       Uri.parse('https://speech.googleapis.com/v1/speech:longrunningrecognize?key=$googleCloudApiKey'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({
  //         "audio": {"content": audioBase64},
  //         "config": {
  //           "encoding": "MP3", // or LINEAR16 for .wav
  //           "sampleRateHertz": 44100,
  //           "languageCode": "und",
  //           "alternativeLanguageCodes": ["en-IN", "hi-IN", "gu-IN"],
  //           "enableAutomaticPunctuation": true,
  //           "model": "latest_long",
  //         },
  //       }),
  //     );
  //     if (initialResponse.statusCode != 200) {
  //       throw Exception("Failed to start transcription: ${initialResponse.body}");
  //     }
  //     String operationName = json.decode(initialResponse.body)['name'];
  //     String transcript = '';
  //     bool done = false;
  //     int retries = 0;
  //     while (!done && retries < 20) {
  //       await Future.delayed(const Duration(seconds: 5));
  //       final resultResponse = await http.get(
  //         Uri.parse('https://speech.googleapis.com/v1/operations/$operationName?key=$googleCloudApiKey'),
  //       );
  //       if (resultResponse.statusCode != 200) {
  //         throw Exception('Polling error: ${resultResponse.body}');
  //       }
  //       final resultJson = json.decode(resultResponse.body);
  //       done = resultJson['done'] ?? false;
  //       if (done && resultJson.containsKey('response')) {
  //         List results = resultJson['response']['results'];
  //         transcript = results.map((e) => e['alternatives'][0]['transcript']).join('\n');
  //         break;
  //       }
  //       retries++;
  //     }
  //     return transcript.isNotEmpty ? transcript : 'No transcript available';
  //   } catch (e) {
  //     throw Exception('Error during long audio transcription: $e');
  //   }
  // }

  // Future<void> translateText(String text) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('https://api.deepseek.com/v1/chat/completions'),
  //       headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $translateApiKey'},
  //       body: json.encode({
  //         "model": "deepseek-chat",
  //         "messages": [
  //           {
  //             "role": "system",
  //             "content":
  //                 "You are a medical translator. Convert patient's Hinglish/Hindi/Indian language input into PROFESSIONAL MEDICAL ENGLISH TERMINOLOGY for doctors.",
  //           },
  //           {"role": "user", "content": text},
  //         ],
  //       }),
  //     );
  //     if (response.statusCode == 200) {
  //       var data = json.decode(response.body);
  //       translatedText = data['choices'][0]['message']['content'].toString().trim();
  //       update();
  //     } else {
  //       translatedText = 'Translation failed: ${response.body}';
  //       update();
  //     }
  //   } catch (e) {
  //     translatedText = 'Error: $e';
  //     update();
  //   }
  // }

  Future<String> translateAudioToEnglish(String audioPath) async {
    File audioFile = File(audioPath);
    final apiKey =
        'sk-proj-ymlqvji-D5Rg2vV9Ey6pODBdyL0Oz_un_BQYCqz-arB7vsy8UpHj0i-smnA5iHtVh4gxPhOu6DT3BlbkFJ7y9Se54fzFGvntE3AfmuwLlZzrlkkoK-Z6E1KXkJ8OF89rfm1bnD41s-SNJjs_xZ-2ET1RSpUAa';

    final uri = Uri.parse('https://api.openai.com/v1/audio/translations');

    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $apiKey'
      ..headers['Content-Type'] = 'multipart/form-data'
      ..fields['model'] = 'whisper-1'
      ..files.add(await http.MultipartFile.fromPath('file', audioFile.path, filename: p.basename(audioFile.path)));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      print("Translated Text: $responseBody");
      translatedText = responseBody; // <-- store full response here
      translatedText = await makeMedicalStyleTranslation(translatedText);
      update();
      return json.decode(responseBody)['text'].toString().trim();
    } else {
      print("Error: ${response.statusCode}");

      final responseBody = await response.stream.bytesToString();
      print("Details: $responseBody");
    }
    return 'Translation failed: ${response.statusCode}';
  }

  Future<String> makeMedicalStyleTranslation(String translatedText) async {
    final apiKey =
        'sk-proj-ymlqvji-D5Rg2vV9Ey6pODBdyL0Oz_un_BQYCqz-arB7vsy8UpHj0i-smnA5iHtVh4gxPhOu6DT3BlbkFJ7y9Se54fzFGvntE3AfmuwLlZzrlkkoK-Z6E1KXkJ8OF89rfm1bnD41s-SNJjs_xZ-2ET1RSpUAa';
    final url = Uri.parse("https://api.openai.com/v1/chat/completions");

    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $apiKey', 'Content-Type': 'application/json'},
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {
            "role": "system",
            "content":
                "You are a professional medical doctor. Convert the provided plain English text into a medically appropriate version using clinical terminology and doctor-style explanation.",
          },
          {"role": "user", "content": translatedText},
        ],
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return responseBody['choices'][0]['message']['content'];
    } else {
      return 'Error: ${response.statusCode}\n${response.body}';
    }
  }

  @override
  void onClose() {
    speech.stop();
    audioRecorder.dispose();
    if (timer.isActive) timer.cancel();
    player.dispose();
    super.onClose();
  }
}
