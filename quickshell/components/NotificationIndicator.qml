Indicator {
    id: root

    icon: notificationpanel.modeIcon
    text: NotificationStore.unreadCount

    popup: QuickPopup {
        id: popup
        anchor.item: root
        anchor.rect.y: root.height
        anchor.rect.x: (root.width - popup.implicitWidth) / 2

        NotificationPanel {
            id: notificationpanel
        }
    }
}
