import QtQuick

Item {
    id: loginConsole

    width: parent ? parent.width : 480
    height: parent ? parent.height : 80

    property int selectedSession: 0
    property bool hasUser: false
    property string userName: ""

    property alias passwordFocus: passwordInput.focus
    property alias userFocus: userInput.focus

    onVisibleChanged: {
        if (visible)
            focusTimer.start()
    }

    Timer {
        id: focusTimer
        interval: 200
        repeat: false

        onTriggered: {
            if (hasUser)
                passwordInput.forceActiveFocus()
            else
                userInput.forceActiveFocus()
        }
    }

    Component.onCompleted: initTimer.start()

    Timer {
        id: initTimer
        interval: 100
        repeat: false

        onTriggered: {
            var xhr = new XMLHttpRequest()
            xhr.open("GET", "file:///var/lib/sddm/state.conf", false)
            xhr.send()

            var match = xhr.responseText.match(/User=(\S+)/)
            var last = match ? match[1] : ""

            hasUser = last !== ""
            userName = last
        }
    }

    function login() {
        var user = hasUser ? userName : userInput.text

        if (user === "") {
            showError("Really? No username...")
            return
        }

        errorMsg.visible = false
        sddm.login(user, passwordInput.text, selectedSession)
    }

    function showError(msg) {
        errorMsg.text = msg
        errorMsg.visible = true
        errorTimer.restart()
    }

    Connections {
        target: sddm

        function onLoginFailed() {
            showError("Access Denied")
            passwordInput.text = ""
            passwordInput.forceActiveFocus()
        }
    }

    Rectangle {
        id: separator

        x: 16
        y: titleText.y + titleText.height + 8
        width: parent.width - 32
        height: 1
        color: "#434751"
    }

    Text {
        id: labelUser

        x: 16
        y: titleText.y + titleText.height + 20
        text: "> Username:"
        color: "#c3c6d3"

        font {
            family: "Jetbrains Mono"
            pointSize: 12
            weight: Font.Medium
        }
    }

    Text {
        id: userDisplay

        x: labelUser.x + labelUser.width + 8
        y: labelUser.y
        text: userName !== "" ? userName : "---"
        color: "#e2e1f1"
        visible: hasUser

        font {
            family: "Jetbrains Mono"
            pointSize: 12
            weight: Font.Medium
        }
    }

    Text {
        id: identifiedLabel

        x: userDisplay.x + userDisplay.width + 8
        y: labelUser.y
        text: "[✓ IDENTIFIED]"
        color: "#aec6ff"
        visible: hasUser

        font {
            family: "Jetbrains Mono"
            pointSize: 12
            weight: Font.Medium
        }
    }

    TextInput {
        id: userInput

        x: labelUser.x + labelUser.width + 8
        y: labelUser.y
        width: 160

        color: "#e2e1f1"
        visible: !hasUser
        cursorVisible: true

        KeyNavigation.tab: passwordInput
        onAccepted: passwordInput.forceActiveFocus()

        font {
            family: "Jetbrains Mono"
            pointSize: 14
            weight: Font.Medium
        }

        cursorDelegate: Rectangle {
            width: 8
            height: 14
            visible: userInput.activeFocus
            opacity: userInput.activeFocus ? 0.9 : 0
            color: "#aec6ff"

            SequentialAnimation on opacity {
                running: userInput.activeFocus
                loops: Animation.Infinite

                NumberAnimation {
                    to: 0.1
                    duration: 500
                }

                NumberAnimation {
                    to: 0.9
                    duration: 500
                }
            }
        }

        Rectangle {
            x: 0
            y: parent.height
            width: parent.width
            height: 1
            color: userInput.activeFocus ? "#aec6ff" : "#434751"
        }
    }

    Text {
        id: labelPass

        x: 16
        y: labelUser.y + 30
        text: "> Password:"
        color: "#c3c6d3"

        font {
            family: "Jetbrains Mono"
            pointSize: 12
            weight: Font.Medium
        }
    }

    Rectangle {
        id: enterBtn

        anchors.right: parent.right
        anchors.rightMargin: 16
        anchors.verticalCenter: labelPass.verticalCenter

        width: enterLabel.implicitWidth + 20
        height: 22
        radius: 4
        color: "#7aa2f7"

        border.color: "#7aa2f7"
        border.width: 1

        Text {
            id: enterLabel

            anchors.centerIn: parent
            text: "ENTER"
            color: "#002e6b"

            font {
                family: "Jetbrains Mono"
                pointSize: 12
                weight: Font.Medium
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onEntered: enterBtn.color = "#aec6ff"
            onExited: enterBtn.color = "#7aa2f7"
            onClicked: loginConsole.login()
        }
    }

    TextInput {
        id: passwordInput

        anchors.left: labelPass.right
        anchors.leftMargin: 8
        anchors.right: enterBtn.left
        anchors.rightMargin: 12
        anchors.verticalCenter: labelPass.verticalCenter

        clip: true
        autoScroll: true
        wrapMode: TextInput.NoWrap
        cursorVisible: true

        color: "#aec6ff"
        echoMode: TextInput.Password
        passwordMaskDelay: 0

        onAccepted: loginConsole.login()

        font {
            family: "Jetbrains Mono"
            pointSize: 14
            weight: Font.Medium
        }

        cursorDelegate: Rectangle {
            width: 8
            height: 14
            visible: passwordInput.activeFocus
            opacity: passwordInput.activeFocus ? 0.9 : 0
            color: "#aec6ff"

            SequentialAnimation on opacity {
                running: passwordInput.activeFocus
                loops: Animation.Infinite

                NumberAnimation {
                    to: 0.1
                    duration: 500
                }

                NumberAnimation {
                    to: 0.9
                    duration: 500
                }
            }
        }

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.bottom
            anchors.topMargin: 2

            height: 1
            color: passwordInput.activeFocus ? "#aec6ff" : "#434751"
        }
    }

    Text {
        id: errorMsg

        x: 0
        y: labelPass.y + 30
        width: loginConsole.width

        horizontalAlignment: Text.AlignHCenter
        text: ""
        color: "#ffb4ab"
        visible: false

        font {
            family: "Jetbrains Mono"
            pointSize: 12
            weight: Font.Medium
        }
    }

    Timer {
        id: errorTimer
        interval: 3000
        repeat: false

        onTriggered: errorMsg.visible = false
    }
}
