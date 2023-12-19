import QtQuick
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Main_Screen 1.0
import Table_Model 1.0
import QtQuick.Dialogs

Rectangle {
    id: wrapper
    property real swidth: width/100
    property real sheight: height/100
    onScaleChanged:
        ()=>{
            swidth = wrapper.width/100
            sheight = wrapper.height/100
        }
    function openDialogWindow(title, message){
        var component_var;
        var status;
        component_var = Qt.createComponent("DialogWindow.qml")

        if(component_var.status === Component.Ready){
            status = component_var.createObject(wrapper,{sheight: wrapper.sheight, swidth: wrapper.swidth, title_data: title,message: message})
            if(status === null){
              console.log("Ошибка в создании диалогового окна");
            }
            status.open()
        }
        else{
            console.log(component_var.errorString())
        }
    }

    Main_Screen{
        id:main_screen
        onGeneratedStatus:
            (error_msg)=>
            {
                wrapper.openDialogWindow("Неудача", error_msg);
            }
        onSetGramaticks:
            (alphabet, start_chain, end_chain)=>
            {
                ti_alphabet.text = alphabet
                ti_start.text = start_chain
                ti_end.text = end_chain
            }
        onShowResult:
            (result)=>
            {
                te_result.text = result
            }
    }
    Table_Model{
        id: table_model
    }


    FileDialog{
        id:openFileDiealog
        currentFolder:"C:/Vato/My_Programs/Qt_Application/Lab_6TAP/TestGrammaticks"
        fileMode: FileDialog.OpenFile
        onAccepted:{
            main_screen.analizeFile(openFileDiealog.selectedFile)
        }
    }
    FileDialog{
        id:saveFileDiealog
        currentFolder:"C:/Vato/My_Programs/Qt_Application/Lab_6TAP/TestGrammaticks"
        fileMode: FileDialog.SaveFile
        onAccepted:{
            main_screen.saveFile(saveFileDiealog.selectedFile)
        }
    }

    ToolBar{
        id: toolbar
        width: parent.width
        height: sheight * 6
        anchors.top: parent.top
        anchors.left: parent.left
        RowLayout{
            Button{
                height:sheight * 6
                text: "Автор"
                onClicked: {
                    openDialogWindow("Автор", "Студент группы ИП-011\n" + "Шульженко Иван Владимирович");
                }
            }
            Button{
                height:sheight * 6
                text: "Тема"
                onClicked: {
                    openDialogWindow("Справка","Написать программу, которая \n"+
                    "по предложенному описанию языка построит детерминированный\n конечный автомат,"+
                    "распознающий этот язык, \nи проверит вводимые с клавиатуры цепочки \nна их принадлежность языку.\n"+
                    "Предусмотреть возможность поэтапного отображения \nна экране процесса проверки цепочек.\n"+
                    "Функция переходов ДКА может \nизображаться в виде таблицы  и графа\n"+
                    "(выбор вида отображения посредством меню).\n"+
                    "Вариант задания языка: \nАлфавит, начальная и конечная подцепочки всех цепочек языка.\n");
                }
            }
            Button{
                height:sheight * 6
                text: "Справка"
                onClicked: {
                    openDialogWindow("Справка", "Алфавит:\n"+
                                     "1. Каждый элемент афлавита должен состоять из 1 символа\n"+
                                     "2. Разделитель элементов алфавита - символ запятая (',')\n"+
                                     "Цепочки:\n"+
                                     "* Начальная может быть любая, в том числе и нулевая\n" +
                                     "* Конечная цепочка может быть любая но не нулевая\n"+
                                     "Конечное состояние - это всегда 'qf'");
                }
            }
            Button{
                height:sheight * 6
                text: "Открыть файл с данными для генерации ДКА"
                onClicked: {
                    openFileDiealog.open()
                }
            }
            Button{
                height:sheight * 6
                text: "Сохранить ДКА в файл"
                onClicked: {
                    saveFileDiealog.open()
                }
            }
        }
    }

    Rectangle{
        id: plane_tools
        width: parent.width/2
        height: sheight*95
        anchors.top: toolbar.bottom
        anchors.left: parent.left
        border.color: "light gray"
        border.width: 1
        ColumnLayout{
            spacing: sheight
            Rectangle{
                id: a_field
                width: swidth*45
                height: sheight*5
                RowLayout{
                    Text{
                        text: "Алфавит = "
                    }
                    TextField{
                        id: ti_alphabet
                        text:"a,b,c"
                    }
                }
            }
            Rectangle{
                id: e_field
                width: swidth*45
                height: sheight*5
                RowLayout{
                    Text{
                        text: "Начальная подцепочка = "
                    }
                    TextField{
                        id: ti_start
                        text:"aab"
                    }
                }
            }
            Rectangle{
                id: end_field
                width: swidth*45
                height: sheight*5
                RowLayout{
                    Text{
                        text: "Конечная подцепочка = "
                    }
                    TextField{
                        id: ti_end
                        text:"caca"
                    }
                }
            }
            Rectangle{
                id: change_field
                width: swidth*45
                height: sheight*5
                RowLayout{
                    Text{
                        text: "Цепочка = "
                    }
                    TextField{
                        id: ti_change
                        text:"aabbbbbcaca"
                    }
                }
            }
            Button{
                id: generate_dka_but
                width: swidth * 20
                height: sheight *5
                text: "Сгенерировать ДКА"
                onClicked:
                {
                    main_screen.generateDMA(ti_start.displayText, ti_end.displayText, ti_alphabet.displayText)
                }
            }
            Rectangle{
                width: plane_tools.width
                height: sheight*0.5
                color: "#EBEBEB"
            }

            Rectangle{
                id: p_field
                width: swidth*45
                height: sheight*50
                ColumnLayout{
                    spacing: sheight
                    RowLayout{
                        spacing: swidth
                        Text{
                            text: "Отображение: "
                        }

                        Button{
                            id: table_view
                            width: swidth * 20
                            height: sheight *5
                            text: "Тиблица"
                            onClicked:
                            {
                                canvas_box.visible = false;
                                table_box.visible = true;
                                table_model.setTableHeader(main_screen.generateTableHeader())
                                table_model.setTableData(main_screen.generateTableData())
                                table_box.height = sheight*50
                                table_box.width = swidth*50
                            }
                        }
                        Button{
                            id: graph_view
                            width: swidth * 20
                            height: sheight *5
                            text: "Граф"
                            onClicked: {
                                canvas_box.visible = true;
                                table_box.visible = false;
                                graph_canvas.graph = main_screen.getDMA();
                                let max = (ti_start.text.length > ti_end.text.length ? ti_start.text.length : ti_end.text.length);
                                canvas_box.contentHeight = max * (graph_canvas.step_vertex+graph_canvas.space_vertex) + graph_canvas.step_vertex * max/2
                                canvas_box.height = sheight*50
                                canvas_box.width = swidth*50
                                graph_canvas.requestPaint();
                            }
                        }
                    }
                    Flickable{
                        id: canvas_box
                        height:sheight*50
                        width:  swidth*50.0
                        contentHeight: height
                        contentWidth: width
                        clip:true
                        visible: false

                        ScrollBar.vertical: ScrollBar {
                            policy: ScrollBar.AlwaysOn
                            active: true

                        }
                        ScrollBar.horizontal: ScrollBar{
                            id: hbar
                            policy: ScrollBar.AlwaysOn
                            active: true
                        }
                        Canvas{
                            id: graph_canvas
                            height: canvas_box.contentHeight
                            width: canvas_box.contentWidth
                            property var graph: ({})
                            readonly property real size_vertex: swidth*6.25
                            readonly property real step_vertex: swidth * 7.8125
                            readonly property real space_vertex: (swidth * 7.8125)
                            readonly property real step_x: swidth
                            readonly property real step_y: sheight
                            onPaint: {
                                var ctx = getContext("2d")
                                console.log(graph_canvas.graph)
                                console.log(graph_canvas.graph["data"])

                                ctx.clearRect(0,0,graph_canvas.width,graph_canvas.height)
                                ctx.strokeStyle = Qt.rgba(0, 0, 0, 1);
                                ctx.lineWidth = 1;
                                ctx.beginPath();
                                if(graph_canvas.graph["data"].length !== 0)
                                {
                                    var i, length;
                                    let j , lenght_j, temp, alphabet_size;
                                    alphabet_size = main_screen.getAlphabetSize();
                                    for(i = 0, length = ti_start.text.length; i < length; i++)
                                    {
                                        ctx.ellipse(step_x+0,
                                                    step_y+(step_vertex+space_vertex)*i+space_vertex,
                                                    size_vertex,
                                                    size_vertex)
                                        ctx.text(graph_canvas.graph["data"][i]["key"],
                                                 step_x+size_vertex/2.8,
                                                 step_y+(step_vertex+space_vertex)*i+space_vertex + size_vertex/1.8)
                                        ctx.text(ti_start.text[i],
                                                 step_x+size_vertex/2.8+step_x*2,
                                                 step_y+(step_vertex+space_vertex)*i + space_vertex+size_vertex+step_y*2)
                                        ctx.moveTo(step_x+size_vertex/2,
                                                   step_y+(step_vertex+space_vertex)*i + space_vertex+size_vertex)
                                        ctx.lineTo(step_x+size_vertex/2,
                                                   step_y+(step_vertex+space_vertex)*(i+1)+ space_vertex)
                                        if(i !== length-1){
                                            ctx.lineTo(step_x+size_vertex/2 + step_x,
                                                       step_y+(step_vertex+space_vertex)*(i+1)+ space_vertex - step_y*2)
                                            ctx.moveTo(step_x+size_vertex/2,
                                                       step_y+(step_vertex+space_vertex)*(i+1)+ space_vertex)
                                            ctx.lineTo(step_x+size_vertex/2 - step_x,
                                                       step_y+(step_vertex+space_vertex)*(i+1)+ space_vertex - step_y*2)
                                        }
                                    }
                                    var middle = ti_start.text.length < ti_end.text.length ? ti_start.text.length : ti_end.text.length
                                    //входящая стрелка
                                    ctx.lineTo(step_x+step_vertex * 2+step_x/1.3,
                                               step_y+(step_vertex+space_vertex) *Math.floor(middle / 2)  + space_vertex + size_vertex-step_y*1.8)
                                    ctx.lineTo(step_x+step_vertex * 2-step_x/1.3,
                                               step_y+(step_vertex+space_vertex) *Math.floor(middle / 2)  + space_vertex + size_vertex-step_y*1.8)
                                    ctx.moveTo(step_x+step_vertex * 2+step_x/1.3,
                                               step_y+(step_vertex+space_vertex) *Math.floor(middle / 2)  + space_vertex + size_vertex-step_y*1.8)
                                    ctx.lineTo(step_x+step_vertex * 2+step_x*1.4,
                                               step_y+(step_vertex+space_vertex) *Math.floor(middle / 2)  + space_vertex + size_vertex+step_y)
                                    //средний элемент
                                    ctx.ellipse(step_x+step_vertex * 2,
                                                step_y+(step_vertex+space_vertex)*Math.floor(middle / 2) + space_vertex,
                                                size_vertex,
                                                size_vertex)
                                    ctx.text(graph_canvas.graph["data"][i]["key"],
                                             step_x+space_vertex*2+size_vertex/2.8,
                                             step_y+(step_vertex+space_vertex) *Math.floor(middle / 2)  + space_vertex+ size_vertex/1.8)
                                    //кольцевая стрелка
                                    ctx.moveTo(step_x+space_vertex*2+size_vertex*0.7,
                                               step_y+(step_vertex+space_vertex) *Math.floor(middle / 2)  + space_vertex + step_y/2)
                                    ctx.bezierCurveTo(step_x+space_vertex*2+size_vertex*0.7 + step_x,
                                                      step_y+(step_vertex+space_vertex) *Math.floor(middle / 2)  - space_vertex/4,
                                                      step_x+space_vertex*2+size_vertex*0.2 - step_x,
                                                      step_y+(step_vertex+space_vertex) *Math.floor(middle / 2)  - space_vertex/4,
                                                      step_x+space_vertex*2+size_vertex*0.2,
                                                      step_y+(step_vertex+space_vertex) *Math.floor(middle / 2)  + space_vertex+step_y)
                                    ctx.lineTo(step_x+space_vertex*2+size_vertex*0.2 - step_x,
                                               step_y+(step_vertex+space_vertex) *Math.floor(middle / 2)  + space_vertex-step_y)
                                    ctx.moveTo(step_x+space_vertex*2+size_vertex*0.2,
                                               step_y+(step_vertex+space_vertex) *Math.floor(middle / 2)  + space_vertex+step_y)
                                    ctx.lineTo(step_x+space_vertex*2+size_vertex*0.2 + step_x,
                                               step_y+(step_vertex+space_vertex) *Math.floor(middle / 2)  + space_vertex-step_y)

                                    for(j = 0, lenght_j = alphabet_size; j < lenght_j; j++)
                                    {
                                        temp = graph_canvas.graph["data"][i]["value"][j]["symbol"];
                                        if(temp !== ti_end.text[0]){
                                            ctx.text(temp,
                                                     step_x*2+space_vertex*2+size_vertex*0.2 *j,
                                                     step_y+(step_vertex+space_vertex) *Math.floor(middle / 2)  - space_vertex/6)
                                        }
                                    }


                                    //выходящая стрелка
                                    ctx.moveTo(step_x+space_vertex*2+size_vertex*0.8,
                                               step_y+(step_vertex+space_vertex) *Math.floor(middle / 2)  + space_vertex + step_y)
                                    ctx.lineTo(step_x+space_vertex*2+size_vertex*2.5,
                                               step_y+space_vertex+step_y*6)
                                    ctx.lineTo(step_x+space_vertex*2+size_vertex*2.5-step_x/2,
                                               step_y+space_vertex+step_y*8)
                                    ctx.moveTo(step_x+space_vertex*2+size_vertex*2.5,
                                               step_y+space_vertex+step_y*6)
                                    ctx.lineTo(step_x+space_vertex*2+size_vertex*2.5 - step_x,
                                               step_y+space_vertex+step_y*6)
                                    ctx.text(ti_end.text[0],
                                             space_vertex*2+size_vertex,
                                             (step_vertex+space_vertex)*Math.floor(middle / 2) + space_vertex - step_y)
                                    //кольцевая стрелка вокруг начала выходной цепочки
                                    ctx.moveTo(step_x+step_vertex*4+size_vertex*0.7,
                                               step_y+ space_vertex + step_y/2)
                                    ctx.bezierCurveTo(step_x+step_vertex*4+size_vertex*0.7 + step_x,
                                                      step_y  + space_vertex/6,
                                                      step_x+step_vertex*4+size_vertex*0.2 - step_x,
                                                      step_y  + space_vertex/6,
                                                      step_x+step_vertex*4+size_vertex*0.2,
                                                      step_y + space_vertex+step_y)
                                    ctx.lineTo(step_x+step_vertex*4+size_vertex*0.2 - step_x,
                                               step_y + space_vertex-step_y)
                                    ctx.moveTo(step_x+step_vertex*4+size_vertex*0.2,
                                               step_y + space_vertex+step_y)
                                    ctx.lineTo(step_x+step_vertex*4+size_vertex*0.2 + step_x,
                                               step_y + space_vertex-step_y)
                                    ctx.text(ti_end.text[0],
                                             step_x+step_vertex*4+size_vertex*0.2 + step_x,
                                             step_vertex/2 - step_y /2)

                                    for(i = 0, length = ti_end.text.length-1; i < length; i++)
                                    {
                                        ctx.ellipse(step_x+step_vertex*4,
                                                    step_y+(step_vertex+space_vertex)*i+space_vertex,
                                                    size_vertex,
                                                    size_vertex)
                                        ctx.text(graph_canvas.graph["data"][(ti_start.text.length+1)+i]["key"],
                                                 step_x+step_vertex*4+size_vertex/2.8,
                                                 step_y+(step_vertex+space_vertex)*i+space_vertex + size_vertex/1.8)
                                        //соединение со следующим элементом
                                        ctx.moveTo(step_x+step_vertex*4+size_vertex/2,
                                                   step_y+(step_vertex+space_vertex)*i + space_vertex+size_vertex)
                                        ctx.lineTo(step_x+step_vertex*4+size_vertex/2,
                                                   step_y+(step_vertex+space_vertex)*(i+1)+ space_vertex)
                                        ctx.lineTo(step_x+step_vertex*4 + step_x+size_vertex/2,
                                                   step_y+(step_vertex+space_vertex)*(i+1)+ space_vertex - step_y*2)
                                        ctx.moveTo(step_x+step_vertex*4+size_vertex/2,
                                                   step_y+(step_vertex+space_vertex)*(i+1)+ space_vertex)
                                        ctx.lineTo(step_x+step_vertex*4 - step_x+size_vertex/2,
                                                   step_y+(step_vertex+space_vertex)*(i+1)+ space_vertex - step_y*2)

                                        ctx.text(ti_end.text[i+1],
                                                 step_x+step_vertex*4+size_vertex/2 + step_x,
                                                 step_y+(step_vertex+space_vertex)*i + space_vertex+size_vertex+step_y*2)

                                        //соединение со срединным
                                        ctx.moveTo(step_x+step_vertex*4+ size_vertex/8,
                                                   step_y+ (step_vertex + space_vertex)*i + size_vertex*2 + step_y)
                                        ctx.lineTo(step_x+space_vertex*2+size_vertex,
                                                   step_y+(step_vertex+space_vertex) *Math.floor(middle / 2)  + space_vertex + step_y*3)

                                        for(j = 0, lenght_j = alphabet_size; j < lenght_j; j++)
                                        {
                                            temp = graph_canvas.graph["data"][(ti_start.text.length+1)+i]["value"][j]["symbol"];
                                            if(temp !== ti_end.text[0] && temp !== ti_end.text[i+1]){
                                                ctx.text(temp,
                                                         step_x+step_vertex*4+ size_vertex/8 - size_vertex*0.2 *j,
                                                         step_y*4+ (step_vertex + space_vertex)*i + size_vertex*2)
                                            }
                                        }
                                        //соединение с началом цепочки
                                        if(i !== 0){
                                            ctx.moveTo(step_vertex*4+ size_vertex,
                                                       step_y+ (step_vertex + space_vertex)*i + size_vertex*2 + step_y)
                                            ctx.bezierCurveTo(step_x+step_vertex*4+ size_vertex+step_x*3,
                                                              step_y+ (step_vertex + space_vertex)*i + size_vertex*2 + step_y,
                                                              step_x+step_vertex*4+ size_vertex+step_x*3,
                                                              step_y+ (step_vertex + space_vertex)*i,
                                                              step_x+step_vertex*4+ size_vertex,
                                                              space_vertex - step_y*2 + size_vertex)
                                            ctx.text(ti_end.text[0],
                                                     step_vertex*4+ size_vertex + step_x*1.25,
                                                     step_y+ (step_vertex + space_vertex)*i + size_vertex*2 + step_y*2)
                                        }
                                    }

                                    ctx.ellipse(step_x+step_vertex*4,
                                                step_y+(step_vertex+space_vertex)*i + space_vertex,
                                                size_vertex,
                                                size_vertex)
                                    ctx.ellipse(step_x+sheight/2+step_vertex*4,
                                                step_y+(step_vertex+space_vertex)*i + space_vertex+sheight/2,
                                                size_vertex-sheight,
                                                size_vertex-sheight)
                                    ctx.text("qf",
                                             step_x+step_vertex*4+size_vertex/2.8,
                                             step_y+(step_vertex+space_vertex)*i+space_vertex+ size_vertex/1.8)
                                    //соединение с серединой элемента
                                    ctx.moveTo(step_x+step_vertex*4+ size_vertex/8,
                                               step_y+ (step_vertex + space_vertex)*i + size_vertex*2 + step_y)
                                    ctx.lineTo(step_x+space_vertex*2+size_vertex,
                                               step_y+(step_vertex+space_vertex) *Math.floor(middle / 2)  + space_vertex + step_y*3)
                                    for(j = 0, lenght_j = alphabet_size; j < lenght_j; j++)
                                    {
                                        temp = graph_canvas.graph["data"][(ti_start.text.length+1)+i]["value"][j]["symbol"];
                                        if(temp !== ti_end.text[0] && temp !== ti_end.text[i+1]){
                                            ctx.text(temp,
                                                     step_x+step_vertex*4+ size_vertex/8 - size_vertex*0.2 *j,
                                                     step_y*4+ (step_vertex + space_vertex)*i + size_vertex*2)
                                        }
                                    }
                                    //дуга на начало цепочки
                                    ctx.moveTo(step_vertex*4+ size_vertex,
                                               step_y+ (step_vertex + space_vertex)*i + size_vertex*2 + step_y)
                                    ctx.bezierCurveTo(step_x+step_vertex*4+ size_vertex+step_x*3,
                                                      step_y+ (step_vertex + space_vertex)*i + size_vertex*2 + step_y,
                                                      step_x+step_vertex*4+ size_vertex+step_x*3,
                                                      step_y+ (step_vertex + space_vertex)*i,
                                                      step_x+step_vertex*4+ size_vertex,
                                                      space_vertex - step_y*2 + size_vertex)
                                    ctx.text(ti_end.text[0],
                                             step_vertex*4+ size_vertex + step_x*1.25,
                                             step_y+ (step_vertex + space_vertex)*i + size_vertex*2 + step_y*2)
                                }






                                ctx.stroke();
                                ctx.closePath();
                            }
                        }
                    }


                    Rectangle
                    {
                        id: table_box
                        width: swidth*50
                        height: sheight*50
                        color: "white"
                        visible: false
                        ColumnLayout {
                            anchors.fill: table_box
                            spacing: 0

                            TableView{
                                id: table
                                width: table_box.width
                                height: table_box.height
                                clip: true
                                boundsBehavior:Flickable.StopAtBounds
                                columnWidthProvider:
                                    (column)=>{
                                        if(column === 0){return swidth * 18}
                                        else{
                                            return swidth * 5
                                        }
                                    }
                                model: table_model
                                selectionModel: ItemSelectionModel
                                {
                                    model: table_model
                                }
                                ScrollBar.vertical: ScrollBar {
                                    policy: ScrollBar.AsNeeded
                                    active: true
                                    onActiveChanged: {
                                        if (!active)
                                            active = true;
                                    }
                                }
                                ScrollBar.horizontal: ScrollBar{
                                    policy: ScrollBar.AsNeeded
                                    active: true
                                    onActiveChanged: {
                                        if (!active)
                                            active = true;
                                    }
                                }

                                delegate: Rectangle {

                                    implicitHeight: sheight * 4.2407
                                    border.color: "#EBEBEB"
                                    border.width: swidth * 0.1041

                                    color: "white"
                                    Text {
                                        id: cellText
                                        text: display
                                        anchors.verticalCenter: parent.verticalCenter
                                        x: swidth * 0.2082
                                    }
                                    /*MouseArea{
                                        anchors.fill: parent
                                        onClicked: {
                                            current_row = row
                                            setInfoInInfoBox(true)
                                        }
                                    }*/

                                }

                            }
                        }
                    }
                }

            }


        }
        Button{

            width: swidth * 20
            height: sheight *5
            anchors.left: plane_tools.left
            anchors.bottom: plane_tools.bottom
            id: start_generate
            text:"Сгенерировать"
            onClicked:{
                main_screen.startGenerated(ti_change.displayText)
            }
        }
    }
    Rectangle{
        id: plane_view
        width: parent.width/2
        height: sheight*95
        anchors.top: toolbar.bottom
        anchors.right: parent.right
        border.color: "lightgray"
        border.width: 1
        TextEdit{
            id: te_result
            wrapMode: TextEdit.Wrap
            width:parent.width
            height: parent.height
            anchors.left: parent.left
            anchors.right: parent.right
        }
    }
}
