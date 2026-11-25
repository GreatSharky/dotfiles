// Notifications.qml
// Steps 1 and 2 of the notification system (see "Notifications" in the README): receive
// notifications, hand them to NotificationStore and log what happened. Nothing is shown yet.
//
// NotificationServer owns org.freedesktop.Notifications on the session bus, so dunst must
// not be running (it is masked). Test with: notify-send -a demo "Title" "Body"
import Quickshell
import Quickshell.Services.Notifications

Scope {
    NotificationServer {
        keepOnReload: true              // keep notifications across a live reload of the shell

        // What this server tells apps it can display.
        bodySupported: true
        actionsSupported: true
        imageSupported: true

        onNotification: n => {
            const actions = n.actions.map(a => a.identifier)
            console.log(`[notification] #${n.id} app="${n.appName}" entry="${n.desktopEntry}"`
                + ` urgency=${NotificationUrgency.toString(n.urgency)}`
                + ` timeout=${n.expireTimeout} transient=${n.transient} resident=${n.resident}`
                + ` actions=${JSON.stringify(actions)} image=${n.image !== ""}`
                + ` hints=${JSON.stringify(Object.keys(n.hints))}`
                + ` | ${n.summary} | ${n.body}`)

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
                console.log(`[notification] #${n.id} closed: ${NotificationCloseReason.toString(reason)}`)
            })
        }
    }
}
