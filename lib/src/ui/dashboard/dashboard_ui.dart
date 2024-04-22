import 'package:flutter/material.dart';

import '../../shared/utils/url.dart';

class DashboardUI extends StatelessWidget {
  const DashboardUI({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> create() async {
      if (pb.authStore.model != null) {
        final body = <String, dynamic>{
          "user": pb.authStore.model.id,
          "notes": 'oke',
        };

        final record = await pb.collection('notes').create(body: body);
        print(record);
      } else {
        print('User is not logged in');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: const [],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text("Dashboard"),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  create();
                },
                child: const Text("Create Note"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
