import 'package:app_netflix/screens/catalogoScreen.dart';
import 'package:app_netflix/screens/registroScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class loginScreen extends StatelessWidget {
  const loginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController _email = TextEditingController();
    TextEditingController _password = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Iniciar Sesión",
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
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context)
                    .size
                    .height, // Llena todo el alto disponible
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Bienvenido de nuevo",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Inicia sesión para continuar disfrutando del mejor contenido de streaming.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(height: 40),
                      TextField(
                        controller: _email,
                        decoration: InputDecoration(
                          hintText: "Correo Electrónico",
                          hintStyle: TextStyle(color: Colors.grey[200]),
                          filled: true,
                          fillColor: Colors.grey[800],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _password,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Contraseña",
                          hintStyle: TextStyle(color: Colors.grey[200]),
                          filled: true,
                          fillColor: Colors.grey[800],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () =>
                            login(_email.text, _password.text, context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Iniciar Sesión",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "¿Olvidaste tu contraseña?",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 237, 239, 241),
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: () => registro(context),
                        child: Text(
                          "Crear una cuenta",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 234, 235, 238),
                            fontSize: 16,
                          ),
                        ),
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
}

void registro(context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => registroScreen()));
}

Future<void> login(email, pass, context) async {
  if (email.isEmpty || pass.isEmpty) {
    mostrarAlerta(context, "Error", "Por favor, completa todos los campos.",
        Icons.error, Colors.red);
    return;
  }

  try {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: pass,
    );

    /* Si el inicio de sesión es exitoso
    mostrarAlerta(
      context,
      "Inicio de Sesión",
      "Has iniciado sesión correctamente.",
      Icons.check_circle,
      Colors.green,
    );*/

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CatalogoScreen()),
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      mostrarAlerta(
        context,
        "Error",
        "Usuario no encontrado.",
        Icons.error,
        Colors.red,
      );
    } else if (e.code == 'wrong-password') {
      mostrarAlerta(
        context,
        "Error",
        "Contraseña incorrecta.",
        Icons.error,
        Colors.red,
      );
    } else {
      // Manejo genérico de excepciones específicas de FirebaseAuth
      mostrarAlerta(
        context,
        "Error",
        "Error de autenticación: ${e.message}",
        Icons.error,
        Colors.red,
      );
    }
  } catch (e) {
    // Manejo de errores generales
    mostrarAlerta(
      context,
      "Error",
      "Ha ocurrido un error. Inténtalo de nuevo.",
      Icons.error,
      Colors.red,
    );
  }
}

void mostrarAlerta(BuildContext context, String titulo, String mensaje,
    IconData icono, Color colorIcono) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.grey[900], // Fondo oscuro para el diálogo
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
