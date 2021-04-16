import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jitsi_meet/feature_flag/feature_flag.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:jitsi_meet/jitsi_meeting_listener.dart';
import 'package:jitsi_meet/room_name_constraint.dart';
import 'package:jitsi_meet/room_name_constraint_type.dart';
import 'package:pks_mobile/controllers/db_controller.dart';
import 'package:pks_mobile/helper/constants.dart';
import 'package:pks_mobile/helper/helper_function.dart';

class MeetingRoom extends GetWidget<DbController> {
  final String jitsiServer = 'https://meet.jit.si/';
  final bool isAudioOnly = true;
  final bool isAudioMuted = true;
  final bool isVideoMuted = true;
  final String _myUID = Constants.myUID.value;
  final String _docId = Get.arguments['docId'];
  final String _myPhotoUrl = Get.arguments['myPhotoUrl'];
  final String _myUsername = Get.arguments['myUsername'];
  final String _title = Get.arguments['title'];
  final String _toDeviceToken = Get.arguments['toDeviceToken'];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DbController>(
      initState: (_) {
        JitsiMeet.addListener(JitsiMeetingListener(
            onConferenceWillJoin: _onConferenceWillJoin,
            onConferenceJoined: _onConferenceJoined,
            onConferenceTerminated: _onConferenceTerminated,
            onPictureInPictureWillEnter: _onPictureInPictureWillEnter,
            onPictureInPictureTerminated: _onPictureInPictureTerminated,
            onError: _onError));
        _joinMeeting();
      },
      dispose: (val) {
        JitsiMeet.removeAllListeners();
      },
      builder: (ctrl) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.lightBlueAccent, Colors.purple],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: const Text('Meeting Room'),
          ),
          body: Container(
            color: Colors.transparent,
            child: Center(
              child: Text('Video call area!'),
            ),
          ),
        ),
      ),
    );
  }

  _joinMeeting() async {
    try {
      // Enable or disable any feature flag here
      // If feature flag are not provided, default values will be used
      // Full list of feature flags (and defaults) available in the README
      FeatureFlag featureFlag = FeatureFlag();
      featureFlag.welcomePageEnabled = false;
      // Here is an example, disabling features for each platform
      if (Platform.isAndroid) {
        // Disable ConnectionService usage on Android to avoid issues (see README)
        featureFlag.callIntegrationEnabled = false;
      } else if (Platform.isIOS) {
        // Disable PIP on iOS as it looks weird
        featureFlag.pipEnabled = false;
      }

      //uncomment to modify video resolution
      //featureFlag.resolution = FeatureFlagVideoResolution.MD_RESOLUTION;

      // Define meetings options here
      var options = JitsiMeetingOptions()
        ..room = _docId
        ..serverURL = jitsiServer
        ..subject = 'Video Call'
        ..userDisplayName = Constants.myUsername.value
        ..userEmail = Constants.myEmail.value
        ..audioOnly = isAudioOnly
        ..audioMuted = isAudioMuted
        ..videoMuted = isVideoMuted
        ..featureFlag = featureFlag;

      debugPrint("JitsiMeetingOptions: $options");
      await JitsiMeet.joinMeeting(
        options,
        listener: JitsiMeetingListener(onConferenceWillJoin: ({message}) {
          debugPrint("${options.room} will join with message: $message");
        }, onConferenceJoined: ({message}) {
          debugPrint("${options.room} joined with message: $message");
        }, onConferenceTerminated: ({message}) {
          debugPrint("${options.room} terminated with message: $message");
        }, onPictureInPictureWillEnter: ({message}) {
          debugPrint("${options.room} entered PIP mode with message: $message");
        }, onPictureInPictureTerminated: ({message}) {
          debugPrint("${options.room} exited PIP mode with message: $message");
        }),
        // by default, plugin default constraints are used
        //roomNameConstraints: new Map(), // to disable all constraints
        //roomNameConstraints: customContraints, // to use your own constraint(s)
      );
    } catch (error) {
      Get.offNamed('/on_jitsi_error', arguments: error);
    }
  }

  static final Map<RoomNameConstraintType, RoomNameConstraint>
      customContraints = {
    RoomNameConstraintType.MAX_LENGTH: new RoomNameConstraint((value) {
      return value.trim().length <= 50;
    }, "Maximum room name length should be 30."),
    RoomNameConstraintType.FORBIDDEN_CHARS: new RoomNameConstraint((value) {
      return RegExp(r"[$€£]+", caseSensitive: false, multiLine: false)
              .hasMatch(value) ==
          false;
    }, "Currencies characters aren't allowed in room names."),
  };

  void _onConferenceWillJoin({message}) {
    print('_onConferenceWillJoin $message');
    debugPrint("_onConferenceWillJoin broadcasted with message: $message");
  }

  void _onConferenceJoined({message}) {
    print('_onConferenceJoined $message');
    debugPrint("_onConferenceJoined broadcasted with message: $message");
  }

  void _onConferenceTerminated({message}) {
    Get.back();
    print('_onConferenceTerminated $message');
    debugPrint("_onConferenceTerminated broadcasted with message: $message");
  }

  void _onPictureInPictureWillEnter({message}) {
    print('_onPictureInPictureWillEnter $message');
    debugPrint(
        "_onPictureInPictureWillEnter broadcasted with message: $message");
  }

  void _onPictureInPictureTerminated({message}) {
    print('_onPictureInPictureTerminated $message');
    debugPrint(
        "_onPictureInPictureTerminated broadcasted with message: $message");
  }

  _onError(error) {
    print('_error $error');
    debugPrint("_onError broadcasted: $error");
  }
}
