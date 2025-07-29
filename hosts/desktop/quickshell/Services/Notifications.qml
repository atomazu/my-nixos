pragma Singleton
pragma ComponentBehavior: Bound

import "root:/Services"

import Quickshell
import Quickshell.Services.Notifications
import QtQuick

Singleton {
    id: root

    readonly property list<Notif> list: []
    readonly property list<Notif> popups: list.filter(n => n.popup)

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

            root.list.push(notifComp.createObject(root, {
                notification: notif
            }));
        }
    }

    component Notif: QtObject {
        id: notif

        property bool popup: true
        property bool expired: false
        property bool seen: false
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
            popup = false;
        }

        function pause(): void {
            timer.running = false;
        }

        function resume(): void {
            timer.running = true;
        }

        property Timer timer: Timer {
            running: true
            interval: Settings.alerts.timeout

            onTriggered: {
                if (notif.hovered) {
                    running = true;
                } else {
                    notif.expired = true;
                }
            }
        }

        readonly property Connections conn: Connections {
            target: notif.notification.Retainable

            function onDropped(): void {
                root.list.splice(root.list.indexOf(notif), 1);
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
