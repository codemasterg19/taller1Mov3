import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

class ReproductorScreen extends StatefulWidget {
  final String descripcion;
  final String videoUrl;

  const ReproductorScreen({
    Key? key,
    required this.descripcion,
    required this.videoUrl,
  }) : super(key: key);

  @override
  _ReproductorScreenState createState() => _ReproductorScreenState();
}

class _ReproductorScreenState extends State<ReproductorScreen> {
  late VideoPlayerController _controller;
  bool _isLoading = true;
  bool _isFullScreen = false;
  double _volume = 1.0; // Volumen inicial

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  // Inicializa el video
  void _initializeVideo() {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {
          _isLoading = false;
          _controller.setVolume(_volume);
          _controller.play();
        });
      }).catchError((error) {
        print("Error al cargar el video: $error");
      });

    // Actualiza el estado del reproductor constantemente
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  // Alternar pantalla completa
  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });

    if (_isFullScreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
  }

  // Formatear duración del video
  String _formatDuration(Duration position) {
    final minutes = position.inMinutes;
    final seconds = position.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  // Widget de controles
  Widget _buildControls() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Barra de progreso
        VideoProgressIndicator(
          _controller,
          allowScrubbing: true,
          colors: VideoProgressColors(
            playedColor: Colors.blueAccent,
            bufferedColor: Colors.grey,
            backgroundColor: Colors.white,
          ),
        ),
        // Controles principales
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                });
              },
              icon: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 30,
              ),
            ),
            // Duración
            Text(
              "${_formatDuration(_controller.value.position)} / ${_formatDuration(_controller.value.duration)}",
              style: const TextStyle(color: Colors.white),
            ),
            // Control de volumen
            Expanded(
              child: Slider(
                value: _volume,
                min: 0.0,
                max: 1.0,
                activeColor: Colors.blueAccent,
                onChanged: (value) {
                  setState(() {
                    _volume = value;
                    _controller.setVolume(_volume);
                  });
                },
              ),
            ),
            // Botón de pantalla completa
            IconButton(
              onPressed: _toggleFullScreen,
              icon: const Icon(
                Icons.fullscreen,
                color: Colors.white,
                size: 30,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isFullScreen) {
          _toggleFullScreen();
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        appBar: _isFullScreen
            ? null
            : AppBar(
                title: const Text("Reproductor de Video"),
                backgroundColor: Colors.black,
              ),
        backgroundColor: Colors.black,
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Center(
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                  _buildControls(), // Controles del reproductor
                ],
              ),
      ),
    );
  }
}
