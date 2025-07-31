pragma ComponentBehavior: Bound

import qs.Services
import QtQuick

Text {
    text: Qt.formatDateTime(System.clock.date, "ddd d MMM HH:mm")
    font.pointSize: Settings.bar.datetime.font.size
    color: Settings.bar.datetime.font.color
}
