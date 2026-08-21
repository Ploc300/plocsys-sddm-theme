import QtQuick
import QtMultimedia

import "components"

Item {
    id: root

    readonly property string fontFamily: "JetBrains Mono"
    readonly property color textColor: "#e2e1f1"
    readonly property color accentColor: "#aec6ff"
    readonly property color labelColor: "#c3c6d3"
    readonly property color errorColor: "#ffb4ab"
    readonly property color backgroundColor: "#12131d"

    property bool hasUser: false
    property string lastUser: ""

    Component.onCompleted: initTimer.start()

    Timer {
        id: initTimer
        interval: 100

        onTriggered: {
            var xhr = new XMLHttpRequest();
            xhr.open("GET", "file:///var/lib/sddm/state.conf", false);
            xhr.send();

            var match = xhr.responseText.match(/User=(\S+)/);
            lastUser = match ? match[1] : "";
            hasUser = lastUser !== "";

            usernameField.hasUser = hasUser;
            usernameField.username = lastUser;

            if (hasUser)
                passwordField.passwordInput.forceActiveFocus();
            else
                usernameField.usernameInput.forceActiveFocus();
        }
    }

    function login() {
        var user = hasUser ? lastUser : usernameField.usernameInput.text;

        if (user === "") {
            showError("No username provided");
            return;
        }

        errorMsg.visible = false;
        sddm.login(user, passwordField.text, sessionField.currentIndex);
    }

    function showError(msg) {
        errorMsg.text = msg;
        errorMsg.visible = true;
        errorTimer.restart();
    }

    Connections {
        target: sddm

        function onLoginFailed() {
            showError("Access Denied");
            passwordField.text = "";
            passwordField.passwordInput.forceActiveFocus();
        }
    }

    // Background

    Rectangle {
        anchors.fill: parent
        color: root.backgroundColor
    }

    MediaPlayer {
        id: backgroundPlayer
        source: Qt.resolvedUrl("Assets/background.webm")
        autoPlay: true
        loops: MediaPlayer.Infinite
        videoOutput: backgroundVideo
    }

    VideoOutput {
        id: backgroundVideo
        anchors.fill: parent
        fillMode: VideoOutput.PreserveAspectCrop
    }

    // Login form

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
            text: "Session"
            color: root.labelColor
            font { family: root.fontFamily; pointSize: 13; weight: Font.Medium }
        }

        Text {
            text: "Username"
            color: root.labelColor
            font { family: root.fontFamily; pointSize: 13; weight: Font.Medium }
        }

        Text {
            text: "Password"
            color: root.labelColor
            font { family: root.fontFamily; pointSize: 13; weight: Font.Medium }
        }

        Session {
            id: sessionField

            onTabPressed: {
                if (hasUser)
                    passwordField.passwordInput.forceActiveFocus();
                else
                    usernameField.usernameInput.forceActiveFocus();
            }
            onBacktabPressed: passwordField.passwordInput.forceActiveFocus()
        }

        Username {
            id: usernameField
            width: 200
            height: 20

            onAccepted: passwordField.passwordInput.forceActiveFocus()
            onTabPressed: passwordField.passwordInput.forceActiveFocus()
            onBacktabPressed: sessionField.forceActiveFocus()
        }

        Password {
            id: passwordField
            width: 200
            height: 20

            onAccepted: root.login()
            onTabPressed: sessionField.forceActiveFocus()
            onBacktabPressed: {
                if (hasUser)
                    sessionField.forceActiveFocus();
                else
                    usernameField.usernameInput.forceActiveFocus();
            }
        }
    }

    // Error message

    Text {
        id: errorMsg

        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: loginGrid.top
            bottomMargin: 16
        }

        visible: false
        color: root.errorColor
        font { family: root.fontFamily; pointSize: 12; weight: Font.Medium }
    }

    Timer {
        id: errorTimer
        interval: 3000
        onTriggered: errorMsg.visible = false
    }
}
