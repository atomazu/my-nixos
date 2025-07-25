//@ pragma UseQApplication

import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "./Widgets"
import "./Services"
import "./Templates"

Scope {
    id: root

    Variants {
        model: Quickshell.screens

        Bar {}
    }

    Alerts {}
}
