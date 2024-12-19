import 'package:app_netflix/screens/perfilScreen.dart';
import 'package:app_netflix/screens/registroPeliculasScreen.dart';
import 'package:app_netflix/screens/reproductorScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CatalogoScreen extends StatefulWidget {
  final bool modoOscuro;
  final Function(bool) cambiarTema;

  const CatalogoScreen({
    super.key,
    required this.modoOscuro,
    required this.cambiarTema,
  });

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {
  late bool _modoOscuro;
  bool _mostrarBoton = false;

  void initState() {
    super.initState();
    _modoOscuro = widget.modoOscuro; // Sincronizar con el estado global
    _verificarUsuario();
  }

  void _toggleModoOscuro() {
    setState(() {
      _modoOscuro = !_modoOscuro; // Actualiza el estado local
    });
    widget.cambiarTema(_modoOscuro); // Actualiza el estado global
  }

  void _verificarUsuario() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null &&
        (user.email == 'pjimenez@mail.com' ||
            user.uid == 'wv6Jr96CCRNau63jxoRyOqkhbG73')) {
      setState(() {
        _mostrarBoton = true;
      });
    } else {
      setState(() {
        _mostrarBoton = false;
      });
    }
  }

  // Tema dinámico
  ThemeData get _temaActual => ThemeData(
        primaryColor: _modoOscuro ? Colors.blueAccent : Colors.lightBlueAccent,
        brightness: _modoOscuro ? Brightness.dark : Brightness.light,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                _modoOscuro ? Colors.blueAccent : Colors.lightBlueAccent,
          ),
        ),
      );

  // Gradiente dinámico
  LinearGradient get _gradienteActual => _modoOscuro
      ? LinearGradient(
          colors: [Colors.blueAccent, Colors.black],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )
      : LinearGradient(
          colors: [Colors.lightBlueAccent, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );

  // Método para leer datos en tiempo real desde Firebase Realtime Database
  Stream<List<Map<String, dynamic>>> leerEnTiempoReal() {
    DatabaseReference ref = FirebaseDatabase.instance.ref('peliculas/');
    return ref.onValue.map((event) {
      final data = event.snapshot.value;
      if (data != null) {
        Map<dynamic, dynamic> mapData = data as Map<dynamic, dynamic>;
        return mapData.entries.map((entry) {
          return {
            'id': entry.key,
            'titulo': entry.value['titulo'] ?? 'Sin título',
            'urlImagen': entry.value['urlImagen'] ?? '',
            'descripcion': entry.value['descripcion'] ?? 'Sin descripción',
            'urlVideo': entry.value['urlVideo'] ?? '', // Campo opcional
          };
        }).toList();
      } else {
        return [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Catálogo",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: _modoOscuro ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: _modoOscuro ? Colors.black : Colors.lightBlueAccent,
        actions: [
          IconButton(
            icon: Icon(
              _modoOscuro ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            onPressed: _toggleModoOscuro,
            tooltip: 'Alternar Modo Oscuro',
          ),
          IconButton(
            icon: Icon(
              Icons.account_circle,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PerfilScreen(
                    modoOscuro: _modoOscuro,
                    cambiarTema: widget.cambiarTema,
                  ),
                ),
              );
            },
            tooltip: 'Perfil',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _modoOscuro
                ? [Colors.black, Colors.blueAccent]
                : [Colors.lightBlueAccent, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: leerEnTiempoReal(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Error al cargar datos",
                      style: TextStyle(
                        color: widget.modoOscuro ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      "No hay datos disponibles",
                      style: TextStyle(
                        color: _modoOscuro ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                }

                final peliculas = snapshot.data!;

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: peliculas.length,
                  itemBuilder: (context, index) {
                    final pelicula = peliculas[index];
                    return Card(
                      color: _modoOscuro ? Colors.grey[850] : Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(15),
                              ),
                              child: AspectRatio(
                                aspectRatio:
                                    16 / 9, // Proporción estándar para imágenes
                                child: Image.network(
                                  pelicula["urlImagen"]!,
                                  fit: BoxFit
                                      .fitWidth, // Ajusta la imagen a lo ancho manteniendo proporción
                                  width: double.infinity,
                                  height: double.infinity,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[300],
                                      child: const Center(
                                        child: Icon(
                                          Icons.broken_image,
                                          color: Colors.red,
                                          size: 50,
                                        ),
                                      ),
                                    );
                                  },
                                  loadingBuilder: (context, child, progress) {
                                    if (progress == null)
                                      return child; // Muestra la imagen cuando se carga
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    ); // Muestra un indicador de carga mientras se descarga
                                  },
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              pelicula["titulo"]!,
                              style: TextStyle(
                                color:
                                    _modoOscuro ? Colors.white : Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              mostrarAlerta(
                                context,
                                "Descripción",
                                pelicula["descripcion"]!,
                                Icons.info,
                                _modoOscuro
                                    ? Colors.blueAccent
                                    : Colors.lightBlueAccent,
                                pelicula["urlVideo"]!,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _modoOscuro
                                  ? Colors.blueAccent
                                  : Colors.lightBlueAccent,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(15),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            child: const Text(
                              "Ver Detalles",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: _mostrarBoton
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegistroPeliculas(
                      modoOscuro: _modoOscuro,
                      cambiarTema: widget.cambiarTema,
                    ),
                  ),
                );
              },
              backgroundColor:
                  _modoOscuro ? Colors.blueAccent : Colors.lightBlueAccent,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  void mostrarAlerta(BuildContext context, String titulo, String descripcion,
      IconData icono, Color colorIcono, String videoPath) async {
    String? videoUrl;

    if (videoPath.isNotEmpty) {
      try {
        videoUrl =
            await FirebaseStorage.instance.ref(videoPath).getDownloadURL();
      } catch (e) {
        debugPrint("Error al obtener la URL del video: $e");
        videoUrl = null;
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: _modoOscuro ? Colors.grey[900] : Colors.grey[200],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Row(
            children: [
              Icon(icono, color: colorIcono),
              const SizedBox(width: 8),
              Text(
                titulo,
                style: TextStyle(
                  color: _modoOscuro ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            descripcion,
            style:
                TextStyle(color: _modoOscuro ? Colors.grey[300] : Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "Cerrar",
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
            if (videoUrl != null)
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReproductorScreen(
                        videoUrl: videoUrl!,
                        descripcion: descripcion,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.play_arrow, color: Colors.white),
                label: const Text("Reproducir"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
          ],
        );
      },
    );
  }
}
