import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RegistroPeliculas extends StatefulWidget {
  const RegistroPeliculas({super.key});

  @override
  _RegistroPeliculasState createState() => _RegistroPeliculasState();
}

class _RegistroPeliculasState extends State<RegistroPeliculas> {
  final TextEditingController _id = TextEditingController();
  final TextEditingController _titulo = TextEditingController();
  final TextEditingController _urlImagen = TextEditingController();
  final TextEditingController _descripcion = TextEditingController();

  bool _isEditing = false;
  List<Map<String, dynamic>> _peliculas = [];

  @override
  void initState() {
    super.initState();
    _cargarPeliculas();
  }

  Future<void> _cargarPeliculas() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("peliculas/");
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      setState(() {
        _peliculas = data.entries.map((entry) {
          return {
            "id": entry.key,
            ...Map<String, dynamic>.from(entry.value),
          };
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? "Editar Película" : "Registro de Películas",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        _isEditing
                            ? "Edita la película seleccionada"
                            : "Añade una nueva película",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildTextField(
                        controller: _id,
                        label: "Código",
                        hint: "Ingresa el código de la película",
                        enabled: !_isEditing,
                      ),
                      SizedBox(height: 20),
                      _buildTextField(
                        controller: _titulo,
                        label: "Título",
                        hint: "Ingresa el título de la película",
                      ),
                      SizedBox(height: 20),
                      _buildTextField(
                        controller: _urlImagen,
                        label: "URL de Imagen",
                        hint: "Ingresa el URL de la imagen",
                      ),
                      SizedBox(height: 20),
                      _buildTextField(
                        controller: _descripcion,
                        label: "Descripción",
                        hint: "Ingresa una descripción de la película",
                        maxLines: 3,
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          if (_validateFields(context, _id, _titulo, _urlImagen,
                              _descripcion)) {
                            if (_isEditing) {
                              editar(
                                _id.text,
                                _titulo.text,
                                _urlImagen.text,
                                _descripcion.text,
                              ).then((_) {
                                _showMessage(
                                  context,
                                  "Éxito",
                                  "Película actualizada exitosamente.",
                                  Colors.green,
                                );
                                _clearFields();
                                _cargarPeliculas();
                                setState(() {
                                  _isEditing = false;
                                });
                              }).catchError((error) {
                                _showMessage(
                                  context,
                                  "Error",
                                  "Hubo un error al actualizar la película. Inténtalo de nuevo.",
                                  Colors.red,
                                );
                              });
                            } else {
                              guardar(
                                _id.text,
                                _titulo.text,
                                _urlImagen.text,
                                _descripcion.text,
                              ).then((_) {
                                _showMessage(
                                  context,
                                  "Éxito",
                                  "Película guardada exitosamente.",
                                  Colors.green,
                                );
                                _clearFields();
                                _cargarPeliculas();
                              }).catchError((error) {
                                _showMessage(
                                  context,
                                  "Error",
                                  "Hubo un error al guardar la película. Inténtalo de nuevo.",
                                  Colors.red,
                                );
                              });
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          _isEditing ? "Actualizar" : "Guardar",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      DropdownButton<String>(
                        hint: Text(
                          "Selecciona una película para editar",
                          style: TextStyle(color: Colors.white),
                        ),
                        dropdownColor: Colors.grey[900],
                        value: null,
                        items: _peliculas.map((pelicula) {
                          return DropdownMenuItem<String>(
                            value: pelicula["id"],
                            child: Text(
                              pelicula["titulo"],
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? id) {
                          final pelicula =
                              _peliculas.firstWhere((p) => p["id"] == id);
                          cargarDatosParaEditar(
                            pelicula["id"],
                            pelicula["titulo"],
                            pelicula["urlImagen"],
                            pelicula["descripcion"],
                          );
                        },
                      ),
                      if (_isEditing)
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: Icon(Icons.delete, color: Colors.white),
                          label: Text(
                            "Eliminar Película",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Confirmar Eliminación"),
                                  content: Text(
                                      "¿Estás seguro de que deseas eliminar esta película?"),
                                  actions: [
                                    TextButton(
                                      child: Text("Cancelar"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text(
                                        "Eliminar",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      onPressed: () {
                                        eliminar(_id.text).then((_) {
                                          Navigator.of(context).pop();
                                          _showMessage(
                                            context,
                                            "Éxito",
                                            "Película eliminada exitosamente.",
                                            Colors.green,
                                          );
                                          _clearFields();
                                          _cargarPeliculas();
                                          setState(() {
                                            _isEditing = false;
                                          });
                                        }).catchError((error) {
                                          Navigator.of(context).pop();
                                          _showMessage(
                                            context,
                                            "Error",
                                            "Hubo un error al eliminar la película. Inténtalo de nuevo.",
                                            Colors.red,
                                          );
                                        });
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    bool enabled = true,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.grey[800],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
      style: TextStyle(color: Colors.white),
    );
  }

  bool _validateFields(
    BuildContext context,
    TextEditingController id,
    TextEditingController titulo,
    TextEditingController urlImagen,
    TextEditingController descripcion,
  ) {
    if (id.text.isEmpty ||
        titulo.text.isEmpty ||
        urlImagen.text.isEmpty ||
        descripcion.text.isEmpty) {
      _showMessage(
        context,
        "Error",
        "Por favor, completa todos los campos obligatorios.",
        Colors.red,
      );
      return false;
    }
    return true;
  }

  void _clearFields() {
    _id.clear();
    _titulo.clear();
    _urlImagen.clear();
    _descripcion.clear();
  }

  void _showMessage(
      BuildContext context, String title, String message, Color color) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                color == Colors.green ? Icons.check_circle : Icons.error,
                color: color,
              ),
              SizedBox(width: 8),
              Text(title),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              child: Text("Cerrar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> guardar(
      String id, String titulo, String urlImagen, String descripcion) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("peliculas/$id");
    await ref.set({
      "titulo": titulo,
      "urlImagen": urlImagen,
      "descripcion": descripcion,
    });
  }

  Future<void> editar(
      String id, String titulo, String urlImagen, String descripcion) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("peliculas/$id");
    await ref.update({
      "titulo": titulo,
      "urlImagen": urlImagen,
      "descripcion": descripcion,
    });
  }

  Future<void> eliminar(String id) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("peliculas/$id");
    await ref.remove();
  }

  void cargarDatosParaEditar(
      String id, String titulo, String urlImagen, String descripcion) {
    setState(() {
      _id.text = id;
      _titulo.text = titulo;
      _urlImagen.text = urlImagen;
      _descripcion.text = descripcion;
      _isEditing = true;
    });
  }
}
