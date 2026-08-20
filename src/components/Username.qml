import QtQuick

Item {
    id: root

    property bool hasUser: false
    property string username: ""

    Text {
        id: usernameDisplay

        text: username !== "" ? username : "---"
        color: "#e2e1f1"
        visible: hasUser
        font {
            family: "Jetbrains Mono"
            pointSize: 12
            weight: Font.Medium
        }
    }

    TextInput {
        id: usernameInput
        width: parent.width
        color: "#e2e1f1"
        visible: !hasUser
        cursorVisible: true
        KeyNavigation.tab: passwordInput
        onAccepted: passwordInput.forceActiveFocus()
        font {
            family: "Jetbrains Mono"
            pointSize: 12
            weight: Font.Medium
        }
    }
}
