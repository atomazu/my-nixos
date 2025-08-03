//@ pragma UseQApplication
pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import qs.Widgets
import qs.Services

Scope {
    id: root

    property var singleScreen: Quickshell.screens.filter(screen => //
        screen.name == Config.general.defaultScreen)

    Variants {
        model: Config.alerts.perScreen ? Quickshell.screens : root.singleScreen
        Alerts {}
    }

    Variants {
        model: Config.bar.perScreen ? Quickshell.screens : root.singleScreen
        Bar {}
    }
}
