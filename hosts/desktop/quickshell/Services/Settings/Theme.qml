pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Io

JsonObject {
    id: root

    property string color00: "#1d1f21"
    property string color01: "#282a2e"
    property string color02: "#373b41"
    property string color03: "#969896"
    property string color04: "#b4b7b4"
    property string color05: "#c5c8c6"
    property string color06: "#e0e0e0"
    property string color07: "#ffffff"

    property string color08: "#cc6666"
    property string color09: "#de935f"
    property string color0A: "#f0c674"
    property string color0B: "#b5bd68"
    property string color0C: "#8abeb7"
    property string color0D: "#81a2be"
    property string color0E: "#b294bb"
    property string color0F: "#a3685a"

    property string red: color08
    property string orange: color09
    property string yellow: color0A
    property string green: color0B
    property string cyan: color0C
    property string blue: color0D
    property string magenta: color0E
    property string brown: color0F

    property JsonObject font: JsonObject {
        property int size: 12
        property string family: "Noto Sans CJK JP"
        property string color: root.color07
    }
}
