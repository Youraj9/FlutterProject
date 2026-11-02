import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: Signup(), debugShowCheckedModeBanner: false));
}

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final bool t1 = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              child: Column(
                children: [
                  Text("FoodMood", style: TextStyle(fontSize: 26)),
                  const SizedBox(height: 10),
                  Icon(Icons.dining, color: Colors.orange, size: 40),
                  const SizedBox(height: 10),
                  Text(
                    "Create Your account ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Join FoodMood and discover great food.",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 75, 74, 74),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            // Text(
            //   "Full name",
            //   style: TextStyle(
            //     color: Colors.black,
            //     fontSize: 16,
            //     fontWeight: FontWeight.bold,
            //   ),

            // ),
            Expanded(
              child: Form(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Full name",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.man_3, color: Colors.amber),
                          // border: Border.all(color: Colors.blue, width: 3),
                          hintText: "Enter your name ",

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                      Text(
                        "email address",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.man_3, color: Colors.amber),
                          // border: Border.all(color: Colors.blue, width: 3),
                          hintText: "Enter your name ",

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                      Text(
                        "Password",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.man_3, color: Colors.amber),
                          // border: Border.all(color: Colors.blue, width: 3),
                          hintText: "Enter your name ",

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                      Text(
                        "confirm password",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.man_3, color: Colors.amber),
                          // border: Border.all(color: Colors.blue, width: 3),
                          hintText: "Enter your name ",

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Checkbox(value: t1, onChanged: (bool? t) {}),
                          SizedBox(width: 12),
                          Text(
                            "I agree TO THE tERMS of service and Privacy policy",
                          ),

                          // Expanded(
                          //   child: FilledButton(
                          //     onPressed: () {},
                          //     style: FilledButton.styleFrom(
                          //       backgroundColor: Colors
                          //           .orange, // 🟠 Sets the background to orange
                          //       foregroundColor: Colors.white,
                          //     ),

                          //     child: Text(
                          //       "Create account",
                          //       style: TextStyle(color: Colors.white),
                          //       textAlign: TextAlign.center,
                          //     ),
                          //   ),
                        ],
                      ),

                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {},
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors
                                .orange, // 🟠 Sets the background to orange
                            foregroundColor: Colors.white,
                          ),

                          child: Text(
                            "Create account",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              247,
                              247,
                              247,
                            ), // 🟠 Sets the background to orange
                            foregroundColor: const Color.fromARGB(
                              255,
                              138,
                              138,
                              138,
                            ),
                          ),
                          onPressed: () {
                            // debugprint();
                          },
                          child: Text("Continue with Google"),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("already have an account "),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              "log in ",
                              style: TextStyle(color: Colors.orange),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
