pragma ComponentBehavior: Bound

import qs.Services
import Quickshell.Wayland
import QtQuick

Item {
    id: root
    anchors.centerIn: parent
    implicitWidth: Config.bar.windowTitle.width

    Text {
        text: ToplevelManager.activeToplevel.title
        elide: Text.ElideMiddle

        font.hintingPreference: Font.PreferFullHinting
        font.pointSize: Config.bar.font.size
        color: Config.bar.font.color

        width: root.implicitWidth
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
    }
}
