pragma ComponentBehavior: Bound

import qs.Services
import Quickshell.Hyprland
import QtQuick

Item {
    id: root
    anchors.centerIn: parent
    implicitWidth: Config.bar.windowTitle.width
    required property var modelData

    Text {
        property var toplevel: Hyprland.activeToplevel
        property string perScreenTitle: ""
        property string title: toplevel?.title || ""

        text: Config.bar.windowTitle.perScreen ? perScreenTitle : title
        elide: Text.ElideMiddle

        onToplevelChanged: {
            if (Hyprland.focusedMonitor == Hyprland.monitorFor(root.modelData)) {
                if (!toplevel) {
                    perScreenTitle = "";
                } else {
                    perScreenTitle = toplevel.title || "";
                }
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
