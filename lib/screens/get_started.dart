import 'package:ezi_taskmanager/screens/add_task.dart';
import 'package:flutter/material.dart';

class ImageWithTextDemo extends StatelessWidget {
  final List<String> tasks;
  ImageWithTextDemo({required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  bottom: 0.14 *
                      MediaQuery.of(context)
                          .size
                          .height), // Add space to the top
              child: Image.asset(
                'assets/images/getstarted2.jfif', // Replace with your image asset path
                width: 0.9 *
                    MediaQuery.of(context)
                        .size
                        .width, // Use percentage of screen width for image width
                height: 0.8 *
                    MediaQuery.of(context)
                        .size
                        .width, // Use percentage of screen width for image height
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: 0.1 * MediaQuery.of(context).size.height),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddListScreen(tasks:tasks,)),
                  );
                },
                child: Text(
                  'Get started',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red[400], // Background color of the button
                  onPrimary: Colors.white, // Text color of the button
                  padding: EdgeInsets.symmetric(
                      horizontal: 0.2 * MediaQuery.of(context).size.width,
                      vertical: 0.02 *
                          MediaQuery.of(context)
                              .size
                              .height), // Use percentages for padding
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(1), // BorderRadius of the button
                  ),
                  elevation: 1, // Elevation of the button
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
