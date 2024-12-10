import 'package:app_netflix/screens/loginScreen.dart';
import 'package:app_netflix/screens/registroScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(Welcome());
}

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Oculta el banner de depuración
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueAccent,
        fontFamily: 'Arial', // Define una fuente predeterminada
      ),
      home: Cuerpo(),
    );
  }
}

class Cuerpo extends StatelessWidget {
  const Cuerpo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bienvenido",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(1, 1, 1, 1),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.blueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network("https://tinypic.host/images/2024/12/05/logoP.png",
                height: 400),
            SizedBox(height: 20),
            Text(
              "Explora un mundo de entretenimiento",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: 40),
            login_btn(context),
            SizedBox(height: 20),
            registro_btn(context),
          ],
        ),
      ),
    );
  }
}

Widget login_btn(context) {
  return ElevatedButton(
      onPressed: () => login(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        padding: EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        "Iniciar Sesión",
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ));
}

void login(context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => loginScreen()));
}

Widget registro_btn(context) {
  return ElevatedButton(
      onPressed: () => registro(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[600],
        padding: EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        "Registrarse",
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ));
}

void registro(context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => registroScreen()));
}
