import 'package:flutter/material.dart';

class TokenPage extends StatelessWidget {
  const TokenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Token Page',
            ),
            Text(
              'Manage your tokens here',
            ),
          ],
        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              IconButton.filled(onPressed: () {}, icon: Icon(Icons.add)),
              Text(
                'Send',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
          SizedBox(width: 32),
          Column(
            children: [
              IconButton.filled(onPressed: () {}, icon: Icon(Icons.add)),
              Text(
                'Send',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          )
        ],
      ),
    );
  }
}
