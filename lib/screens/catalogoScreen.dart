import 'package:app_netflix/screens/registroPeliculasScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class CatalogoScreen extends StatelessWidget {
  const CatalogoScreen({super.key});

  Stream<List<Map<String, dynamic>>> leerEnTiempoReal() {
    DatabaseReference ref = FirebaseDatabase.instance.ref('peliculas/');
    return ref.onValue.map((event) {
      final data = event.snapshot.value;
      if (data != null) {
        Map<dynamic, dynamic> mapData = data as Map<dynamic, dynamic>;

        return mapData.entries.map((entry) {
          return {
            'id': entry.key,
            'titulo': entry.value['titulo'],
            'urlImagen': entry.value['urlImagen'],
            'descripcion': entry.value['descripcion'],
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
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.blueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: leerEnTiempoReal(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Error al cargar datos",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      "No hay datos disponibles",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                final peliculas = snapshot.data!;

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: peliculas.length,
                  itemBuilder: (context, index) {
                    final pelicula = peliculas[index];
                    return Card(
                      color: Colors.grey[850],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(15),
                              ),
                              child: Image.network(
                                pelicula["urlImagen"]!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              pelicula["titulo"]!,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
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
                                Colors.blueAccent,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(15),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 10),
                            ),
                            child: Text(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => RegistroPeliculas()));
        },
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add),
      ),
    );
  }

  void mostrarAlerta(BuildContext context, String titulo, String mensaje,
      IconData icono, Color colorIcono) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(icono, color: colorIcono),
              SizedBox(width: 8),
              Text(
                titulo,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(
            mensaje,
            style: TextStyle(color: Colors.grey[300]),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Cerrar",
                style: TextStyle(
                    color: Colors.blueAccent, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
}
