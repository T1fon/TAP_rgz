import QtQuick 2.15
import QtQuick.Controls 2.15

Dialog {
    id:dialog_window
    property string title_data: ""
    property string message: ""
    property int swidth: 100
    property int sheight: 100

    standardButtons: Dialog.Ok

    implicitWidth: swidth *80
    implicitHeight: sheight * 65

    x: swidth * 15
    y: sheight * 17.5

    contentItem: Rectangle{
        id: content
        width: parent.width
        height: sheight * 35
        border.width: 0
        Flickable{
            height:parent.height
            width:  parent.width
            contentHeight: height
            contentWidth: width

            clip:true

            TextEdit{
                id: content_text

                readOnly: true
                wrapMode: TextEdit.Wrap
                font.pixelSize: 12
            }
        }
    }


    onOpened: {
        dialog_window.title = title_data
        content_text.text = message
    }

}
