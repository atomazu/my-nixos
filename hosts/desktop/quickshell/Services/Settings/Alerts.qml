pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Io

JsonObject {
    id: root
    required property JsonObject bar
    required property JsonObject theme

    property JsonObject position: JsonObject {
        property string vertical: root.bar.position
        property string horizontal: "right"
    }

    property JsonObject font: root.theme.font
    property string color: root.theme.color01
    property string hoverColor: root.theme.color02

    property int timeout: 5000
    property int width: 400
    property int height: 300
    property int radius: 15
    property int margin: 15
    property int spacing: 15
    property int padding: 15

    property JsonObject animation: JsonObject {
        property int duration: 250
        property JsonObject hover: JsonObject {
            property int duration: 100
        }
    }

    property JsonObject shadow: JsonObject {
        property bool enabled: true
    }
}
