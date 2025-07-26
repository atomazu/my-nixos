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

        anchors {
            margins: Settings.alerts.margin

            property var position: Settings.alerts.position
            top: position.vertical === "top" ? parent.top : undefined
            bottom: position.vertical === "bottom" ? parent.bottom : undefined
            left: position.horizontal === "left" ? parent.left : undefined
            right: position.horizontal === "right" ? parent.right : undefined
        }

        Repeater {
            model: {
                let list = Notifications.list;
                let reverse = Settings.alerts.position.vertical === "bottom";
                return reverse ? Array.from(list).reverse() : list;
            }

            Item {
                id: item
                required property var modelData

                implicitWidth: area.implicitWidth
                implicitHeight: area.implicitHeight + Settings.alerts.spacing
                visible: modelData.popup

                Component.onCompleted: {
                    if (!item.modelData.expired) {
                        if (item.modelData.seen) {
                            rect.opacity = 1;
                        } else {
                            enterAnim.start();
                            item.modelData.seen = true;
                        }
                    }
                }

                PropertyAnimation {
                    id: enterAnim
                    target: rect
                    property: "opacity"
                    to: 1
                    duration: Settings.alerts.animation.duration
                    easing.type: Easing.OutCubic
                }

                Connections {
                    target: item.modelData
                    function onExpiredChanged() {
                        if (item.modelData.seen && item.modelData.expired) {
                            area.enabled = false;
                            area.cursorShape = Qt.ArrowCursor;
                            exitAnim.start();
                        }
                    }
                }

                ParallelAnimation {
                    id: exitAnim
                    PropertyAnimation {
                        target: rect
                        property: "opacity"
                        to: 0
                        duration: Settings.alerts.animation.duration
                        easing.type: Easing.OutCubic
                    }
                    PropertyAnimation {
                        target: item
                        property: "implicitHeight"
                        to: 0
                        duration: Settings.alerts.animation.duration
                        easing.type: Easing.OutCubic
                    }
                    onStopped: item.modelData.stow()
                }

                WrapperMouseArea {
                    id: area
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true

                    onClicked: item.modelData.expired = true

                    ClippingWrapperRectangle {
                        id: rect
                        property var hoverColor: Settings.alerts.hoverColor

                        property var overMax: layout.implicitHeight > Settings.alerts.height
                        implicitHeight: overMax ? Settings.alerts.height : undefined
                        implicitWidth: Settings.alerts.width

                        color: area.containsMouse ? hoverColor : Settings.alerts.color
                        radius: Settings.alerts.radius
                        margin: Settings.alerts.padding
                        opacity: 0

                        Behavior on color {
                            ColorAnimation {
                                duration: Settings.alerts.animation.hover.duration
                                easing.type: Easing.InOutQuad
                            }
                        }

                        ColumnLayout {
                            id: layout

                            Label {
                                id: summaryLabel
                                text: item.modelData.summary
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }

                            Label {
                                text: item.modelData.body
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                elide: Text.ElideRight
                            }
                        }
                    }
                }

                MultiEffect {
                    id: effect
                    source: area
                    anchors.fill: area
                    shadowEnabled: Settings.alerts.shadow.enabled
                }
            }
        }
    }
}
