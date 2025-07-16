//@pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Services.SystemTray

PanelWindow { //qmllint disable
    id: root
    required property var modelData
    screen: modelData

    color: "#1d1f21"

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 25

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    RowLayout {
        anchors.fill: parent
        spacing: 20
        anchors.rightMargin: 8
        anchors.leftMargin: 8

        Row {
            spacing: 3
            Repeater {
                id: workspace
                model: Hyprland.workspaces

                delegate: Rectangle {
                    id: workspaceItem
                    required property HyprlandWorkspace modelData

                    visible: root.modelData.name == modelData.monitor.name
                    implicitHeight: 17
                    implicitWidth: modelData.focused ? 33 : 17
                    radius: 100
                    border.width: 0
                    color: "#81a2be"

                    Behavior on implicitWidth {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.OutCubic
                        }
                    }

                    Text {
                        color: "black"
                        text: workspaceItem.modelData.id
                        anchors.centerIn: parent
                        font.hintingPreference: Font.PreferFullHinting
                        font.pointSize: 7
                    }
                }
            }
        }

        Text {
            text: ToplevelManager.activeToplevel.title
            elide: Text.ElideRight
            font.hintingPreference: Font.PreferFullHinting
            font.pointSize: 10
            color: "white"
        }

        Item {
            Layout.fillWidth: true
        }

        Row {
            spacing: 3
            Repeater {
                model: SystemTray.items
                delegate: TrayItem {}
            }
        }

        Text {
            text: Qt.formatDateTime(clock.date, "ddd d MMM HH:mm")
            font.pointSize: 10
            color: "white"
        }
    }
}
