import 'package:discourse/models/app_state.dart';
import 'package:discourse/ui/leave_wrapper.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as local;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as remote;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VideoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LeaveWrapper(
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                  heightFactor: 0.5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xffF16C41),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(60),
                child: Selector<AppState, List<int>>(
                  selector: (context, state) => state.otherUsers,
                  builder: (context, otherUsers, child) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: Center(
                          child: VideoPane(otherUsers.isNotEmpty
                              ? remote.SurfaceView(uid: otherUsers.first)
                              : null),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        margin: EdgeInsets.symmetric(vertical: 45),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(width: 3),
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: Selector<AppState, String>(
                          selector: (context, state) => state.topic,
                          builder: (context, topic, _) => Text(
                            topic,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: child),
                    ],
                  ),
                  child: Center(child: VideoPane(local.SurfaceView())),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    onPressed: () => LeaveWrapper.onLeave(context),
                    icon: Icon(Icons.call_end),
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class VideoPane extends StatelessWidget {
  final Widget video;

  VideoPane(this.video);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: AspectRatio(
        aspectRatio: 1,
        child: video ?? Container(color: Colors.black54),
      ),
    );
  }
}
