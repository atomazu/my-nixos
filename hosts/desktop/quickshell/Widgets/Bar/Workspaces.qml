pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Hyprland
import "../../Services"

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

            visible: root.modelData.name == modelData.monitor.name
            implicitHeight: Settings.bar.workspaces.height
            implicitWidth: modelData.focused ? Settings.bar.workspaces.width.active : Settings.bar.workspaces.width.inactive
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

                color: Settings.bar.workspaces.font.color
                font.family: Settings.bar.workspaces.font.family
                font.hintingPreference: Font.PreferFullHinting
                font.pointSize: Settings.bar.workspaces.font.size
                bottomPadding: Settings.bar.workspaces.font.padding
            }
        }
    }
}
