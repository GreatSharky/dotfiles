// NotificationStore.qml
// The shared state of the notification system: the records, the persisted settings and the
// rules (see "Notifications" in the README). The server feeds it with receive(); the toast,
// panel and bell only read from it.
//
// Not connected yet: nothing instantiates this singleton, so it does nothing until
// Notifications.qml calls NotificationStore.receive(n).
pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    // ---------------------------------------------------------------- records
    // Newest first. A record is a plain object (the server's Notification is read-only, so
    // things like `read` live here): { id, key, appName, summary, body, urgency, time, read, notification }
    property var items: []

    readonly property int unreadCount:
        items.filter(r => !r.read && effectsFor(r).indicator).length
    readonly property var panelItems:
        items.filter(r => effectsFor(r).panel)

    // One-shot effects are signals: they fire once, when the notification arrives.
    // State effects (panel, indicator) are bindings over `items` and the settings.
    signal soundRequested(var record)
    signal toastRequested(var record)

    // --------------------------------------------------------------- settings
    // Plain QML state, saved as JSON so modes and per-app choices survive a restart.
    // (JsonAdapter was tried first: its writes only show up on the next event-loop turn, so
    // two changes in a row lose one. Plain properties have no such surprise.)
    readonly property var quietDefaults: ({ sound: false, toast: false, panel: true, indicator: true })
    property var settings: ({
        modes: { noSound: false, noPopups: false, noIndicators: false },
        toast: { position: "top-right", monitor: "focused" },
        apps: {}                                    // appKey -> { sound, toast, panel, indicator }
    })

    FileView {
        id: file
        path: Quickshell.statePath("notifications.json")
        watchChanges: false
        printErrors: false
        blockLoading: true                          // text() below waits until the file is read
    }

    // Read once, right when the store is created, so the settings are in place before any
    // notification (for example one re-delivered after a reload) can reach receive().
    Component.onCompleted: {
        const text = file.text()
        if (text === "") {                          // no file yet (first run): write the defaults
            save()
            return
        }
        try { settings = Object.assign({}, settings, JSON.parse(text)) }
        catch (e) { console.warn("notifications.json is not valid JSON, using defaults:", e) }
    }

    // Saves are debounced, so a burst of changes becomes one write.
    Timer { id: saveTimer; interval: 200; onTriggered: file.setText(JSON.stringify(root.settings, null, 2)) }
    function save() { saveTimer.restart() }

    function change(patch) {                        // patch: part of the settings to replace
        settings = Object.assign({}, settings, patch)
        save()
    }

    // ------------------------------------------------------------------ rules
    // The desktop entry, else the app name, else "unknown" (some apps send neither).
    function appKeyOf(n) {
        return n.desktopEntry || n.appName || "unknown"
    }

    // Which styles may fire for a record: the app's flags AND no global mode blocking.
    // Urgency is deliberately not looked at: nothing bypasses the filters.
    function effectsFor(record) {
        const a = settings.apps[record.key] ?? quietDefaults
        return {
            sound: a.sound && !settings.modes.noSound,
            toast: a.toast && !settings.modes.noPopups,
            panel: a.panel,
            indicator: a.indicator && !settings.modes.noIndicators
        }
    }

    // ---------------------------------------------------------------- actions
    function receive(n) {
        n.tracked = true                            // keep the server's object alive

        const key = appKeyOf(n)
        if (!(key in settings.apps))                // a new app: remember it, quiet by default
            change({ apps: Object.assign({}, settings.apps, { [key]: quietDefaults }) })

        const record = {
            id: n.id, key: key, appName: n.appName, summary: n.summary, body: n.body,
            urgency: n.urgency, time: Date.now(), read: false, notification: n
        }
        items = [record, ...items.filter(r => r.id !== record.id)]   // same id replaces

        const fx = effectsFor(record)
        if (fx.sound) soundRequested(record)
        if (fx.toast) toastRequested(record)

        n.closed.connect(() => remove(record.id))   // the app (or we) closed it
    }

    function remove(id) { items = items.filter(r => r.id !== id) }
    function markRead(id) { items = items.map(r => r.id === id ? Object.assign({}, r, { read: true }) : r) }
    function markAppRead(key) { items = items.map(r => r.key === key ? Object.assign({}, r, { read: true }) : r) }
    function dismiss(id) { items.find(r => r.id === id)?.notification.dismiss() }      // fires `closed`
    function clearAll() { items.slice().forEach(r => r.notification.dismiss()) }

    function setAppFlag(key, flag, value) {
        const current = settings.apps[key] ?? quietDefaults
        change({ apps: Object.assign({}, settings.apps, { [key]: Object.assign({}, current, { [flag]: value }) }) })
    }
    function setMode(name, value) {
        change({ modes: Object.assign({}, settings.modes, { [name]: value }) })
    }
}
