//@pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import QtQuick

MouseArea {
    id: root

    required property SystemTrayItem modelData

    acceptedButtons: Qt.LeftButton | Qt.RightButton
    implicitWidth: 16
    implicitHeight: 16

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

    IconImage {
        id: icon

        source: root.modelData.icon
        anchors.fill: parent
    }
}
