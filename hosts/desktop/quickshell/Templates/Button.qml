pragma ComponentBehavior: Bound

import qs.Services
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    property string text: "Button"
    property bool enabled: true
    signal clicked
    signal entered
    signal exited

    readonly property var cfg: Settings.templates.button
    readonly property var _hoverState: mouseArea.containsMouse ? cfg.hover : cfg.normal
    property var state: root.enabled ? _hoverState : cfg.disabled

    color: state.color
    radius: state.layout.radius / 2
    implicitHeight: label.implicitHeight + (state.layout.padding * 1.5)
    Layout.fillWidth: true
    Layout.topMargin: state.layout.spacing / 2

    Behavior on color {
        ColorAnimation {
            duration: root.state.animation.hover.duration
            easing.type: Easing.InOutQuad
        }
    }

    Label {
        id: label
        text: root.text
        anchors.centerIn: parent
        elide: Text.ElideRight

        font.pointSize: root.state.font.size
        font.family: root.state.font.family
        color: root.state.font.color

        Behavior on color {
            ColorAnimation {
                duration: root.state.animation.hover.duration
                easing.type: Easing.InOutQuad
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        enabled: root.enabled
        cursorShape: root.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

        onClicked: root.clicked()
        onEntered: root.entered()
        onExited: root.exited()
    }
}
