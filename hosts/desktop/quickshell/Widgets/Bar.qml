pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import QtQuick.Layouts
import "../Components"
import "../Singletons"

PanelWindow { //qmllint disable
    id: root
    required property var modelData

    screen: modelData
    color: Settings.bar.background
    implicitHeight: Settings.bar.height

    anchors {
        top: Settings.bar.position === "top"
        bottom: Settings.bar.position === "bottom"
        left: true
        right: true
    }

    WindowTitle {}

    RowLayout {
        anchors.fill: parent
        spacing: Settings.bar.spacing
        anchors.rightMargin: Settings.bar.margin.right
        anchors.leftMargin: Settings.bar.margin.left

        Workspaces {
            modelData: root.modelData
        }

        Item {
            id: filler
            Layout.fillWidth: true
        }

        Tray {}

        DateTime {}
    }
}
