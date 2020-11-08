import 'package:discourse/models/app_state.dart';
import 'package:discourse/ui/leave_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LeaveWrapper(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.black),
              ),
            ),
            Center(
              child: Selector<AppState, bool>(
                selector: (context, state) => state.connectedToVideo,
                builder: (context, connected, _) => Text(
                  connected ? 'Connecting video...' : 'Finding a match...',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
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
