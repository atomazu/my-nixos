//@ pragma UseQApplication

import "root:/Widgets"
import "root:/Services"
import "root:/Templates"

import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

PanelWindow {
    id: window
    color: "transparent"
    exclusiveZone: 0

    mask: Region {
        item: column
    }

    anchors {
        top: true
        right: true
        bottom: true
        left: true
    }

    ColumnLayout {
        id: column
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 15
        spacing: 15

        Repeater {
            model: Notifications.popups

            Item {
                id: nroot
                required property var modelData
                implicitWidth: area.implicitWidth
                implicitHeight: area.implicitHeight

                WrapperMouseArea {
                    id: area
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    anchors.centerIn: parent

                    onClicked: nroot.modelData.popup = false

                    Rectangle {
                        id: notification
                        property var hoverColor: Settings.theme.color02
                        property var sitColor: Settings.theme.color01
                        color: area.containsMouse ? hoverColor : sitColor
                        implicitHeight: 100
                        implicitWidth: 400
                        radius: 30

                        Behavior on color {
                            ColorAnimation {
                                duration: 100
                                easing.type: Easing.InOutQuad
                            }
                        }

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 20
                            anchors.topMargin: 10
                            anchors.bottomMargin: 10

                            Label {
                                text: nroot.modelData.summary
                            }

                            Label {
                                text: nroot.modelData.body
                                wrapMode: Text.WordWrap
                                Layout.preferredWidth: notification.width - 20
                            }
                        }
                    }
                }

                MultiEffect {
                    id: effect
                    source: area
                    anchors.fill: area
                    shadowEnabled: true
                }
            }
        }
    }
}
