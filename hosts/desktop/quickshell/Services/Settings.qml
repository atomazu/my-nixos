pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    FileView {
        path: Quickshell.configDir + "/settings.json"
        watchChanges: true
        onFileChanged: reload()

        JsonAdapter { // qmllint disable
            id: jsonAdapter

            property JsonObject theme: JsonObject {
                id: _theme

                property string color00: "#1d1f21" // Background
                property string color01: "#282a2e" // BackgroundLighter
                property string color02: "#373b41" // Selection
                property string color03: "#969896" // Comment
                property string color04: "#b4b7b4" // ForegroundMuted
                property string color05: "#c5c8c6" // Foreground
                property string color06: "#e0e0e0" // ForegroundEmphasized
                property string color07: "#ffffff" // ForegroundBright
                property string color08: "#cc6666" // Red
                property string color09: "#de935f" // Orange
                property string color0A: "#f0c674" // Yellow
                property string color0B: "#b5bd68" // Green
                property string color0C: "#8abeb7" // Cyan
                property string color0D: "#81a2be" // Blue
                property string color0E: "#b294bb" // Magenta
                property string color0F: "#a3685a" // Brown

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
        }
    }

    property var bar: _bar  // qmllint disable
    property var theme: _theme // qmllint disable
}
