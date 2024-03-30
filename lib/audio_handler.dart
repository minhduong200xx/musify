import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musify/models/models.dart';

class MyAudioHandler extends BaseAudioHandler {
  final _player = AudioPlayer();
  final _songQueue = ConcatenatingAudioSource(children: []);
  
  

  MyAudioHandler(){
    _loadEmptyPlaylist();
    _player.playbackEventStream.map(_transformEvent as Function(PlaybackEvent event)).pipe(playbackState);
    _listenForDurationChanges();
    _listenForCurrentSongIndexChanges();
    _listenForSequenceStateChanges(); 
  }
  Future<void> _loadEmptyPlaylist() async {
    try {
      await _player.setAudioSource(_songQueue);
    } catch (err) {
      debugPrint("Error: $err");
    }
  }

  @override
  Future<void> play() => _player.play();

  @override 
  Future<void> pause() => _player.pause();

  @override 
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> stop() async {
    await _player.stop();
    return super.stop();
  }

  // @override 
  // Future<void> addQueueItem(MediaItem mediaItems) async {
  //   final audioSource = _createAudioSource(mediaItems);
  //   _songQueue.add(AudioSource as AudioSource);

  //   final newQueue = queue..add(mediaItems as List<MediaItem>);
  //   queue.add(newQueue as List<MediaItem>);
  // }

  // @override 
  // Future<void> removeQueueItem(MediaItem mediaItems) async {
  //   if (_songQueue.length > index) {
  //     _songQueue.removeAt(index);

  //     final newQueue = queue.value..removeAt(index);
  //     queue.add(newQueue);
  //   }
  // }

  // UriAudioSource _createAudioSource(MediaItem mediaItems){
  //   return AudioSource.uri(
  //     Uri.parse(mediaItem.extras!['url'] as String),
  //     tag: mediaItem,
  //   );
  // }

  PlaybackState _transformEvent(PlaybackState event){
    return PlaybackState(
      controls : [
        MediaControl.rewind,
        if(_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.fastForward,

      ],
      systemActions: const{
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.queueIndex,
    );
  }
  void _listenForDurationChanges(){
    _player.durationStream.listen((duration) {
      var index = _player.currentIndex;
      final newQueueIndex = queue.value;
      if (index == null || newQueueIndex.isEmpty) return;
      if (_player.shuffleModeEnabled){
        index = _player.shuffleIndices![index];
      }
      final oldMediaItem = newQueueIndex[index];
      final newMeidaItem = oldMediaItem.copyWith(duration : duration);
      newQueueIndex[index] = newMeidaItem;
      queue.add(newQueueIndex);
      mediaItem.add(newMeidaItem);
    }
    );
  }

  void _listenForCurrentSongIndexChanges(){
    _player.currentIndexStream.listen((index){
      final playlist = queue.value;
      if (index == null || playlist.isEmpty) return;
      if (_player.shuffleModeEnabled) {
        index = _player.shuffleIndices![index];
      }
      mediaItem.add(playlist[index]);
    });
  } 

  void _listenForSequenceStateChanges(){
    _player. sequenceStateStream.listen((SequenceState? sequenceState)
    {
      final sequence = sequenceState?.effectiveSequence;
      if (sequence == null || sequence.isEmpty) return;
      final items = sequence.map((source) => source.tag as MediaItem);
      queue.add(items.toList());
    });
  }
}