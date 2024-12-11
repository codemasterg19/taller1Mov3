import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class registroScreen extends StatelessWidget {
  const registroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    final _confimPasswordController = TextEditingController();
    final _nameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Crear Cuenta",
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
                    .height, // Llena el alto disponible
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Únete a la mejor experiencia de streaming",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Crea una cuenta para acceder a contenido exclusivo.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(height: 40),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: "Nombre Completo",
                          hintStyle: TextStyle(color: Colors.grey[400]),
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
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: "Correo Electrónico",
                          hintStyle: TextStyle(color: Colors.grey[400]),
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
                        obscureText: true,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: "Contraseña",
                          hintStyle: TextStyle(color: Colors.grey[400]),
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
                        obscureText: true,
                        controller: _confimPasswordController,
                        decoration: InputDecoration(
                          hintText: "Confirmar Contraseña",
                          hintStyle: TextStyle(color: Colors.grey[400]),
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
                        onPressed: () => registro(
                            _emailController.text,
                            _passwordController.text,
                            _confimPasswordController.text,
                            context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Registrarse",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Regresar al login
                        },
                        child: Text(
                          "¿Ya tienes una cuenta? Inicia Sesión",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 251, 252, 253),
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

Future<void> registro(email, password, confirmPassword, context) async {
  if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
    // Validación de campos vacíos
    error_alert(context, 'Por favor, completa todos los campos.');
    return;
  }

  if (password != confirmPassword) {
    // Validación de contraseñas que no coinciden
    mostrarAlerta(
      context,
      "Error",
      "Las contraseñas no coinciden. Verifica e intenta nuevamente.",
      Icons.error,
      Colors.red,
    );
    return;
  }

  try {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Registro exitoso
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Usuario registrado exitosamente'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context); // Regresa a la pantalla anterior
  } on FirebaseAuthException catch (e) {
    // Manejo de errores específicos de FirebaseAuth
    switch (e.code) {
      case 'weak-password':
        error_alert(context,
            'La contraseña es demasiado débil. Intenta con una más segura.');
        break;
      case 'email-already-in-use':
        error_alert(context, 'El correo ya está en uso por otro usuario.');
        break;
      case 'invalid-email':
        error_alert(context,
            'El formato del correo no es válido. Verifica e intenta de nuevo.');
        break;
      case 'operation-not-allowed':
        error_alert(
            context, 'El registro con correo y contraseña no está habilitado.');
        break;
      default:
        error_alert(context, 'Ocurrió un error: ${e.message}');
        break;
    }
  } catch (e) {
    // Manejo de errores generales
    error_alert(context, 'Se produjo un error inesperado: ${e.toString()}');
  }
}

// Alerta personalizada
void error_alert(BuildContext context, String mensaje) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(width: 8.0),
            Text("Error", style: TextStyle(color: Colors.red)),
          ],
        ),
        content: Text(
          mensaje,
          style: TextStyle(fontSize: 16.0),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Cerrar",
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      );
    },
  );
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
