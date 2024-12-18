import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:app_netflix/screens/loginScreen.dart';
import 'package:app_netflix/screens/registroScreen.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Welcome());
}

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  bool _modoOscuro = true; // Estado inicial: Modo oscuro

  // Método para cambiar el tema
  void _cambiarTema(bool esOscuro) {
    setState(() {
      _modoOscuro = esOscuro;
    });
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _temaActual,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(gradient: _gradienteActual),
          child: SafeArea(
            child: Stack(
              children: [
                // Título centrado
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "Bienvenido",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: _modoOscuro ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
                // Botón de cambio de modo en la esquina superior derecha
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    icon: Icon(
                      _modoOscuro ? Icons.light_mode : Icons.dark_mode,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _cambiarTema(!_modoOscuro);
                    },
                    tooltip: 'Alternar Modo Oscuro',
                  ),
                ),
                // Contenido principal
                Column(
                  children: [
                    Expanded(
                      child: Cuerpo(
                        modoOscuro: _modoOscuro,
                        cambiarTema: _cambiarTema,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Cuerpo extends StatelessWidget {
  final bool modoOscuro;
  final Function(bool) cambiarTema;

  const Cuerpo(
      {super.key, required this.modoOscuro, required this.cambiarTema});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.network("https://i.imgur.com/3esoQkS.png", height: 400),
          const SizedBox(height: 20),
          const Text(
            "Explora un mundo de entretenimiento",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 40),
          login_btn(context),
          const SizedBox(height: 20),
          registro_btn(context),
        ],
      ),
    );
  }

  Widget login_btn(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => loginScreen(
              modoOscuro: modoOscuro,
              cambiarTema: cambiarTema,
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: const Text(
        "Iniciar Sesión",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget registro_btn(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => registroScreen(
              modoOscuro: modoOscuro,
              cambiarTema: cambiarTema,
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: const Text(
        "Registrarse",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
