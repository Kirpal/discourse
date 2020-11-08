const { RtcTokenBuilder, RtcRole } = require("agora-access-token");
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { APP_ID, APP_CERTIFICATE } = require("./secrets");

const app = admin.initializeApp();
const db = admin.database();

const ALL_POSITIONS = [0, 1];

exports.pairUsers = functions.database
  .ref("positions/{position}/{userId}")
  .onCreate(async (snapshot, context) => {
    var other_positions = ALL_POSITIONS.filter(
      (p) => p !== parseInt(context.params.position)
    );

    other_positions.forEach(async (p) => {
      var users = await db
        .ref("positions")
        .child(p)
        .orderByChild("joined")
        .once("value");
      users.forEach((s) => {
        if (!s.hasChild("videoData") && s.key !== snapshot.key) {
          const channelName = snapshot.key + "~" + s.key;
          saveVideoData(s, channelName);
          saveVideoData(snapshot, channelName);
          return true;
        }
        return false;
      });
    });

    return null;
  });

function saveVideoData(snapshot, channelName) {
  const expirationTimeInSeconds = 3600;
  const currentTimestamp = Math.floor(Date.now() / 1000);
  const privilegeExpiredTs = currentTimestamp + expirationTimeInSeconds;

  const token = RtcTokenBuilder.buildTokenWithAccount(
    APP_ID,
    APP_CERTIFICATE,
    channelName,
    snapshot.key,
    RtcRole.PUBLISHER,
    privilegeExpiredTs
  );

  snapshot.ref.child("videoData").set({
    token: token,
    channel: channelName,
  });
}
