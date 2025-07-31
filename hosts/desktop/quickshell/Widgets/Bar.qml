pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.Services
import qs.Widgets.Bar

PanelWindow { //qmllint disable
    id: root
    required property var modelData

    screen: modelData
    color: Config.bar.background
    implicitHeight: Config.bar.height

    anchors {
        top: Config.bar.position === "top"
        bottom: Config.bar.position === "bottom"
        left: true
        right: true
    }

    WindowTitle {}

    RowLayout {
        anchors.fill: parent
        spacing: Config.bar.spacing
        anchors.rightMargin: Config.bar.margin.right
        anchors.leftMargin: Config.bar.margin.left

        Workspaces {
            modelData: root.modelData
        }

        Item {
            Layout.fillWidth: true
        }

        Tray {}

        DateTime {}
    }
}
