pragma ComponentBehavior: Bound

import QtQuick
import "root:/Services"

Text {
    font.pointSize: Settings.theme.font.size
    font.family: Settings.theme.font.family
    color: Settings.theme.font.color
}
