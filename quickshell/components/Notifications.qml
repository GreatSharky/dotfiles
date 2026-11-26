// Notifications.qml
// Steps 1 and 2 of the notification system (see "Notifications" in the README): receive
// notifications, hand them to NotificationStore and log everything that arrives, so you can
// see what apps really send. Read the log with `quickshell log -f`.
//
// NotificationServer owns org.freedesktop.Notifications on the session bus, so dunst must
// not be running (it is masked). Test with: notify-send -a demo "Title" "Body"
import Quickshell
import Quickshell.Services.Notifications

Scope {
    // One hint value as short text: strings are cut, objects and byte arrays are summarised.
    function hintText(value) {
        let text
        try { text = typeof value === "string" ? `"${value}"` : JSON.stringify(value) }
        catch (e) { text = String(value) }
        if (text === undefined) text = String(value)
        return text.length > 100 ? `${text.slice(0, 100)}... [${text.length} chars]` : text
    }

    // Everything the server knows about a notification, one fact per line.
    function describe(n, receivedAt) {
        const actions = n.actions.map(a => `${a.identifier}="${a.text}"`)
        const hints = Object.keys(n.hints).map(k => `${k}=${hintText(n.hints[k])} (${typeof n.hints[k]})`)
        const timeout = n.expireTimeout === -1 ? "-1 (the server decides)"
                      : n.expireTimeout === 0 ? "0 (never expires)" : `${n.expireTimeout} ms`
        return [
            `[notification] #${n.id} received ${receivedAt.toISOString()}`,
            `    app          : name="${n.appName}"  desktop entry="${n.desktopEntry}"`,
            `    urgency      : ${NotificationUrgency.toString(n.urgency)}`,
            `    summary      : ${n.summary}`,
            `    body         : ${n.body}`,
            `    app icon     : "${n.appIcon}"`,
            `    image        : "${n.image}"`,
            `    timeout      : ${timeout}`,
            `    transient    : ${n.transient}   resident: ${n.resident}`,
            `    actions      : ${actions.length ? actions.join(", ") : "none"}   (action icons: ${n.hasActionIcons})`,
            `    inline reply : ${n.hasInlineReply}${n.hasInlineReply ? ` (placeholder "${n.inlineReplyPlaceholder}")` : ""}`,
            `    hints (${hints.length})  : ${hints.length ? hints.join("\n                   ") : "none"}`,
            `    tracked      : ${n.tracked}   carried over from before a reload: ${n.lastGeneration}   tracked by the server now: ${server.trackedNotifications.values.length}`
        ].join("\n")
    }

    NotificationServer {
        id: server
        keepOnReload: true              // keep notifications across a live reload of the shell

        // What this server tells apps it can display.
        bodySupported: true
        actionsSupported: true
        imageSupported: true

        onNotification: n => {
            const receivedAt = new Date()
            console.log(describe(n, receivedAt))

            // The store keeps the notification (it sets `tracked`), applies the rules and
            // fires the one-shot effects. Newest record is first.
            NotificationStore.receive(n)
            const record = NotificationStore.items[0]
            console.log(`[store] #${n.id} key="${record.key}"`
                + ` effects=${JSON.stringify(NotificationStore.effectsFor(record))}`
                + ` items=${NotificationStore.items.length} unread=${NotificationStore.unreadCount}`)

            // An app can replace a notification (same id). Log it, to see how the server reports it.
            n.summaryChanged.connect(() => console.log(`[notification] #${n.id} summary changed: ${n.summary}`))
            n.bodyChanged.connect(() => console.log(`[notification] #${n.id} body changed: ${n.body}`))

            n.closed.connect(reason => {
                const seconds = ((Date.now() - receivedAt.getTime()) / 1000).toFixed(1)
                console.log(`[notification] #${n.id} closed after ${seconds} s: ${NotificationCloseReason.toString(reason)}`)
            })
        }
    }
}
