// Indicator.qml
// A reusable icon + optional text pair for the status area.
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets

WrapperMouseArea {
    id: root
    // In a layout, fill the full height so the whole bar height is clickable.
    Layout.fillHeight: true
    // Nerd Font glyph, e.g. "󰁹"
    property string icon: ""
    // Value text next to the icon. Leave empty to show only the icon.
    property string text: ""
    property color color: Theme.offWhite
    property int fontSize: 16
    // The widest value this indicator can show, e.g. "100%". The text always takes at
    // least this much width, so the indicator keeps the same size when the value changes.
    // Not needed when `percent` is used: that reserves the width of "100%" by itself.
    property string reserveText: ""
    // Optional: set a percentage (0 and up) and the indicator formats it itself, always 4
    // characters wide: " 0 %", " 5 %", "10 %", "75 %", "100%". When set, `text` is ignored.
    property real percent: -1
    // Width of the icon slot. Glyphs differ in width, so a fixed slot stops the indicator
    // from resizing when the icon changes. Defaults to fit the widest Nerd Font glyphs.
    property real iconWidth: fontSize * 1.4
    property BarPopup popup

    function formatPercent(value: real): string {
        const n = Math.max(0, Math.round(value));
        return `${n}${n < 100 ? " %" : "%"}`.padStart(4);
    }
    readonly property string shownText: percent >= 0 ? formatPercent(percent) : text

    onClicked: {
        console.log(`${root.icon}-${root.text} clicked`);
        if (popup)
            popup.open = !popup.open;
    }
    cursorShape: enabled && popup ? Qt.PointingHandCursor : Qt.ArrowCursor

    Row {
        spacing: 4

        Text {
            visible: root.icon !== ""
            text: root.icon
            color: root.color
            font.family: Theme.font
            font.pixelSize: root.fontSize
            width: root.iconWidth
            horizontalAlignment: Text.AlignHCenter
            anchors.verticalCenter: parent.verticalCenter
        }

        TextMetrics {
            id: reserve
            font: valueText.font
            text: root.reserveText !== "" ? root.reserveText : (root.percent >= 0 ? "100%" : "")
        }

        Text {
            id: valueText
            visible: root.shownText !== ""
            text: root.shownText
            color: root.color
            font.family: Theme.font
            font.pixelSize: root.fontSize
            width: Math.max(implicitWidth, reserve.width)
            horizontalAlignment: Text.AlignRight
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
