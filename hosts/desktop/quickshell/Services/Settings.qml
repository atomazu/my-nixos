pragma Singleton
pragma ComponentBehavior: Bound

import qs.Services.Settings
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    FileView {
        path: Quickshell.shellDir + "/settings.json"
        watchChanges: true
        onFileChanged: reload()

        JsonAdapter { // qmllint disable
            id: adapter

            property JsonObject theme: Theme {
                id: _theme
            }

            property JsonObject bar: Bar {
                id: _bar
                theme: _theme
            }

            property JsonObject alerts: Alerts {
                id: _alerts
                theme: _theme
                bar: _bar
            }

            property JsonObject templates: Templates {
                id: _templates
                theme: _theme
            }
        }
    }

    property var bar: _bar  // qmllint disable
    property var theme: _theme // qmllint disable
    property var alerts: _alerts // qmllint disable
    property var templates: _templates // qmllint disable
}
