//@ pragma UseQApplication

import Quickshell
import QtQuick

Scope {
    id: root

    Variants {
        model: Quickshell.screens

        Bar {}
    }
}
