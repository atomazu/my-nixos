pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Wayland
import "../Singletons"

Item {
    id: root
    property string targetText: ToplevelManager.activeToplevel.title
    property bool showingFirst: true

    anchors.centerIn: parent
    implicitWidth: Settings.bar.windowTitle.width

    Text {
        id: text1

        width: root.implicitWidth
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter

        elide: Text.ElideMiddle
        font.hintingPreference: Font.PreferFullHinting
        font.pointSize: Settings.bar.font.size
        color: Settings.bar.font.color
        opacity: 1

        Behavior on opacity {
            NumberAnimation {
                duration: 500
                easing.type: Easing.InOutCubic
            }
        }
    }

    Text {
        id: text2

        width: root.implicitWidth
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter

        elide: Text.ElideMiddle
        font.hintingPreference: Font.PreferFullHinting
        font.pointSize: Settings.bar.font.size
        color: Settings.bar.font.color
        opacity: 0

        Behavior on opacity {
            NumberAnimation {
                duration: 500
                easing.type: Easing.InOutCubic
            }
        }
    }

    onTargetTextChanged: {
        if (showingFirst) {
            text2.text = targetText;
            text1.opacity = 0;
            text2.opacity = 1;
        } else {
            text1.text = targetText;
            text2.opacity = 0;
            text1.opacity = 1;
        }
        showingFirst = !showingFirst;
    }

    Component.onCompleted: {
        text1.text = targetText;
    }
}
