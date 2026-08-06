import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

RowLayout {
    // get a list of nodes that output to the default sink
    PwNodeLinkTracker {
        id: linkTracker
        node: Pipewire.defaultAudioSink
    }

    Repeater {
        model: linkTracker.linkGroups

        MixerEntry {
            Layout.alignment: Qt.AlignTop
            required property PwLinkGroup modelData
            // Each link group contains a source and a target.
            // Since the target is the default sink, we want the source.
            node: modelData.source
        }
    }

    MixerEntry {
        Layout.alignment: Qt.AlignTop
        node: Pipewire.defaultAudioSink
    }
}
