pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Wayland
import "root:/Services"

Item {
    id: root
    anchors.centerIn: parent
    implicitWidth: Settings.bar.windowTitle.width

    Text {
        text: ToplevelManager.activeToplevel.title
        elide: Text.ElideMiddle

        font.hintingPreference: Font.PreferFullHinting
        font.pointSize: Settings.bar.font.size
        color: Settings.bar.font.color

        width: root.implicitWidth
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
    }
}
