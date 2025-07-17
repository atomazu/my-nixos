//@ pragma UseQApplication

import Quickshell
import QtQuick
import "./Widgets"

Scope {
    id: root

    Variants {
        model: Quickshell.screens

        Bar {}
    }
}
