pragma Singleton
pragma ComponentBehavior: Bound

import qs.Services.Config
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

            property JsonObject general: General {
                id: _general
            }

            property JsonObject theme: Theme {
                id: _theme
            }

            property JsonObject bar: Bar {
                id: _bar
                theme: _theme // qmllint disable
            }

            property JsonObject alerts: Alerts {
                id: _alerts
                theme: _theme // qmllint disable
                bar: _bar // qmllint disable
            }

            property JsonObject templates: Templates {
                id: _templates
                theme: _theme // qmllint disable
            }
        }
    }

    property var bar: _bar  // qmllint disable
    property var theme: _theme // qmllint disable
    property var alerts: _alerts // qmllint disable
    property var general: _general // qmllint disable
    property var templates: _templates // qmllint disable
}
