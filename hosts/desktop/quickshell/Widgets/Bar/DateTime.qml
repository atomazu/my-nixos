pragma ComponentBehavior: Bound

import QtQuick
import "root:/Services"

Text {
    text: Qt.formatDateTime(System.clock.date, "ddd d MMM HH:mm")
    font.pointSize: Settings.bar.datetime.font.size
    color: Settings.bar.datetime.font.color
}
