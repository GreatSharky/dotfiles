// CustomIcons.qml
// The icons you put in icons/ (svg or png), looked up by name. The name is the file name
// without its extension, lowercase: icons/com.mitchellh.ghostty.svg is found with
// CustomIcons.lookup("com.mitchellh.ghostty"). They override the icons apps bring with
// them, so a style you do not like can be replaced by dropping in a better file.
pragma Singleton

import Quickshell
import QtQuick
import Qt.labs.folderlistmodel

Singleton {
    id: root

    FolderListModel {
        id: files
        folder: "file://" + Quickshell.shellPath("icons")
        nameFilters: ["*.svg", "*.png"]
        showDirs: false
    }

    // lowercase name -> file URL. Rebuilt when files are added or removed.
    readonly property var map: {
        const icons = {}
        for (let i = 0; i < files.count; i++) {
            const name = files.get(i, "fileName").replace(/\.[^.]+$/, "")
            icons[name.toLowerCase()] = files.get(i, "fileUrl").toString()
        }
        return icons
    }

    // The file URL for a name, or "" when there is no custom icon for it.
    function lookup(name) {
        return map[String(name ?? "").toLowerCase()] ?? ""
    }
}
