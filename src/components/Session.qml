import QtQuick
import QtQuick.Controls

Item {
    id: root

    width: 200
    height: 20

    Row {
        anchors.fill: parent
        spacing: 16

        Text {
            id: previousButton
            height: parent.height
            text: "<"
            font {
                family: "Jetbrains Mono"
                pixelSize: 12
                weight: Font.Medium
            }
            color: "white"
        }

        Item {
            width: parent.width - previousButton.width - nextButton.width - parent.spacing * 2
            height: parent.height

            Label {
                anchors.centerIn: parent
                text: root.currentSessionName
                font {
                    family: "Jetbrains Mono"
                    pixelSize: 12
                    weight: Font.Medium
                }
                color: "#e2e1f1"
            }
        }

        Text {
            id: nextButton
            height: parent.height
            text: ">"
            font {
                family: "Jetbrains Mono"
                pixelSize: 12
                weight: Font.Medium
            }
            color: "#e2e1f1"
        }
    }

    Keys.onLeftPressed: previous()
    Keys.onRightPressed: next()
}
