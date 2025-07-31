//@ pragma UseQApplication

import Quickshell
import QtQuick
import qs.Widgets

Scope {
    id: root

    Variants {
        model: Quickshell.screens

        Bar {}
    }

    Alerts {}
}
