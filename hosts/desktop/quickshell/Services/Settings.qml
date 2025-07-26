pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    FileView {
        path: Quickshell.shellDir + "/settings.json"
        watchChanges: true
        onFileChanged: reload()

        JsonAdapter { // qmllint disable
            id: jsonAdapter

            property JsonObject theme: JsonObject {
                id: _theme

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
                    id: _theme_font

                    property int size: 12
                    property string family: "Noto Sans CJK JP"
                    property string color: _theme.color07
                }
            }

            property JsonObject bar: JsonObject {
                id: _bar

                property string position: "top"
                property string background: _theme.color00
                property int height: 30
                property int spacing: 20

                property JsonObject margin: JsonObject {
                    property int left: 10
                    property int right: 10
                }

                property JsonObject font: _theme_font

                property JsonObject windowTitle: JsonObject {
                    property int width: 500
                }

                property JsonObject tray: JsonObject {
                    id: _bar_tray

                    property int spacing: 6

                    property JsonObject item: JsonObject {
                        property int width: 16
                        property int height: 16
                        property int radius: 4
                        property string background: "transparent"
                    }
                }

                property JsonObject datetime: JsonObject {
                    property JsonObject font: _theme_font
                }

                property JsonObject workspaces: JsonObject {
                    id: _theme_bar_workspaces

                    property string color: _theme.color0D
                    property int spacing: 3
                    property int height: 17
                    property int radius: 100

                    property JsonObject font: JsonObject {
                        id: _bar_workspaces_font

                        property int size: 8
                        property int padding: 2
                        property string color: _theme.color00
                        property string family: _theme_font.family
                    }

                    property JsonObject width: JsonObject {
                        id: _bar_workspaces_width

                        property int inactive: 17
                        property int active: 33
                    }

                    property JsonObject border: JsonObject {
                        id: _bar_workspaces_border

                        property int width: 0
                    }
                }
            }

            property JsonObject alerts: JsonObject {
                id: _alerts

                property JsonObject position: JsonObject {
                    property string vertical: _bar.position
                    property string horizontal: "right"
                }

                property string color: _theme.color01
                property string hoverColor: _theme.color02

                property int width: 400
                property int height: 300
                property int radius: 10
                property int margin: 10
                property int spacing: 10
                property int padding: 10

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
        }
    }

    property var bar: _bar  // qmllint disable
    property var theme: _theme // qmllint disable
    property var alerts: _alerts // qmllint disable
}
