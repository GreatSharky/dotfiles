// WifiConnectionIndicator.qml
// One row of the Wi-Fi list: network name and a state glyph. Clicking it:
//   connected                          -> disconnect
//   saved, or open / OWE               -> connect (no credentials needed)
//   not saved, WPA/WPA2 PSK or SAE     -> ask for the password inline, then connectWithPsk
//   not saved, enterprise / WEP / LEAP -> cannot be done here, show a message
// A failed attempt with NoSecrets (wrong or missing password) brings the prompt back.
// A failed login with a password typed here removes the profile NetworkManager saved for it,
// so a wrong password never ends up in the known list. (Networks that were already saved are
// left alone: they may only have failed for another reason.)
// Right click on a saved network forgets it (deletes the saved profile and its password).
// Right click on an unsaved network does nothing.
import Quickshell.Networking
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

WrapperMouseArea {
    id: root

    required property var network          // a WifiNetwork

    property var stateGlyph: ({ connected: "", known: "󱓴", protected: "󱂯", open: "" })

    property bool askingPassword: false
    property string message: ""
    // True from submitting a password for a network that was NOT saved until that attempt.
    property bool discardOnFailure: false
    // The attempt failed but NetworkManager has not marked the profile as saved yet.
    property bool pendingForget: false
    readonly property bool busy: network?.stateChanging ?? false

    acceptedButtons: Qt.LeftButton | Qt.RightButton
    hoverEnabled: true
    cursorShape: busy ? Qt.WaitCursor : Qt.PointingHandCursor

    // A network that needs no credentials to join (OWE encrypts without a password).
    readonly property bool isOpen: network?.security === WifiSecurityType.Open
                                || network?.security === WifiSecurityType.Owe
    // Security types where a single password is enough. connectWithPsk is only valid for these.
    readonly property bool usesPassword: network?.security === WifiSecurityType.WpaPsk
                                      || network?.security === WifiSecurityType.Wpa2Psk
                                      || network?.security === WifiSecurityType.Sae

    // Row icon, most specific state first: connected, saved, open, otherwise protected.
    readonly property string glyph: network?.connected ? stateGlyph.connected
                                  : network?.known     ? stateGlyph.known
                                  : isOpen            ? stateGlyph.open
                                  :                     stateGlyph.protected

    // Row color: connected is brightest, saved is dimmer, unsaved networks stand out.
    readonly property color textColor: network?.connected ? Theme.fg
                                     : network?.known     ? Theme.fgDark
                                     :                     Theme.warn

    function activate() {
        if (busy) return
        message = ""
        if (askingPassword) {
            cancel()
        } else if (network.connected) {
            network.disconnect()
        } else if (network.known || isOpen) {
            discardOnFailure = !network.known          // an unsaved open network that fails is not kept
            network.connect()
        } else if (usesPassword) {
            askingPassword = true
        } else {
            message = "Needs a saved profile"        // enterprise, WEP, LEAP: not supported here
        }
    }

    function submit() {
        const password = passwordField.text
        passwordField.clear()                          // do not keep the password around
        askingPassword = false
        if (password === "")
            return
        discardOnFailure = !network.known
        network.connectWithPsk(password)
    }

    // Remove the profile a failed attempt left behind.
    function discardFailedProfile() {
        discardOnFailure = false
        if (network.known)
            network.forget()
        else
            pendingForget = true                       // forget as soon as it shows up as saved
    }

    function forget() {
        if (busy || !network.known)
            return
        cancel()
        message = ""
        network.forget()
    }

    function cancel() {
        passwordField.clear()
        askingPassword = false
    }

    onClicked: mouse => {
        if (mouse.button === Qt.RightButton)
            forget()
        else
            activate()
    }

    onAskingPasswordChanged: {
        if (askingPassword)
            Qt.callLater(() => passwordField.forceActiveFocus())
    }

    Connections {
        target: root.network
        function onConnectionFailed(reason) {
            if (root.discardOnFailure)
                root.discardFailedProfile()
            if (reason === ConnectionFailReason.NoSecrets && root.usesPassword) {
                root.askingPassword = true
                root.message = "Wrong or missing password"
            } else {
                root.message = ConnectionFailReason.toString(reason)
            }
        }
        function onConnectedChanged() {
            if (root.network.connected) {
                root.message = ""
                root.discardOnFailure = false
                root.pendingForget = false
            }
        }
        function onKnownChanged() {
            if (root.pendingForget && root.network.known) {
                root.pendingForget = false
                root.network.forget()
            }
        }
    }

    ColumnLayout {
        spacing: 4
        opacity: root.busy ? 0.5 : 1

        RowLayout {
            Layout.fillWidth: true
            spacing: 2

            Text {
                elide: Text.ElideRight
                text: root.network?.name ?? ""
                color: root.textColor
                font.family: Theme.font
                font.pixelSize: 12
            }

            Item { Layout.fillWidth: true }

            Text {
                text: root.glyph
                color: root.textColor
                font.family: Theme.font
                font.pixelSize: 16
            }
        }

        TextField {
            id: passwordField
            visible: root.askingPassword
            Layout.fillWidth: true
            echoMode: TextInput.Password
            passwordCharacter: "\u2022"
            placeholderText: "Password"
            placeholderTextColor: Theme.muted
            color: Theme.fg
            font.family: Theme.font
            font.pixelSize: 12
            selectionColor: Theme.accent
            selectedTextColor: Theme.bg
            onAccepted: root.submit()
            Keys.onEscapePressed: root.cancel()
            background: Rectangle {
                radius: 6
                color: Theme.bgHover
                border.width: 1
                border.color: passwordField.activeFocus ? Theme.accent : Theme.border
            }
        }

        Text {
            visible: root.message !== ""
            Layout.fillWidth: true
            text: root.message
            wrapMode: Text.Wrap
            color: Theme.bad
            font.family: Theme.font
            font.pixelSize: 11
        }
    }
}
