// Toasts.qml
// Step 3 of the notification system (see "Notifications" in the README): the small popups on
// a screen edge. NotificationStore decides whether a notification gets a toast (app setting
// and the "no popups" mode) and announces it with toastRequested; this only shows them.
//
// One overlay window on one screen. It takes no keyboard focus and only the cards take
// mouse input, so it never gets in the way.
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick

Scope {
    id: root

    property int maxVisible: 3              // the oldest toast is dropped beyond this
    property int cardWidth: 360
    property int gap: 8
    property int edgeMargin: 12
    property int barHeight: 30              // the bar reserves this much of the top edge

    // What is on screen, newest first: [{ uid, record }]. Not the stored notifications.
    property var toasts: []
    property int nextUid: 0

    Connections {
        target: NotificationStore
        function onToastRequested(record) {
            const fresh = { uid: root.nextUid++, record: record }
            root.toasts = [fresh, ...root.toasts.filter(t => t.record.id !== record.id)]
                .slice(0, root.maxVisible)
        }
    }

    function remove(uid) {
        toasts = toasts.filter(t => t.uid !== uid)
    }

    PanelWindow {
        id: window

        // Settings: toast.position is "top-right", "top-left", "bottom-right" or "bottom-left";
        // toast.monitor is "focused" or the name of an output.
        readonly property var toastSettings: NotificationStore.settings.toast
        readonly property string position: toastSettings?.position ?? "top-right"
        readonly property bool atTop: position.startsWith("top")
        readonly property bool atRight: position.endsWith("right")
        readonly property string monitorName: {
            const m = toastSettings?.monitor ?? "focused"
            return m === "focused" ? (Hyprland.focusedMonitor?.name ?? "") : m
        }

        screen: Quickshell.screens.find(s => s.name === monitorName) ?? Quickshell.screens[0]

        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "quickshell-toast"
        exclusionMode: ExclusionMode.Ignore

        anchors {
            top: window.atTop
            bottom: !window.atTop
            right: window.atRight
            left: !window.atRight
        }
        margins {
            top: window.atTop ? root.barHeight + root.edgeMargin : 0
            bottom: window.atTop ? 0 : root.edgeMargin
            right: window.atRight ? root.edgeMargin : 0
            left: window.atRight ? 0 : root.edgeMargin
        }

        implicitWidth: root.cardWidth
        implicitHeight: column.implicitHeight
        visible: root.toasts.length > 0
        color: "transparent"
        mask: Region { item: column }

        Column {
            id: column
            width: parent.width
            spacing: root.gap

            move: Transition { NumberAnimation { properties: "y"; duration: 150; easing.type: Easing.OutCubic } }

            Repeater {
                // Newest next to the edge: on top for the top corners, at the bottom otherwise.
                model: ScriptModel { values: window.atTop ? root.toasts : root.toasts.slice().reverse() }

                ToastCard {
                    required property var modelData
                    record: modelData.record
                    width: column.width
                    onFinished: root.remove(modelData.uid)
                }
            }
        }
    }
}
