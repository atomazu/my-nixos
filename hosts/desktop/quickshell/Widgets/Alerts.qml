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
        spacing: Settings.notifications.spacing

        anchors {
            property var position: Settings.notifications.position
            top: position.vertical === "top" ? parent.top : undefined
            bottom: position.vertical === "bottom" ? parent.bottom : undefined
            left: position.horizontal === "left" ? parent.left : undefined
            right: position.horizontal === "right" ? parent.right : undefined

            // This margin will apply to the active anchors
            margins: Settings.notifications.margin
        }

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
                        duration: Settings.notifications.animation.duration
                        easing.type: Easing.Bezier
                    }
                }

                Component.onCompleted: {
                    if (!item.modelData.expired) {
                        if (item.modelData.seen) {
                            rect.opacity = 1;
                        } else {
                            item.modelData.seen = true;
                            enterAnim.start();
                        }
                    }
                }

                PropertyAnimation {
                    id: enterAnim
                    target: rect
                    property: "opacity"
                    to: 1
                    duration: Settings.notifications.animation.duration
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
                    target: rect
                    property: "opacity"
                    to: 0
                    duration: Settings.notifications.animation.duration
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
                        id: rect
                        property var hoverColor: Settings.notifications.hoverColor
                        color: area.containsMouse ? hoverColor : Settings.notifications.color
                        implicitHeight: Settings.notifications.height
                        implicitWidth: Settings.notifications.width
                        radius: Settings.notifications.radius
                        opacity: 0

                        Behavior on color {
                            ColorAnimation {
                                duration: Settings.notifications.animation.hover.duration
                                easing.type: Easing.InOutQuad
                            }
                        }

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.leftMargin: Settings.notifications.padding.horizontal
                            anchors.rightMargin: Settings.notifications.padding.horizontal
                            anchors.topMargin: Settings.notifications.padding.vertical
                            anchors.bottomMargin: Settings.notifications.padding.vertical

                            Label {
                                text: item.modelData.summary
                            }

                            Label {
                                text: item.modelData.body
                                wrapMode: Text.WordWrap
                                property var marginSum: Settings.notifications.padding.horizontal * 2
                                Layout.preferredWidth: rect.width - marginSum
                            }
                        }
                    }
                }

                MultiEffect {
                    id: effect
                    source: area
                    anchors.fill: area
                    shadowEnabled: Settings.notifications.shadow.enabled
                }
            }
        }
    }
}
