pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import "../../Services"

Text {
    text: Qt.formatDateTime(clock.date, "ddd d MMM HH:mm")
    font.pointSize: Settings.bar.datetime.font.size
    color: Settings.bar.datetime.font.color

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}
