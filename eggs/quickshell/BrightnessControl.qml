import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Rectangle {
    id: wrapper
    border.color: Theme.border
    implicitHeight: col.height + padding * 2
    implicitWidth: col.width + padding * 2

    property int padding: 10
    property int maxBrightness: 0
    property int currentBrightness: 0
    property real brightnessPoint: 0

    onCurrentBrightnessChanged: brightnessPoint = currentBrightness / maxBrightness

    color: Theme.background

    ColumnLayout {
        id: col
        implicitWidth: slider.width
        x: wrapper.padding
        y: wrapper.padding

        Process {
            id: poll
            running: true
            command: ["brightnessctl", "get"]
            stdout: StdioCollector {
                onStreamFinished: wrapper.currentBrightness = parseInt(this.text)
            }
        }

        Process {
            running: true
            command: ["brightnessctl", "max"]
            stdout: StdioCollector {
                onStreamFinished: wrapper.maxBrightness = parseInt(this.text)
            }
        }

        Process {
            id: setter
            running: false
            command: ["brightnessctl", "set"]
        }

        Timer {
            id: timer
            running: wrapper.visible
            repeat: true
            interval: 60
            onTriggered: poll.running = true
        }

        Image {
            Layout.alignment: Qt.AlignCenter
            source: {
                let icon = "";
                if (wrapper.brightnessPoint < 0.33)
                    icon = "brightness-low-symbolic";
                else if (wrapper.brightnessPoint < 0.66)
                    icon = "brightness-medium-symbolic";
                else
                    icon = "brightness-high-symbolic";
                return `image://icon/${icon}`;
            }

            sourceSize.width: 20
            sourceSize.height: 20
        }

        VerticalSlider {
            id: slider
            to: 1
            labelCount: 5
            lineCount: 9
            value: wrapper.brightnessPoint
            onValueChanged: {
                const brightness = Math.round(value * wrapper.maxBrightness);
                setter.command = ["brightnessctl", "set", brightness.toString()];
                setter.running = true;
            }
        }
    }
}
