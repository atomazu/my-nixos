pragma ComponentBehavior: Bound

import qs.Services
import QtQuick

Text {
    text: Qt.formatDateTime(System.clock.date, "ddd d MMM HH:mm")
    font.pointSize: Config.bar.datetime.font.size
    color: Config.bar.datetime.font.color
}
