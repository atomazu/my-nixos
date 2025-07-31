pragma ComponentBehavior: Bound

import qs.Services
import QtQuick
import Quickshell.Hyprland

Row {
    id: root
    spacing: Settings.bar.workspaces.spacing

    required property var modelData

    Repeater {
        id: workspace
        model: Hyprland.workspaces

        delegate: Rectangle {
            id: workspaceItem
            required property HyprlandWorkspace modelData
            property var activeWidth: Settings.bar.workspaces.width.active
            property var inactiveWidth: Settings.bar.workspaces.width.inactive

            implicitWidth: modelData.focused ? activeWidth : inactiveWidth
            visible: root.modelData.name == modelData.monitor.name

            implicitHeight: Settings.bar.workspaces.height
            radius: Settings.bar.workspaces.radius
            border.width: Settings.bar.workspaces.border.width
            color: Settings.bar.workspaces.color

            Behavior on implicitWidth {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }

            Text {
                text: workspaceItem.modelData.id
                anchors.centerIn: parent

                bottomPadding: Settings.bar.workspaces.font.padding
                rightPadding: Settings.bar.workspaces.font.padding
                color: Settings.bar.workspaces.font.color
                font.family: Settings.bar.workspaces.font.family
                font.pointSize: Settings.bar.workspaces.font.size
            }
        }
    }
}
