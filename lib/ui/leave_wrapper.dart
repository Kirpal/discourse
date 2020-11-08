import 'package:discourse/models/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Wrap pages where we want to warn the user about
/// leaving the chat on back button press
class LeaveWrapper extends StatelessWidget {
  final Widget child;

  LeaveWrapper({@required this.child});

  static Future<bool> onLeave(BuildContext context) async {
    var willPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Do you want to leave?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Leave', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );

    if (willPop ?? false) {
      context.read<AppState>().leaveVideo();
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onLeave(context),
      child: child,
    );
  }
}
