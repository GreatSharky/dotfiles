pragma ComponentBehavior: Bound
import Quickshell.Hyprland
import Quickshell.Widgets
import Quickshell
import QtQuick
import Qt.labs.folderlistmodel

WrapperRectangle {
    id: root
    color: Qt.alpha(Theme.bgDark, 0.5)
    radius: 10
    margin: 10
    height: 26
    visible: container.apps.length > 0

    Row {
        id: container
        readonly property HyprlandWorkspace workspace: Hyprland.focusedWorkspace
        property var apps: (workspace?.toplevels.values ?? []).filter(t => t.lastIpcObject.at != undefined && !t.lastIpcObject.floating).sort((a, b) => a.lastIpcObject.at[0] - b.lastIpcObject.at[0])
        // Names of the program running inside a terminal window, matched on the title.
        readonly property var terminalIcons: [
            {
                pattern: /^n?vim?\b/,
                icon: "nvim"
            },
            {
                pattern: /^[✳✻◐◑◒◓·]/,
                icon: "claude-code"
            }
        ]
        // Custom icons: any icons/<name>.svg or icons/<name>.png, keyed by the
        // lowercase file name without extension. They win over the desktop entry icons.
        FolderListModel {
            id: customIconFiles
            folder: "file://" + Quickshell.shellPath("icons")
            nameFilters: ["*.svg", "*.png"]
            showDirs: false
        }
        readonly property var customIcons: {
            const icons = {};
            for (let i = 0; i < customIconFiles.count; i++) {
                const name = customIconFiles.get(i, "fileName").replace(/\.[^.]+$/, "");
                icons[name.toLowerCase()] = customIconFiles.get(i, "fileUrl").toString();
            }
            return icons;
        }

        spacing: 3

        Component.onCompleted: {
            Hyprland.refreshToplevels();
        }
        onAppsChanged: {
            Hyprland.refreshToplevels();
        }
        // hyprland.lua emits a custom "nav-refresh" event after swapping columns (Hyprland sends no
        // event for that). Re-read the windows so the navigation bar shows the new order.
        Connections {
            target: Hyprland
            function onRawEvent(event) {
                if (event.name === "custom" && event.data === "nav-refresh")
                    Hyprland.refreshToplevels();
            }
        }

        Repeater {
            model: ScriptModel {
                values: container.apps
            }
            AppIcon {
                id: icon
                required property var modelData
                readonly property var entry: DesktopEntries.heuristicLookup(modelData.lastIpcObject.class)

                readonly property bool isTerminal: modelData.lastIpcObject.class === "com.mitchellh.ghostty"
                readonly property string terminalIcon: isTerminal ? Functions.patternMatch(modelData.title, container.terminalIcons) : ""
                // The program inside a terminal if one matched, otherwise the window class.
                readonly property string iconName: terminalIcon !== "" ? terminalIcon : modelData.lastIpcObject.class
                anchors.verticalCenter: container.verticalCenter
                anchors.verticalCenterOffset: modelData.activated ? 6 : 0

                size: modelData.activated ? 45 : 22
                // 1. custom icon from icons/  2. icon of the matched program  3. desktop entry icon
                source: container.customIcons[iconName.toLowerCase()] ?? (terminalIcon !== "" ? Quickshell.iconPath(terminalIcon, "application-x-executable") : Quickshell.iconPath(entry?.icon ?? iconName, "application-x-executable"))

                onClicked: Hyprland.dispatch(`hl.dsp.focus({ window = "address:0x${modelData.address}" })`)
            }
        }
    }
}
