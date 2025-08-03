pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Io
import Quickshell.Hyprland

JsonObject {
    id: root

    property string defaultScreen: Hyprland.monitors.values[0].name
}
