pragma Singleton
pragma ComponentBehavior: Bound

import qs.Services
import Quickshell
import Quickshell.Services.Notifications
import QtQuick

Singleton {
    id: root

    readonly property list<Notif> stowed: []
    readonly property list<Notif> popups: []
    readonly property list<Notif> queue: []

    property int busyCount: 0
    onBusyCountChanged: Qt.callLater(process)

    NotificationServer {
        id: server

        keepOnReload: false
        actionsSupported: true
        bodyHyperlinksSupported: true
        bodyImagesSupported: true
        bodyMarkupSupported: true
        imageSupported: true

        onNotification: notif => {
            notif.tracked = true;

            const newNotif = notifComp.createObject(root, {
                notification: notif
            });

            root.queue.push(newNotif);
            Qt.callLater(root.process);
        }
    }

    function process(): void {
        if (root.busyCount === 0 && root.queue.length > 0) {
            const notifToMove = root.queue.shift();
            if (Config.alerts.position.vertical === "bottom") {
                root.popups.unshift(notifToMove);
            } else {
                root.popups.push(notifToMove);
            }
        }
    }

    component Notif: QtObject {
        id: notif

        property string screen: ""
        property bool expired: false
        property bool seen: false
        property bool busy: false
        property bool hovering: false

        readonly property date time: new Date()
        readonly property string timeStr: {
            const diff = System.clock.date.getTime() - time.getTime();
            const m = Math.floor(diff / 60000);
            const h = Math.floor(m / 60);

            if (h < 1 && m < 1)
                return "now";
            if (h < 1)
                return `${m}m`;
            return `${h}h`;
        }

        required property Notification notification
        readonly property string summary: notification.summary
        readonly property string body: notification.body
        readonly property string appIcon: notification.appIcon
        readonly property string appName: notification.appName
        readonly property string image: notification.image
        readonly property int urgency: notification.urgency
        readonly property list<NotificationAction> actions: notification.actions

        function stow(): void {
            const popupsIndex = root.popups.indexOf(notif);
            const queueIndex = root.queue.indexOf(notif);

            if (popupsIndex !== -1) {
                root.popups.splice(popupsIndex, 1);
            } else if (queueIndex !== -1) {
                root.queue.splice(queueIndex, 1);
            }

            root.stowed.push(notif);
        }

        onHoveringChanged: timer.running = !hovering
        onBusyChanged: {
            if (busy) {
                root.busyCount++;
            } else {
                root.busyCount--;
            }
        }

        property Timer timer: Timer {
            running: true
            interval: Config.alerts.timeout
            onTriggered: notif.expired = true
        }

        readonly property Connections conn: Connections {
            target: notif.notification.Retainable

            function onDropped(): void {
                const popupsIndex = root.popups.indexOf(notif);
                const queueIndex = root.queue.indexOf(notif);
                const stowedIndex = root.stowed.indexOf(notif);

                if (popupsIndex !== -1) {
                    root.popups.splice(popupsIndex, 1);
                } else if (queueIndex !== -1) {
                    root.queue.splice(queueIndex, 1);
                } else if (stowedIndex !== -1) {
                    root.stowed.splice(stowedIndex, 1);
                }
            }

            function onAboutToDestroy(): void {
                notif.destroy();
            }
        }
    }

    Component {
        id: notifComp
        Notif {}
    }
}
