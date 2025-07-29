pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Io

JsonObject {
    id: root
    required property JsonObject theme

    property JsonObject label: JsonObject {
        property JsonObject font: root.theme.font
    }

    property JsonObject button: JsonObject {
        property JsonObject normal: JsonObject {
            property string color: root.theme.color00
            property JsonObject font: root.theme.font

            property JsonObject layout: JsonObject {
                property int radius: 8
                property int spacing: 10
                property int padding: 10
            }

            property JsonObject animation: JsonObject {
                property JsonObject hover: JsonObject {
                    property int duration: 100
                }
            }
        }

        property JsonObject hover: JsonObject {
            property string color: root.theme.color01
            property JsonObject font: root.button.normal.font
            property var layout: root.button.normal.layout
            property var animation: root.button.normal.animation
        }

        property JsonObject disabled: JsonObject {
            property string color: root.theme.color02
            property JsonObject font: JsonObject {
                property int size: root.button.normal.font.size
                property string family: root.button.normal.font.family
                property string color: root.theme.color03
            }

            property var layout: root.button.normal.layout
            property var animation: root.button.normal.animation
        }
    }
}
