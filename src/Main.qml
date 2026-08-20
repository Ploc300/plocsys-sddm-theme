import QtQuick
import SddmComponents
import QtMultimedia

import "components"

Item {
    id: page
    width: 1920
    height: 1080

    Component.onCompleted: {
        Username.usernameInput.forceActiveFocus();
        console.log(Username.usernameInput.activeFocus);
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
    }

    MediaPlayer {
        id: background_mediaplayer
        source: Qt.resolvedUrl("Assets/background.webm")
        autoPlay: true
        loops: MediaPlayer.Infinite
        videoOutput: background_video
    }

    VideoOutput {
        id: background_video
        fillMode: VideoOutput.PreserveAspectFit
        anchors.fill: parent
    }

    Grid {
        id: loginGrid
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 20
        }

        columns: 3
        rows: 2
        rowSpacing: 20
        columnSpacing: 80

        horizontalItemAlignment: Grid.AlignHCenter

        Text {
            id: sessionLabel
            text: "Session"
            color: "#c3c6d3"
            font {
                family: "Jetbrains Mono"
                pointSize: 13
                weight: Font.Medium
            }
        }

        Text {
            id: usernameLabel
            text: "Username"
            color: "#c3c6d3"
            font {
                family: "Jetbrains Mono"
                pointSize: 13
                weight: Font.Medium
            }
        }

        Text {
            id: passwordLabel
            text: "Password"
            color: "#c3c6d3"
            font {
                family: "Jetbrains Mono"
                pointSize: 13
                weight: Font.Medium
            }
        }

        Session {}
        Username {
            width: 200
            height: 20
        }
    }
}
