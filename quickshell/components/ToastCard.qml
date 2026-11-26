// ToastCard.qml
// One toast: who it is from, the title and the start of the body. It counts down its own
// lifetime (paused while the mouse is over it) and then fades out and emits finished().
// Clicking it hides the toast only; the notification stays in the store.
import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    required property var record            // a NotificationStore record
    property int lifetime: 5000             // ms on screen, not counting the time spent hovered

    signal finished()                       // fully faded out: remove it from the list

    // The live Notification: an app can replace one in place, so read the text from it and
    // not from the copies in the record.
    readonly property var notification: record.notification
    readonly property var entry: DesktopEntries.heuristicLookup(record.key)
    readonly property string appName: record.appName || entry?.name || record.key

    // 1. a custom icon from icons/ (by app key, then by app name), the same files the navigation
    //    bar uses, 2. the notification's own image, 3. its icon, 4. the app's desktop-entry icon.
    readonly property string iconSource: {
        const custom = CustomIcons.lookup(record.key) || CustomIcons.lookup(record.appName)
        if (custom !== "")
            return custom
        const n = notification
        if (n.image !== "")
            return n.image
        if (n.appIcon !== "") {
            if (n.appIcon.startsWith("/"))
                return "file://" + n.appIcon
            const found = Quickshell.iconPath(n.appIcon, true)      // "" when the theme lacks it
            if (found !== "")
                return found
        }
        const name = entry?.icon || record.key                  // `||`: an empty string counts as missing too
        return Quickshell.iconPath(name !== "" ? name : "dialog-information", "dialog-information")
    }

    property real remaining: 1              // 1 -> 0 over the lifetime
    property bool shown: false
    property bool closing: false

    function close() {
        if (closing)
            return
        closing = true
        removeTimer.start()
    }

    implicitHeight: content.implicitHeight + 2 * content.anchors.margins
    radius: 10
    color: Theme.surface
    border.width: 1
    border.color: Theme.border

    opacity: shown && !closing ? 0.6 : 0
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
        target: root.notification
        function onClosed() { root.close() }                // the app closed it
        function onSummaryChanged() { life.restart() }      // the app replaced it: show it again
        function onBodyChanged() { life.restart() }
    }

    RowLayout {
        id: content
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        IconImage {
            Layout.alignment: Qt.AlignTop
            implicitSize: 36
            source: root.iconSource
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            Text {
                Layout.fillWidth: true
                text: root.appName
                color: Theme.fgDark
                font.family: Theme.font
                font.pixelSize: 11
                elide: Text.ElideRight
            }
            Text {
                Layout.fillWidth: true
                text: root.notification.summary
                color: Theme.fg
                font.family: Theme.font
                font.pixelSize: 13
                font.bold: true
                elide: Text.ElideRight
            }
            Text {
                Layout.fillWidth: true
                visible: text !== ""
                text: root.notification.body
                textFormat: Text.PlainText
                color: Theme.fgDark
                font.family: Theme.font
                font.pixelSize: 12
                wrapMode: Text.Wrap
                maximumLineCount: 3
                elide: Text.ElideRight
            }
        }
    }

    // Time left, as a thin line along the bottom edge.
    Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: root.radius
        height: 2
        width: (parent.width - 2 * root.radius) * root.remaining
        color: Theme.accent
        opacity: 0.6
    }
}
