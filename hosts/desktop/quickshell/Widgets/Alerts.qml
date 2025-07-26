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
            model: Notifications.list

            Item {
                id: item
                required property var modelData
                implicitWidth: area.implicitWidth
                implicitHeight: modelData.expired ? 0 : area.implicitHeight
                visible: modelData.popup

                Behavior on implicitHeight {
                    NumberAnimation {
                        duration: 250
                        easing.type: Easing.Bezier
                    }
                }

                Component.onCompleted: {
                    if (!item.modelData.expired) {
                        if (item.modelData.seen) {
                            notification.opacity = 1;
                        } else {
                            item.modelData.seen = true;
                            enterAnim.start();
                        }
                    }
                }

                PropertyAnimation {
                    id: enterAnim
                    target: notification
                    property: "opacity"
                    to: 1
                    duration: 250
                    easing.type: Easing.OutCubic
                }

                Connections {
                    target: item.modelData
                    function onExpiredChanged() {
                        if (item.modelData.seen) {
                            exitAnim.start();
                            area.enabled = false;
                            area.cursorShape = Qt.ArrowCursor;
                        }
                    }
                }

                PropertyAnimation {
                    id: exitAnim
                    target: notification
                    property: "opacity"
                    to: 0
                    duration: 250
                    easing.type: Easing.OutCubic
                    onStopped: item.modelData.stow()
                }

                WrapperMouseArea {
                    id: area
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    anchors.centerIn: parent

                    onClicked: item.modelData.expired = true

                    Rectangle {
                        id: notification
                        property var hoverColor: Settings.theme.color02
                        property var sitColor: Settings.theme.color01
                        color: area.containsMouse ? hoverColor : sitColor
                        implicitHeight: 100
                        implicitWidth: 400
                        radius: 30
                        opacity: 0

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
                                text: item.modelData.summary
                            }

                            Label {
                                text: item.modelData.body
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
