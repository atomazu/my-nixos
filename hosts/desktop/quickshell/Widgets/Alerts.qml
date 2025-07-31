//@ pragma UseQApplication

import qs.Services
import qs.Templates

import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

PanelWindow { // qmllint disable
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
            top: position.vertical === "top" ? parent.top : undefined // qmllint disable
            bottom: position.vertical === "bottom" ? parent.bottom : undefined // qmllint disable
            left: position.horizontal === "left" ? parent.left : undefined // qmllint disable
            right: position.horizontal === "right" ? parent.right : undefined // qmllint disable
        }

        Repeater {
            model: Notifications.popups

            Item {
                id: item
                required property var modelData

                implicitWidth: area.implicitWidth
                implicitHeight: area.implicitHeight
                Layout.bottomMargin: Settings.alerts.margin / 2

                Behavior on Layout.bottomMargin {
                    NumberAnimation {
                        duration: Settings.alerts.animation.duration
                        easing.type: Easing.InOutCubic
                    }
                }

                Component.onCompleted: {
                    if (!item.modelData.expired) {
                        if (item.modelData.seen) {
                            rect.opacity = 1;
                        } else {
                            item.modelData.seen = true;
                            item.modelData.busy = true;
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
                    easing.type: Easing.InOutCubic
                    onStopped: item.modelData.busy = false
                }

                Connections {
                    target: item.modelData
                    function onExpiredChanged() {
                        if (item.modelData.seen && item.modelData.expired) {
                            item.Layout.bottomMargin = 0;
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
                        easing.type: Easing.InOutCubic
                    }
                    PropertyAnimation {
                        target: item
                        property: "implicitHeight"
                        to: 0
                        duration: Settings.alerts.animation.duration
                        easing.type: Easing.InOutCubic
                    }
                    onStopped: {
                        item.visible = false;
                        item.modelData.busy = false;
                    }
                }

                WrapperMouseArea {
                    id: area
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true

                    onClicked: item.modelData.expired = true
                    onEntered: item.modelData.hovering = true
                    onExited: item.modelData.hovering = false

                    ClippingWrapperRectangle {
                        id: rect
                        property var hoverColor: Settings.alerts.hoverColor
                        property var overMax: layout.implicitHeight > Settings.alerts.height

                        implicitHeight: overMax ? Settings.alerts.height : undefined
                        implicitWidth: Settings.alerts.width + Settings.alerts.spacing

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

                                Label {
                                    textFormat: Text.RichText
                                    elide: Text.ElideRight
                                    font.pointSize: Settings.alerts.font.size
                                    linkColor: Settings.theme.color0D
                                    wrapMode: Text.WordWrap
                                    Layout.fillWidth: true

                                    property string imageString: item.modelData.image != "" ? "<br>" : " "
                                    text: `<b>${item.modelData.summary}:</b>${imageString}${item.modelData.body}`
                                }
                            }

                            ColumnLayout {
                                id: actionsColumn
                                visible: item.modelData.actions.length > 0
                                Layout.fillWidth: true

                                Repeater {
                                    model: item.modelData.actions

                                    delegate: Button {
                                        required property var modelData
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
