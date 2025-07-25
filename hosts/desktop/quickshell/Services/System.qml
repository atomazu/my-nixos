pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell

Singleton {
    property SystemClock clock: SystemClock {
        id: systemClock
        precision: SystemClock.Minutes
    }
}
