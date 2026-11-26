
Indicator {
    id: root
    readonly property string bellGlyphs: "󰂚"

    icon: root.bellGlyphs
    text: NotificationStore.unreadCount

    popup: QuickPopup {
        id: popup
        anchor.item: root
        anchor.rect.y: root.height
        anchor.rect.x: (root.width - popup.implicitWidth) / 2

        NotificationPanel {}
    }
}
