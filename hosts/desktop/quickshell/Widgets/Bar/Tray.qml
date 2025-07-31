pragma ComponentBehavior: Bound

import qs.Services
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import QtQuick

Row {
    spacing: Settings.bar.tray.spacing
    Repeater {
        model: SystemTray.items
        delegate: MouseArea {
            id: root

            required property SystemTrayItem modelData

            acceptedButtons: Qt.LeftButton | Qt.RightButton
            implicitWidth: Settings.bar.tray.item.width
            implicitHeight: Settings.bar.tray.item.height

            onClicked: event => {
                if (event.button === Qt.LeftButton)
                    modelData.activate();
                else if (modelData.hasMenu)
                    menu.open();
            }

            QsMenuAnchor {
                id: menu
                menu: root.modelData.menu // qmllint disable

                anchor {
                    item: icon
                    adjustment: PopupAdjustment.FlipX // qmllint disable
                    edges: Edges.Bottom | Edges.Left // qmllint disable
                    rect {
                        w: icon.width
                        h: icon.height + 4
                    }
                }
            }

            ClippingRectangle {
                anchors.fill: parent
                color: Settings.bar.tray.item.background
                radius: Settings.bar.tray.item.radius

                IconImage {
                    id: icon

                    source: root.modelData.icon
                    anchors.fill: parent
                }
            }
        }
    }
}
