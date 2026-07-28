import QtQuick
import SddmComponents
import QtMultimedia

Item {
    id: page
    width: 1920
    height: 1080

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

    Rectangle {
        id: loginContainer
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 120
        }
        width: 400
        height: 80
        color: "#1e1f2a"
        border.color: "#434751"
        border.width: 1
        radius: 4
        visible: false
        opacity: 0

        Behavior on opacity {
            NumberAnimation { duration: 800 }
        }

        Loader {
            id: loginLoader
            x: 0
            y: 0
            width: parent.width
            height: parent.height
            source: "Login.qml"
            onLoaded: {
                item.selectedSession = Qt.binding(function() {
                    return sessionSelect.currentIndex
                })
            }
        }
    }

    Timer {
        id: loginDelay
        interval: 2000
        running: true
        repeat: false
        onTriggered: {
            loginContainer.visible = true
            loginContainer.opacity = 1
            if (loginLoader.item) {
                if (loginLoader.item.hasUser) {
                    loginLoader.item.passwordFocus = true
                } else {
                    loginLoader.item.userFocus = true
                }
            }
        }
    }
}
