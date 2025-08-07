pragma ComponentBehavior: Bound

import qs.Services
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Effects

Row {
    spacing: Config.bar.tray.spacing
    Repeater {
        model: SystemTray.items
        delegate: MouseArea {
            id: root

            required property SystemTrayItem modelData

            acceptedButtons: Qt.LeftButton | Qt.RightButton
            implicitWidth: Config.bar.tray.item.width
            implicitHeight: Config.bar.tray.item.height

            onClicked: event => {
                if (event.button === Qt.LeftButton)
                    modelData.activate();
                else if (event.button === Qt.RightButton && modelData.hasMenu)
                    menu.open();
            }

            QsMenuAnchor {
                id: menu
                menu: root.modelData.menu // qmllint disable

                anchor {
                    item: iconContainer
                    adjustment: PopupAdjustment.FlipX | PopupAdjustment.FlipY // qmllint disable
                    edges: Edges.Bottom | Edges.Left // qmllint disable
                    rect {
                        w: iconContainer.width
                        h: iconContainer.height + 4
                    }
                }
            }

            ClippingRectangle {
                anchors.fill: parent
                color: Config.bar.tray.item.background
                radius: Config.bar.tray.item.radius

                Item {
                    id: iconContainer
                    anchors.fill: parent

                    IconImage {
                        id: icon
                        source: root.modelData.icon
                        anchors.fill: parent
                        visible: !brightnessEffect.visible
                    }

                    MultiEffect {
                        id: brightnessEffect
                        source: icon
                        anchors.fill: icon
                        visible: root.modelData.icon.toString().includes("symbolic")
                        brightness: 0.67
                    }
                }
            }
        }
    }
}
