import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late  final LocalAuthentication auth;
  bool _supportstate = false;
  String authen = "Authenticate Please";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then((bool isSupported) => setState((){
         _supportstate = isSupported;
    })
    
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:   ElevatedButton(onPressed: _authenticate, child: Text("$authen")),
      ),
      )
    ;
  }
Future<void> _authenticate()async{
  try {
    bool authenticated = await auth.authenticate(localizedReason: "Authenticated",
    options: const AuthenticationOptions(
      stickyAuth: true,
      biometricOnly: false ,
    ),
    
    );
    setState(() {
      authen = "Authenticated";
    });
  } catch (e) {
    print("NOt authenticated,${e}");
  }
}

  Future<void> _getavailablebiometrics() async{
   List<BiometricType> availableBiometrics = await  auth.getAvailableBiometrics();
   print("List: ${availableBiometrics}");
   if (!mounted) {
    return;
     
   }
  }
}