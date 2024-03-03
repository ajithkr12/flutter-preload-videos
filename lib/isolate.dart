import 'dart:isolate';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_preload_videos/service/api_service.dart';
import 'package:flutter_preload_videos/core/build_context.dart';
import 'package:flutter_preload_videos/bloc/preload_bloc.dart';
import 'package:flutter_preload_videos/core/constants.dart';


Future createIsolate(int index, ) async {

  // final BuildContext context = getContext(); 
  // Set loading to true
  BlocProvider.of<PreloadBloc>(context, listen: false).add(PreloadEvent.setLoading());

  ReceivePort mainReceivePort = ReceivePort();

  Isolate.spawn<SendPort>(getVideosTask, mainReceivePort.sendPort);

  SendPort isolateSendPort = await mainReceivePort.first;

  ReceivePort isolateResponseReceivePort = ReceivePort();

  isolateSendPort.send([index, isolateResponseReceivePort.sendPort]);

  final isolateResponse = await isolateResponseReceivePort.first;
  final _urls = isolateResponse;

  // Update new urls
  BlocProvider.of<PreloadBloc>(context, listen: false).add(PreloadEvent.updateUrls(_urls));
}

void getVideosTask(SendPort mySendPort) async {
  ReceivePort isolateReceivePort = ReceivePort();

  mySendPort.send(isolateReceivePort.sendPort);

  await for (var message in isolateReceivePort) {
    if (message is List) {
      final int index = message[0];

      final SendPort isolateResponseSendPort = message[1];

      final List<String> _urls = await ApiService.getVideos(id: index + kPreloadLimit);
      // final List<Map<String, dynamic>> _urls = await ApiService.getVideos(id: index + kPreloadLimit);


      isolateResponseSendPort.send(_urls);
    }
  }
}