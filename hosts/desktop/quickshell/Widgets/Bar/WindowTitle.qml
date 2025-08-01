pragma ComponentBehavior: Bound

import qs.Services
import Quickshell.Wayland
import QtQuick

Item {
    id: root
    anchors.centerIn: parent
    implicitWidth: Config.bar.windowTitle.width
    required property var modelData

    Text {
        property var toplevel: ToplevelManager.activeToplevel
        property string perScreenTitle: "None"

        text: Config.bar.windowTitle.perScreen ? perScreenTitle : toplevel.title
        elide: Text.ElideMiddle

        onToplevelChanged: {
            if (toplevel.screens[0].name == root.modelData.name) {
                perScreenTitle = toplevel.title;
            }
        }

        font.hintingPreference: Font.PreferFullHinting
        font.pointSize: Config.bar.font.size
        color: Config.bar.font.color

        width: root.implicitWidth
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
    }
}
