import QtQuick

Item {
    id: root

    property alias text: input.text
    property alias passwordInput: input

    signal accepted()
    signal tabPressed()
    signal backtabPressed()

    TextInput {
        id: input

        width: parent.width
        height: parent.height

        color: "#aec6ff"
        selectionColor: "#aec6ff"
        selectedTextColor: "#002e6b"
        echoMode: TextInput.Password
        passwordMaskDelay: 0
        clip: true

        onAccepted: root.accepted()
        Keys.onTabPressed: root.tabPressed()
        Keys.onBacktabPressed: root.backtabPressed()

        font { family: "JetBrains Mono"; pointSize: 12; weight: Font.Medium }

        cursorDelegate: Rectangle {
            width: 8
            height: 14
            color: "#aec6ff"
            visible: input.activeFocus

            SequentialAnimation on opacity {
                running: input.activeFocus
                loops: Animation.Infinite
                NumberAnimation { to: 0.1; duration: 500 }
                NumberAnimation { to: 0.9; duration: 500 }
            }
        }
    }
}
