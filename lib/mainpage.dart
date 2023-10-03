import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final LocalAuthentication auth;
  bool _supportstate = false;
  String authen = "Authenticate Please";
  bool enableAuthentication = false;

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then((bool isSupported) {
      setState(() {
        _supportstate = isSupported;
      });
    });
    _loadEnableAuthenticationState();
  }

  Future<void> _loadEnableAuthenticationState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isEnabled = prefs.getBool('enableAuthentication') ?? false;
    setState(() {
      enableAuthentication = isEnabled;
      authen = isEnabled ? "Authenticated" : "Authentication Disabled";
    });
  }

  // Function to save the state of enableAuthentication to SharedPreferences
  Future<void> _saveEnableAuthenticationState(bool isEnabled) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('enableAuthentication', isEnabled);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                "$authen",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Enable Authentication"),
                Switch(
                  value: enableAuthentication,
                  onChanged: (value) {
                    setState(() {
                      enableAuthentication = value;
                      authen = value
                          ? "Authenticate Please"
                          : "Authentication Disabled";
                    });
                    _saveEnableAuthenticationState(
                        value); // Save the state to SharedPreferences
                    if (value) {
                      _authenticate();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: "Authenticated",
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
      if (authenticated) {
        setState(() {
          authen = "Authenticated";
          enableAuthentication = true;
        });
      } else {
        setState(() {
          authen = "Authentication Failed";
          enableAuthentication = false;
        });
      }
    } catch (e) {
      print("Not authenticated, $e");
    }
  }

  Future<void> _getavailablebiometrics() async {
    List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();
    print("List: $availableBiometrics");
    if (!mounted) {
      return;
    }
  }
}
