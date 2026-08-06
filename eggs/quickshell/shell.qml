import QtQuick
import Quickshell
import Quickshell.Io

ShellRoot {
    PanelWindow {
        id: volumeWindow
        implicitWidth: volumeControl.width
        implicitHeight: volumeControl.height
        exclusiveZone: 0
        visible: false
        color: "transparent"

        anchors {
            right: true
        }

        VolumeControl {
            id: volumeControl
        }
    }

    PanelWindow {
        id: brightnessWindow
        implicitWidth: brightnessControl.width
        implicitHeight: brightnessControl.height
        exclusiveZone: 0
        visible: false
        color: "transparent"

        anchors {
            right: true
        }

        BrightnessControl {
            id: brightnessControl
        }
    }

    IpcHandler {
        target: "windows"

        function showVolume(show: bool): void {
            volumeWindow.visible = show;
        }

        function showBrightness(show: bool): void {
            brightnessWindow.visible = show;
        }
    }
}
