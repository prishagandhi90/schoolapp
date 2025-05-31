import 'package:emp_app/app/core/util/app_color.dart';
import 'package:emp_app/app/core/util/sizer_constant.dart';
import 'package:emp_app/app/moduls/admitted%20patient/controller/adpatient_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VoiceScreen extends StatelessWidget {
  VoiceScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdPatientController>(
      builder: (controller) {
        return Scaffold(
            appBar: AppBar(title: Text('Voice Translator')),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 1,
                        color: AppColor.grey,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: getDynamicHeight(size: 0.012),
                        vertical: getDynamicHeight(size: 0.015),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(controller.patientName),
                              ),
                              SizedBox(
                                width: Sizes.crossLength * 0.015,
                              ),
                              Text(controller.bedNo)
                            ],
                          ),
                          SizedBox(height: Sizes.crossLength * 0.01),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Text(controller.ipdNo)),
                              SizedBox(
                                width: Sizes.crossLength * 0.015,
                              ),
                              Text(controller.uhid)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: Sizes.crossLength * 0.02),
                  Icon(Icons.mic, size: 60, color: controller.isListening ? Colors.red : Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    controller.isListening ? 'Listening... ${controller.seconds}s' : 'Tap mic and speak in Hindi/any language',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),

                  // Live voice listening buttons
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     ElevatedButton.icon(
                  //       icon: Icon(Icons.mic),
                  //       label: Text("Start"),
                  //       onPressed: controller.isListening ? null : controller.startListening,
                  //     ),
                  //     SizedBox(width: 20),
                  //     ElevatedButton.icon(
                  //       icon: Icon(Icons.stop),
                  //       label: Text("Stop"),
                  //       onPressed: controller.isListening ? controller.stopListening : null,
                  //       style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(height: 30),

                  // Audio recording button (your requested implementation)
                  ElevatedButton.icon(
                    icon: Icon(controller.isRecording ? Icons.stop : Icons.mic),
                    label: Text(controller.isRecording ? 'Stop Recording' : 'Start Recording'),
                    onPressed:
                        controller.isRecording ? () => controller.stopListeningAndRecording() : controller.startListeningAndRecording,
                    // onPressed: controller.stopListeningAndRecording,
                    style: ElevatedButton.styleFrom(backgroundColor: controller.isRecording ? AppColor.red : null),
                  ),
                  SizedBox(height: 20),
                  // Playback button for recorded audio
                  if (controller.filePath != null) ...[
                    ElevatedButton.icon(
                      icon: Icon(controller.isPlaying ? Icons.pause : Icons.play_arrow),
                      label: Text(controller.isPlaying ? 'Pause' : 'Play Recording'),
                      onPressed: (controller.isListening || controller.isRecording)
                          ? null // disable when recording or listening
                          : controller.togglePlayback,
                    ),
                    SizedBox(height: 10),
                    Text('Recording available', style: TextStyle(color: Colors.green)),
                    SizedBox(height: 20),
                  ],
                  // Recognized text display
                  if (controller.recognizedText.isNotEmpty) ...[
                    Text("Detected Speech:", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text(controller.recognizedText),
                    SizedBox(height: 20),
                  ],

                  // // Translated text display
                  // if (controller.translatedText.isNotEmpty) ...[
                  //   Text("Translated Text:", style: TextStyle(fontWeight: FontWeight.bold)),
                  //   SizedBox(height: 8),
                  //   Text(controller.translatedText),
                  // ],
                ],
              ),
            ));
      },
    );
  }
}
