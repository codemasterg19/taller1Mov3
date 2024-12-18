import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PerfilScreen extends StatefulWidget {
  final bool modoOscuro;
  final Function(bool) cambiarTema;

  const PerfilScreen({
    super.key,
    required this.modoOscuro,
    required this.cambiarTema,
  });

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  late bool _modoOscuro;
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  String? _fotoPerfilUrl;
  String? _uid;

  @override
  void initState() {
    super.initState();
    _modoOscuro = widget.modoOscuro;
    _obtenerDatosUsuario();
  }

  Future<void> _obtenerDatosUsuario() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _uid = user.uid; // Obtén el UID del usuario autenticado
        _correoController.text =
            user.email ?? ''; // Carga el correo del usuario

        // Obtén los datos del usuario desde Realtime Database
        final ref = FirebaseDatabase.instance.ref('usuarios/$_uid');
        final snapshot = await ref.get();

        if (snapshot.exists) {
          final data = snapshot.value as Map<dynamic, dynamic>;
          setState(() {
            _nombreController.text = data['nombre'] ?? '';
            _fotoPerfilUrl = data['fotoPerfil'];
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar datos del usuario: $e')),
      );
    }
  }

  Future<void> _guardarDatos() async {
    if (_uid == null) return;

    try {
      final ref = FirebaseDatabase.instance.ref('usuarios/$_uid');
      await ref.set({
        'nombre': _nombreController.text,
        'correo': _correoController.text,
        'fotoPerfil': _fotoPerfilUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Datos guardados exitosamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar datos: $e')),
      );
    }
  }

  Future<void> _cargarImagen() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    try {
      final file = File(image.path);
      final ref = FirebaseStorage.instance.ref().child(
          'fotos_perfil/${_uid}_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putFile(file);

      final url = await ref.getDownloadURL();
      setState(() {
        _fotoPerfilUrl = url;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Imagen cargada exitosamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar imagen: $e')),
      );
    }
  }

  void _toggleModoOscuro() {
    setState(() {
      _modoOscuro = !_modoOscuro;
    });
    widget.cambiarTema(_modoOscuro);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Perfil de Usuario",
          style: TextStyle(
            color: _modoOscuro ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: _modoOscuro ? Colors.black : Colors.lightBlueAccent,
        actions: [],
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              GestureDetector(
                onTap: _cargarImagen,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _fotoPerfilUrl != null
                      ? NetworkImage(_fotoPerfilUrl!)
                      : null,
                  child: _fotoPerfilUrl == null
                      ? Icon(
                          Icons.camera_alt,
                          color: _modoOscuro ? Colors.white : Colors.black,
                          size: 40,
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: "Nombre Completo",
                  filled: true,
                  fillColor: _modoOscuro ? Colors.grey[800] : Colors.grey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                style: TextStyle(
                  color: _modoOscuro ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _correoController,
                readOnly: true, // El correo no debe ser editable
                decoration: InputDecoration(
                  labelText: "Correo Electrónico",
                  filled: true,
                  fillColor: _modoOscuro ? Colors.grey[800] : Colors.grey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                style: TextStyle(
                  color: _modoOscuro ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarDatos,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _modoOscuro ? Colors.blueAccent : Colors.lightBlueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  "Guardar",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}