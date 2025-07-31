pragma ComponentBehavior: Bound

import qs.Services
import QtQuick
import Quickshell.Hyprland

Row {
    id: root
    spacing: Config.bar.workspaces.spacing

    required property var modelData

    Repeater {
        id: workspace
        model: Hyprland.workspaces

        delegate: Rectangle {
            id: workspaceItem
            required property HyprlandWorkspace modelData
            property var activeWidth: Config.bar.workspaces.width.active
            property var inactiveWidth: Config.bar.workspaces.width.inactive

            implicitWidth: modelData.focused ? activeWidth : inactiveWidth
            visible: root.modelData.name == modelData.monitor.name

            implicitHeight: Config.bar.workspaces.height
            radius: Config.bar.workspaces.radius
            border.width: Config.bar.workspaces.border.width
            color: Config.bar.workspaces.color

            Behavior on implicitWidth {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }

            Text {
                text: workspaceItem.modelData.id
                anchors.centerIn: parent

                bottomPadding: Config.bar.workspaces.font.padding
                rightPadding: Config.bar.workspaces.font.padding
                color: Config.bar.workspaces.font.color
                font.family: Config.bar.workspaces.font.family
                font.pointSize: Config.bar.workspaces.font.size
            }
        }
    }
}
