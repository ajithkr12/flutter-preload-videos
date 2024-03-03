import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_preload_videos/injection.dart';
import 'package:flutter_preload_videos/service/navigation_service.dart';
import 'package:flutter_preload_videos/video_page.dart';

import 'bloc/preload_bloc.dart';


class VideoMain extends StatelessWidget {

  final NavigationService _navigationService = getIt<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PreloadBloc>()..add(PreloadEvent.getVideosFromApi()),
      child: MaterialApp(
        key: _navigationService.navigationKey,
        home: VideoPage(),
      ),
    );
  }
}
