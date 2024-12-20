import 'package:app_netflix/screens/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class registroScreen extends StatefulWidget {
  final bool modoOscuro;
  final Function(bool) cambiarTema;

  const registroScreen({
    super.key,
    required this.modoOscuro,
    required this.cambiarTema,
  });

  @override
  _registroScreenState createState() => _registroScreenState();
}

class _registroScreenState extends State<registroScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confimPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  void dispose() {
    // Libera los controladores cuando el widget se destruye
    _emailController.dispose();
    _passwordController.dispose();
    _confimPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Crear Cuenta",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: widget.modoOscuro ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor:
            widget.modoOscuro ? Colors.black : Colors.lightBlueAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: widget.modoOscuro
                ? [Colors.black, Colors.blueAccent]
                : [Colors.lightBlueAccent, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Únete a la mejor experiencia de streaming",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: widget.modoOscuro ? Colors.white : Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Crea una cuenta para acceder a contenido exclusivo.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: widget.modoOscuro
                          ? Colors.grey[300]
                          : Colors.grey[700],
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: "Nombre Completo",
                      hintStyle: TextStyle(
                        color: widget.modoOscuro
                            ? Colors.grey[200]
                            : Colors.grey[600],
                      ),
                      filled: true,
                      fillColor: widget.modoOscuro
                          ? Colors.grey[800]
                          : Colors.grey[300],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                    ),
                    style: TextStyle(
                      color: widget.modoOscuro ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "Correo Electrónico",
                      hintStyle: TextStyle(
                        color: widget.modoOscuro
                            ? Colors.grey[200]
                            : Colors.grey[600],
                      ),
                      filled: true,
                      fillColor: widget.modoOscuro
                          ? Colors.grey[800]
                          : Colors.grey[300],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                    ),
                    style: TextStyle(
                      color: widget.modoOscuro ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    obscureText: !_passwordVisible,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: "Contraseña",
                      hintStyle: TextStyle(
                        color: widget.modoOscuro
                            ? Colors.grey[200]
                            : Colors.grey[600],
                      ),
                      filled: true,
                      fillColor: widget.modoOscuro
                          ? Colors.grey[800]
                          : Colors.grey[300],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: widget.modoOscuro
                              ? Colors.grey[200]
                              : Colors.grey[600],
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                    ),
                    style: TextStyle(
                      color: widget.modoOscuro ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    obscureText: !_confirmPasswordVisible,
                    controller: _confimPasswordController,
                    decoration: InputDecoration(
                      hintText: "Confirmar Contraseña",
                      hintStyle: TextStyle(
                        color: widget.modoOscuro
                            ? Colors.grey[200]
                            : Colors.grey[600],
                      ),
                      filled: true,
                      fillColor: widget.modoOscuro
                          ? Colors.grey[800]
                          : Colors.grey[300],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _confirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: widget.modoOscuro
                              ? Colors.grey[200]
                              : Colors.grey[600],
                        ),
                        onPressed: () {
                          setState(() {
                            _confirmPasswordVisible = !_confirmPasswordVisible;
                          });
                        },
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                    ),
                    style: TextStyle(
                      color: widget.modoOscuro ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () => registro(
                      _emailController.text,
                      _passwordController.text,
                      _confimPasswordController.text,
                      context,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.modoOscuro
                          ? Colors.blueAccent
                          : Colors.lightBlueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Registrarse",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => loginScreen(
                            modoOscuro: widget.modoOscuro,
                            cambiarTema: widget.cambiarTema,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "¿Ya tienes una cuenta? Inicia Sesión",
                      style: TextStyle(
                        color: widget.modoOscuro
                            ? Colors.grey[300]
                            : Colors.blueAccent,
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
      Colors.orange,
    );
    return;
  }

  if (!validarContrasena(password)) {
    // Validación de contraseña débil
    mostrarAlerta(
      context,
      "Contraseña Débil",
      "La contraseña debe tener al menos 8 caracteres, incluyendo mayúsculas, minúsculas, números y un carácter especial. Los caracteres especiales permitidos son: @ \$ ! % * ? &",
      Icons.lock,
      Colors.orange,
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

// Función para validar que la contraseña cumpla con los requisitos
bool validarContrasena(String password) {
  // Expresión regular para validar la contraseña
  final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&#]{8,}$');
  return passwordRegex.hasMatch(password);
}

// Alerta personalizada
void error_alert(BuildContext context, String mensaje) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.error,
              color: Colors.orange,
            ),
            SizedBox(width: 8.0),
            Text("Error",
                style: TextStyle(
                  color: Colors.orange,
                )),
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
