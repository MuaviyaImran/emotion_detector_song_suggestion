
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

import '../models/song_model.dart';
import '../widgets/widgets.dart';

class SongScreen extends StatefulWidget {
  const SongScreen({Key? key}) : super(key: key);

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  AudioPlayer audioPlayer = AudioPlayer();
  Song song = Get.arguments ?? Song.songs[0];

  @override
  void initState() {
    super.initState();

    audioPlayer.setAudioSource(
      ConcatenatingAudioSource(
        children: [
          AudioSource.uri(
            Uri.parse('asset:///${song.url}'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Stream<SeekBarData> get _seekBarDataStream =>
      rxdart.Rx.combineLatest2<Duration, Duration?, SeekBarData>(
        audioPlayer.positionStream,
        audioPlayer.durationStream,
        (
          Duration position,
          Duration? duration,
        ) {
          return SeekBarData(
            position,
            duration ?? Duration.zero,
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            song.coverUrl,
            fit: BoxFit.cover,
          ),
          const _BackgroundFilter(),
          _MusicPlayer(
            song: song,
            seekBarDataStream: _seekBarDataStream,
            audioPlayer: audioPlayer,
            onSongChange: (newSong) {
              setState(() {
                song = newSong;
              });
            },
          ),
        ],
      ),
    );
  }
}

class _MusicPlayer extends StatefulWidget {
  const _MusicPlayer({
    Key? key,
    required this.song,
    required Stream<SeekBarData> seekBarDataStream,
    required this.audioPlayer,
    required this.onSongChange,
  })  : _seekBarDataStream = seekBarDataStream,
        super(key: key);

  final Song song;
  final Stream<SeekBarData> _seekBarDataStream;
  final AudioPlayer audioPlayer;
  final void Function(Song) onSongChange;

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<_MusicPlayer> {
  late Song currentSong;
  int shuffledIndex = 0;
  late List<Song> shuffledSongs;

  @override
  void initState() {
    super.initState();
    currentSong = widget.song;
    shuffledSongs = List.from(Song.songs)..shuffle();
    shuffledIndex = shuffledSongs.indexOf(currentSong);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 50.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            currentSong.title,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            currentSong.description,
            maxLines: 2,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.white),
          ),
          const SizedBox(height: 30),
          StreamBuilder<SeekBarData>(
            stream: widget._seekBarDataStream,
            builder: (context, snapshot) {
              final positionData = snapshot.data;
              return SeekBar(
                position: positionData?.position ?? Duration.zero,
                duration: positionData?.duration ?? Duration.zero,
                onChangeEnd: widget.audioPlayer.seek,
              );
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.shuffle),
                onPressed: () {
                  setState(() {
                    shuffledSongs = List.from(Song.songs)..shuffle();
                    shuffledIndex = 0;
                    currentSong = shuffledSongs[shuffledIndex];
                    updateAudioSource();
                    widget.onSongChange(currentSong);
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.skip_previous),
                onPressed: () {
                  final currentIndex = Song.songs.indexOf(currentSong);
                  final previousIndex = (currentIndex - 1) % Song.songs.length;
                  final previousSong = Song.songs[previousIndex];
                  setState(() {
                    currentSong = previousSong;
                  });
                  updateAudioSource();
                  widget.onSongChange(currentSong);
                },
              ),
              IconButton(
                icon: Icon(
                  widget.audioPlayer.playing ? Icons.pause : Icons.play_arrow,
                ),
                onPressed: () {
                  if (widget.audioPlayer.playing) {
                    widget.audioPlayer.pause();
                  } else {
                    widget.audioPlayer.play();
                  }
                  setState(() {});
                },
              ),
              IconButton(
                icon: Icon(Icons.skip_next),
                onPressed: () {
                  final currentIndex = Song.songs.indexOf(currentSong);
                  final nextIndex = (currentIndex + 1) % Song.songs.length;
                  final nextSong = Song.songs[nextIndex];
                  setState(() {
                    currentSong = nextSong;
                  });
                  updateAudioSource();
                  widget.onSongChange(currentSong);
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Loop'),
              Switch(
                value: widget.audioPlayer.loopMode == LoopMode.one,
                onChanged: (value) {
                  widget.audioPlayer
                      .setLoopMode(value ? LoopMode.one : LoopMode.off);
                  setState(() {});
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void updateAudioSource() {
    widget.audioPlayer.setAudioSource(
      ConcatenatingAudioSource(
        children: [
          AudioSource.uri(
            Uri.parse('asset:///${currentSong.url}'),
          ),
        ],
      ),
    );
    widget.audioPlayer.play();
  }
}

class _BackgroundFilter extends StatelessWidget {
  const _BackgroundFilter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Colors.white.withOpacity(0.5),
            Colors.white.withOpacity(0.0),
          ],
          stops: const [0.0, 0.4, 0.6],
        ).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.blue.shade400,
            ],
          ),
        ),
      ),
    );
  }
}
