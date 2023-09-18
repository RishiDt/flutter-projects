import 'package:flutter/material.dart';

class EmailComposeScreen extends StatelessWidget {
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  void _sendEmail(BuildContext context) async {
    // Implement sending the email here
    String subject = subjectController.text;
    String body = bodyController.text;

    // You can implement the email sending logic, e.g., using an email library or service.
    print('Subject: $subject');
    print('Body: $body');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Compose Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: subjectController,
              decoration: InputDecoration(
                hintText: "Enter Subject",
                fillColor: Colors.white,
                hintStyle: TextStyle(
                  fontSize: 20,
                  color:
                      Colors.grey, // Replace with your desired hint text color
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.blue), // Replace with your desired color
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.grey), // Replace with your desired color
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: bodyController,
              maxLines: null, // Allow multiple lines for the body
              decoration: InputDecoration(
                hintText: "Enter Body",
                fillColor: Colors.white,
                hintStyle: TextStyle(
                  fontSize: 20,
                  color:
                      Colors.grey, // Replace with your desired hint text color
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.blue), // Replace with your desired color
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.grey), // Replace with your desired color
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _sendEmail(context),
              child: Text(
                'Send',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: EmailComposeScreen(),
  ));
}
