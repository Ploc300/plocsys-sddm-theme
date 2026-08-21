import QtQuick

Item {
    id: root

    property bool hasUser: false
    property string username: ""
    property alias usernameInput: input

    signal accepted()
    signal tabPressed()
    signal backtabPressed()

    Text {
        text: root.username || "---"
        color: "#e2e1f1"
        visible: root.hasUser
        font { family: "JetBrains Mono"; pointSize: 12; weight: Font.Medium }
    }

    TextInput {
        id: input

        width: parent.width
        color: "#e2e1f1"
        selectionColor: "#aec6ff"
        selectedTextColor: "#002e6b"
        visible: !root.hasUser

        onAccepted: root.accepted()
        Keys.onTabPressed: root.tabPressed()
        Keys.onBacktabPressed: root.backtabPressed()

        font { family: "JetBrains Mono"; pointSize: 12; weight: Font.Medium }
    }
}
