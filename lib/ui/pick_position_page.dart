import 'package:discourse/models/app_state.dart';
import 'package:discourse/ui/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PickPositionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(60),
              child: Selector<AppState, String>(
                selector: (context, state) => state.topic,
                builder: (context, topic, _) => Text(
                  topic,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  text: 'Yes',
                  onPressed: () {
                    context.read<AppState>().savePosition(Position.yes);
                  },
                ),
                SizedBox(width: 20),
                CustomButton(
                  text: 'No',
                  onPressed: () {
                    context.read<AppState>().savePosition(Position.no);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
