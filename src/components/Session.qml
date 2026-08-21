import QtQuick

FocusScope {
    id: root

    width: 200
    height: 20

    property int currentIndex: sessionModel.lastIndex >= 0 ? sessionModel.lastIndex : 0

    readonly property string currentSessionName: {
        if (currentIndex >= 0 && currentIndex < sessionInstantiator.count) {
            var obj = sessionInstantiator.objectAt(currentIndex);
            return obj ? obj.name : "---";
        }
        return "---";
    }

    signal tabPressed()
    signal backtabPressed()

    function previous() {
        var count = sessionInstantiator.count;
        if (count > 0)
            currentIndex = (currentIndex - 1 + count) % count;
    }

    function next() {
        var count = sessionInstantiator.count;
        if (count > 0)
            currentIndex = (currentIndex + 1) % count;
    }

    Keys.onTabPressed: tabPressed()
    Keys.onBacktabPressed: backtabPressed()

    Keys.onLeftPressed: (event) => {
        previous();
        event.accepted = true;
    }

    Keys.onRightPressed: (event) => {
        next();
        event.accepted = true;
    }

    Instantiator {
        id: sessionInstantiator
        model: sessionModel
        delegate: QtObject { required property string name }
    }

    // Invisible item that holds active focus within this FocusScope,
    // enabling key event delivery to the Keys handlers above.
    Item { focus: true }

    Row {
        anchors.fill: parent
        spacing: 16

        Text {
            id: prevArrow
            height: parent.height
            text: "<"
            color: root.activeFocus ? "#aec6ff" : "#e2e1f1"
            font { family: "JetBrains Mono"; pixelSize: 12; weight: Font.Medium }
        }

        Item {
            width: parent.width - prevArrow.width - nextArrow.width - parent.spacing * 2
            height: parent.height

            Text {
                anchors.centerIn: parent
                text: root.currentSessionName
                color: root.activeFocus ? "#aec6ff" : "#e2e1f1"
                font { family: "JetBrains Mono"; pixelSize: 12; weight: Font.Medium }
            }
        }

        Text {
            id: nextArrow
            height: parent.height
            text: ">"
            color: root.activeFocus ? "#aec6ff" : "#e2e1f1"
            font { family: "JetBrains Mono"; pixelSize: 12; weight: Font.Medium }
        }
    }
}
