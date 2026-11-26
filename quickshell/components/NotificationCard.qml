import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

Rectangle {
    id: root
    required property var record
    readonly property var notification: record.notification

    // 1. a custom icon from icons/ (by app key, then by app name), the same files the navigation
    //    bar uses, 2. the notification's own image, 3. its icon, 4. the app's desktop-entry icon.
    readonly property string iconSource: {
        const custom = CustomIcons.lookup(record.key) || CustomIcons.lookup(record.appName);
        if (custom !== "")
            return custom;
        const n = notification;
        if (n.image !== "")
            return n.image;
        if (n.appIcon !== "") {
            if (n.appIcon.startsWith("/"))
                return "file://" + n.appIcon;
            const found = Quickshell.iconPath(n.appIcon, true);      // "" when the theme lacks it
            if (found !== "")
                return found;
        }
        const name = entry?.icon || record.key;                  // `||`: an empty string counts as missing too
        return Quickshell.iconPath(name !== "" ? name : "dialog-information", "dialog-information");
    }
    // The live Notification: an app can replace one in place, so read the text from it and
    // not from the copies in the record.
    readonly property var entry: DesktopEntries.heuristicLookup(record.key)
    readonly property string appName: record.appName || entry?.name || record.key

    implicitHeight: content.implicitHeight + 2 * content.anchors.margins
    radius: 10
    color: Theme.surface
    border.width: 1
    border.color: Theme.border

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
}
