// PopupManager.qml
// Keeps track of the popup that was opened last, so only one popup is open at a time.
// Each Popup registers itself here when it opens and closes itself when another one does.
pragma Singleton

import Quickshell

Singleton {
  property var current: null
}
