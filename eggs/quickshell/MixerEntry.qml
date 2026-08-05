import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.Pipewire

Rectangle {
    required property PwNode node
    property int padding: 10
    color: Theme.background
    border.color: Theme.border
    implicitHeight: col.height + padding * 2
    implicitWidth: col.width + padding * 2

    ColumnLayout {
        id: col
        width: 96
        x: padding
        y: padding

        // bind the node so we can read its properties
        PwObjectTracker {
            objects: [node]
        }

        Image {
            Layout.alignment: Qt.AlignCenter
            source: {
                const icon = node.properties["application.icon-name"] ?? !node.isStream ? "audio-speakers-symbolic" : "window-symbolic";
                return `image://icon/${icon}`;
            }

            sourceSize.width: 20
            sourceSize.height: 20
        }

        VerticalSlider {
            id: slider
            to: 2
            labelCount: 5
            lineCount: 9
            value: node.audio.volume
            onValueChanged: node.audio.volume = value
        }

        Button {
            Layout.alignment: Qt.AlignCenter
            property int size: 36
            onClicked: node.audio.muted = !node.audio.muted
            implicitHeight: size
            implicitWidth: size

            Image {
                property int padding: 10
                property int size: parent.size - padding * 2
                x: padding
                y: padding
                source: {
                    const volume = node.audio.volume;
                    let icon = "";
                    if (node.audio.muted)
                        icon = "player-volume-muted-symbolic";
                    else if (volume > 0.66)
                        icon = "audio-volume-high-symbolic";
                    else if (volume > 0.33)
                        icon = "audio-volume-medium-symbolic";
                    else
                        icon = "audio-volume-low-symbolic";

                    return `image://icon/${icon}`;
                }
                sourceSize.width: size
                sourceSize.height: size
            }
        }

        Label {
            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: 36
            horizontalAlignment: Text.Center
            wrapMode: Text.Wrap
            elide: Text.ElideRight
            text: {
                // application.name -> description -> name
                const app = node.properties["application.name"] ?? (node.description != "" ? node.description : node.name);
                const media = node.properties["media.name"];
                return media != undefined ? `${app} - ${media}` : app;
            }
        }
    }
}
