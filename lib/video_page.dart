import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_preload_videos/bloc/preload_bloc.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatelessWidget {
  const VideoPage();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<PreloadBloc, PreloadState>(
        builder: (context, state) {
          return PageView.builder(
            itemCount: state.urls.length,
            scrollDirection: Axis.vertical,
            onPageChanged: (index) =>
                BlocProvider.of<PreloadBloc>(context, listen: false)
                    .add(PreloadEvent.onVideoIndexChanged(index)),
            itemBuilder: (context, index) {
              // Is at end and isLoading
              final bool _isLoading = (state.isLoading && index == state.urls.length - 1);
              print("FOCUSED INDEX --------------> ${state.focusedIndex} #### ${index}");
              return state.focusedIndex == index && state.isLoading == false
                  ? VideoWidget(
                      isLoading: _isLoading,
                      controller: state.controllers[index]!,
                      index: index,
                      isPlaying: state.isPlaying,
                      isInitialized : state.controllers[index]!.value.isInitialized)
                  :    Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.transparent,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      );
            },
          );
        },
      ),
    );
  }
}

/// Custom Feed Widget consisting video
class VideoWidget extends StatelessWidget {
  const VideoWidget({
    Key? key,
    required this.isLoading,
    required this.controller,
    required this.index,
    required this.isPlaying,
    required this.isInitialized,
  });

  final int index;
  final bool isLoading;
  final bool isPlaying;
  final bool isInitialized;
  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
      return BlocBuilder<PreloadBloc, PreloadState>(
      builder: (context, state) {
        final isInitializedz = state.controllers[index]!.value.isInitialized;
        return Column(
          children: [
            Expanded(
                child: Stack(
              alignment: Alignment.center,
              children: [
                // controller.value.isInitialized
                // isInitializedz
                //     ? VideoPlayer(controller)
                //     : Container(
                //         width: double.infinity,
                //         height: double.infinity,
                //         color: Colors.amber,
                //         alignment: Alignment.center,
                //         child: CircularProgressIndicator(),
                //       ),
                VideoPlayer(controller),
                GestureDetector(
                  onTap: () {
                    isPlaying
                        ? BlocProvider.of<PreloadBloc>(context, listen: false)
                            .add(PreloadEvent.onPauseVideoEvent(index))
                        : BlocProvider.of<PreloadBloc>(context, listen: false)
                            .add(PreloadEvent.onPlayVideoEvent(index));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 220.0,
                    width: 220.0,
                    color: Colors.transparent,
                    child: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 120.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                // Text("${isInitialized}")
              ],
            )),
            AnimatedCrossFade(
              alignment: Alignment.bottomCenter,
              sizeCurve: Curves.decelerate,
              duration: const Duration(milliseconds: 400),
              firstChild: Padding(
                padding: const EdgeInsets.all(10.0),
                child: CupertinoActivityIndicator(
                  color: Colors.white,
                  radius: 8,
                ),
              ),
              secondChild: const SizedBox(),
              crossFadeState: isLoading
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
            ),
          ],
        );
      },
    );
  }
}
