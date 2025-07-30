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
                let list = Notifications.popups;
                let reverse = Settings.alerts.position.vertical === "bottom";
                return reverse ? Array.from(list).reverse() : list;
            }

            Item {
                id: item
                required property var modelData

                implicitWidth: area.implicitWidth
                implicitHeight: area.implicitHeight

                Component.onCompleted: {
                    if (!item.modelData.expired) {
                        if (item.modelData.seen) {
                            rect.opacity = 1;
                        } else {
                            item.modelData.busy = true;
                            item.modelData.seen = true;
                            enterAnim.start();
                        }
                    }
                }

                Component.onDestruction: {
                    if (modelData.expired) {
                        modelData.stow();
                    }
                }

                PropertyAnimation {
                    id: enterAnim
                    target: rect
                    property: "opacity"
                    to: 1
                    duration: Settings.alerts.animation.duration
                    easing.type: Easing.OutCubic
                    onStopped: item.modelData.busy = false
                }

                Connections {
                    target: item.modelData
                    function onExpiredChanged() {
                        if (item.modelData.seen && item.modelData.expired) {
                            item.modelData.busy = true;
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
                    onStopped: item.destroy()
                }

                WrapperMouseArea {
                    id: area
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true

                    onClicked: item.modelData.expired = true
                    onEntered: item.modelData.pause()
                    onExited: item.modelData.resume()

                    ClippingWrapperRectangle {
                        id: rect
                        property var hoverColor: Settings.alerts.hoverColor
                        property var overMax: layout.implicitHeight > Settings.alerts.height
                        property var extraWidth: item.modelData.image != "" ? 50 : 24

                        implicitHeight: overMax ? Settings.alerts.height : undefined
                        implicitWidth: Settings.alerts.width + Settings.alerts.spacing + 50

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
                            RowLayout {
                                id: header
                                Layout.fillWidth: true
                                ClippingWrapperRectangle {
                                    radius: Settings.alerts.radius
                                    visible: iconImage.source != ""
                                    Layout.preferredWidth: 24
                                    Layout.preferredHeight: 24
                                    IconImage {
                                        id: iconImage
                                        source: Quickshell.iconPath(item.modelData.appName.toLowerCase(), true)
                                    }
                                }
                                Label {
                                    text: item.modelData.appName
                                    font.bold: true
                                    Layout.fillWidth: true
                                    font.pointSize: Settings.alerts.font.size
                                    elide: Text.ElideRight
                                }
                                Label {
                                    text: item.modelData.timeStr
                                    font.pointSize: Settings.alerts.font.size
                                    opacity: 0.7
                                }
                            }

                            RowLayout {
                                id: content
                                spacing: Settings.alerts.padding

                                ColumnLayout {
                                    id: image
                                    visible: item.modelData.image != ""
                                    spacing: Settings.alerts.spacing

                                    ClippingWrapperRectangle {
                                        Layout.preferredWidth: 100
                                        Layout.preferredHeight: 100
                                        radius: Settings.alerts.radius

                                        Image {
                                            source: item.modelData.image
                                            anchors.fill: parent
                                            fillMode: Image.PreserveAspectCrop
                                        }
                                    }
                                }

                                ColumnLayout {
                                    id: full
                                    visible: item.modelData.image != ""
                                    Label {
                                        text: item.modelData.summary
                                        elide: Text.ElideRight
                                        Layout.fillWidth: true
                                        font.bold: true
                                        font.pointSize: Settings.alerts.font.size
                                    }
                                    Label {
                                        text: item.modelData.body
                                        wrapMode: Text.WordWrap
                                        Layout.fillWidth: true
                                        elide: Text.ElideRight
                                        font.pointSize: Settings.alerts.font.size
                                        linkColor: Settings.theme.color0D
                                    }
                                }

                                RowLayout {
                                    id: compact
                                    visible: item.modelData.image == ""
                                    Label {
                                        text: item.modelData.summary + ": "
                                        elide: Text.ElideRight
                                        font.bold: true
                                        font.pointSize: Settings.alerts.font.size
                                    }
                                    Label {
                                        text: item.modelData.body
                                        wrapMode: Text.WordWrap
                                        elide: Text.ElideRight
                                        font.pointSize: Settings.alerts.font.size
                                        linkColor: Settings.theme.color0D
                                    }
                                }
                            }

                            ColumnLayout {
                                id: actionsColumn
                                Layout.fillWidth: true
                                Layout.topMargin: item.modelData.actions.length > 0 ? Settings.alerts.spacing : 0

                                Repeater {
                                    model: item.modelData.actions

                                    delegate: Button {
                                        text: modelData.text
                                        onClicked: modelData.invoke()
                                    }
                                }
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
