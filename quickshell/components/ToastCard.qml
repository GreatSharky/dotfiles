// ToastCard.qml
// One toast: who it is from, the title and the start of the body. It counts down its own
// lifetime (paused while the mouse is over it) and then fades out and emits finished().
// Clicking it hides the toast only; the notification stays in the store.
import QtQuick

NotificationCard {
    id: root

    property int lifetime: 5000             // ms on screen, not counting the time spent hovered

    signal finished()                       // fully faded out: remove it from the list

    property real remaining: 1              // 1 -> 0 over the lifetime
    property bool shown: false
    property bool closing: false

    function close() {
        if (closing)
            return
        closing = true
        removeTimer.start()
    }

    opacity: shown && !closing ? 0.7 : 0
    Behavior on opacity { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
    Component.onCompleted: shown = true

    Timer { id: removeTimer; interval: 170; onTriggered: root.finished() }

    // The lifetime is an animation so it can be paused and then continue where it was.
    NumberAnimation on remaining {
        id: life
        from: 1
        to: 0
        duration: root.lifetime
        running: !root.closing
        paused: hover.hovered
        onFinished: root.close()
    }

    HoverHandler { id: hover }
    TapHandler { onTapped: root.close() }

    Connections {
        target: root.record.notification
        function onClosed() { root.close() }                // the app closed it
        function onSummaryChanged() { life.restart() }      // the app replaced it: show it again
        function onBodyChanged() { life.restart() }
    }

    // Time left, as a thin line along the bottom edge.
    Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: root.radius
        height: 2
        width: (parent.width - 2 * root.radius) * root.remaining
        color: Theme.accent
        opacity: 1
    }
}
