import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pedantic/pedantic.dart';
import 'package:permission_handler/permission_handler.dart';

/// Describes a position on a controversial topic
enum Position { yes, no }

class AppState extends ChangeNotifier {
  bool isAuthenticated;
  bool connectedToVideo;
  List<int> otherUsers;
  String topic;

  String _name;
  Position _position;
  String _userId;
  String _appId;

  /// Subscribe to changes in the video channel id
  StreamSubscription _videoChannelSubscription;

  FirebaseAuth _auth;
  DatabaseReference _db;
  RtcEngine _engine;
  final NavigatorState _navigator;

  AppState(this._navigator)
      : isAuthenticated = false,
        connectedToVideo = false,
        topic = '',
        otherUsers = List(0) {
    _init();
  }

  /// Get the current user's name
  String get name => _name;

  /// Async initialization
  void _init() async {
    await Firebase.initializeApp();

    _auth = FirebaseAuth.instance;
    _db = FirebaseDatabase.instance.reference();

    topic = ((await _db.child('topic').once()).value as String) ?? '';
    _appId = ((await _db.child('appId').once()).value as String) ?? '';
  }

  /// Save the current user's position on the topic
  void savePosition(Position position) async {
    unawaited(_navigator.pushNamed('/loading'));
    _position = position;
    var credential = await _auth.signInAnonymously();
    _userId = credential.user.uid;
    var userRef = _db.child('positions/${_position.index}').child(_userId);
    await userRef.set({
      'joined': DateTime.now().millisecondsSinceEpoch,
      'name': _name,
    });

    /// Wait for the server to assign a video channel and token
    _videoChannelSubscription =
        userRef.child('videoData').onValue.listen((event) async {
      var videoData = event.snapshot.value;
      if (videoData != null) {
        connectedToVideo = true;
        notifyListeners();

        await _joinVideo(videoData['token'], videoData['channel']);
        unawaited(_navigator.pushNamed('/video'));
      }
    });
  }

  /// Join the video channel with the given info
  Future<void> _joinVideo(String token, String videoChannel) async {
    await PermissionHandler().requestPermissions([
      PermissionGroup.camera,
      PermissionGroup.microphone,
    ]);
    _engine = await RtcEngine.create(_appId);
    _addAgoraEventHandlers();
    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.Communication);
    await _engine.setVideoEncoderConfiguration(
        VideoEncoderConfiguration(dimensions: VideoDimensions(1080, 1080)));
    await _engine.joinChannelWithUserAccount(token, videoChannel, _userId);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(
      error: (code) {
        print('onError: $code');
      },
      joinChannelSuccess: (channel, uid, elapsed) {
        print('onJoinChannel: $channel, uid: $uid');
      },
      leaveChannel: (stats) {
        _onLeave();
      },
      userJoined: (uid, elapsed) {
        print('userJoined: $uid');
        otherUsers = [...otherUsers, uid];
        notifyListeners();
      },
      userOffline: (uid, elapsed) {
        print('userOffline: $uid');
        otherUsers = [...otherUsers.where((id) => id != uid)];

        if (otherUsers.isEmpty) {
          leaveVideo();
        }

        notifyListeners();
      },
      firstRemoteVideoFrame: (uid, width, height, elapsed) {
        print('firstRemoteVideo: $uid ${width}x $height');
      },
    ));
  }

  /// Make this user leave the video channel
  void leaveVideo() async {
    var connectionState = await _engine?.getConnectionState();
    if (connectionState != ConnectionStateType.Disconnected) {
      unawaited(_engine?.leaveChannel());
    }
    _navigator.popUntil((route) => route.isFirst);

    _onLeave();
  }

  /// Cleanup actions to perform after leaving the video channel
  void _onLeave() async {
    connectedToVideo = false;
    otherUsers = List(0);
    await _videoChannelSubscription?.cancel();

    await _db.child('positions/${_position.index}').child(_userId).remove();

    notifyListeners();
  }

  /// Set the user's name to the given name
  void saveName(String name) {
    _name = name;
  }

  @override
  void dispose() {
    _db.child('positions/${_position.index}').child(_userId).remove();
    _videoChannelSubscription?.cancel();
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
  }
}
