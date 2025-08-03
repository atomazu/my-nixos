pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Io

JsonObject {
    id: root
    required property JsonObject theme

    property string position: "top"
    property string background: root.theme.color01
    property int height: 30
    property int spacing: 20

    property JsonObject margin: JsonObject {
        property int left: 10
        property int right: 10
    }

    property JsonObject font: root.theme.font
    property bool perScreen: true

    property JsonObject windowTitle: JsonObject {
        property int width: 500
        property bool perScreen: false
    }

    property JsonObject tray: JsonObject {
        property int spacing: 6

        property JsonObject item: JsonObject {
            property int width: 16
            property int height: 16
            property int radius: 4
            property string background: "transparent"
        }
    }

    property JsonObject datetime: JsonObject {
        property JsonObject font: root.theme.font
    }

    property JsonObject workspaces: JsonObject {
        property string color: root.theme.color0D
        property int spacing: 3
        property int height: 17
        property int radius: 100
        property bool perScreen: root.perScreen

        property JsonObject font: JsonObject {
            property int size: 8
            property int padding: 1
            property string color: root.theme.color00
            property string family: root.theme.font.family
        }

        property JsonObject width: JsonObject {
            property int inactive: 17
            property int active: 33
        }

        property JsonObject border: JsonObject {
            property int width: 0
        }
    }
}
