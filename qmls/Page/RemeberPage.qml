import QtQuick 2.0
import QtQuick.Controls 2.5
import "../Component"

Page {
    id: page3
    anchors.fill: parent
    opacity: 0
    visible: opacity > 0
    property var currentWord: -1
    property real wordNum: 10       //此次需背的新单词
    property var englishword:[]
    property var chinesemena:[]
    property var tmpdiffer: 1
    property var mdifficulty: 1
    property var merrorNum: 0       //上次错误的单词
    property var isGetWord: false
    property var yesnum: 0

    //编辑结束信号
    signal endWrite()

    //难度占比
    property var diffratio: [[0.7,0.15,0.1,0.05],
        [0.6,0.15,0.15,0.1],
        [0.5,0.2,0.2,0.1],
        [0.3,0.3,0.2,0.2],
        [0.1,0.4,0.25,0.25],
        [0.1,0.3,0.3,0.3],
        [0.1,0.1,0.4,0.4]]

    function getLevel(){
        if(root.userSno == -1) return 0
        switch(root.userType){
        case "小学生":return 0;
        case "初中生":return 1;
        case "高中生":return 2;
        case "大学生":return 3;
        case "研究生":
        case "上班族":return 4;
        }
    }

    Rectangle{
        anchors.fill: parent
        z: 0
        color: "#eccfd7"
    }
    //头部红色背景
    PageHeader{
        id:header
    }

    Component.onCompleted: {
        console.log("The page is load!!!")
        var lis = wordDB.getDiffer(root.userSno);
        wordNum = lis[0]
        mdifficulty = lis[1]
        console.log("read from db is = " , wordNum , " and ",mdifficulty)
    }

    onVisibleChanged: {
        if(visible == false){
            setTime.stop()
            currentWord = -1
            englishTxt.text = ""
            chineseTxt2.text = ""
            chineseTxt.text = ""
            viewStatus(true)
            startBtn.source = "../../assets/mdpi/start.png"
            startBtn.istart = false
        }
    }

    //下拉框
    MyComboBox{
        id:combox
        model: ["单词背诵","单词默写"]
        anchors{
            left: parent.left
            leftMargin: dp(3)
            verticalCenter: header.verticalCenter
        }
        onCurrentIndexChanged: {
            currentWord = -1
            englishTxt.text = ""
            chineseTxt2.text = ""
            chineseTxt.text = ""
            if(currentIndex == 0)
            {
                switchAni.testt = true
                switchAni.start()
            }
            else if(currentIndex == 1)
            {
                switchAni.testt = false
                switchAni.start()
            }
        }
    }


    //制定策略按钮
    Rectangle{
        id:setRec
        width: parent.width / 4
        height:  header.height * 0.6
        color: "#eeb646"
        radius: dp(3)
        anchors{
            right: parent.right
            rightMargin: dp(3)
            verticalCenter: header.verticalCenter
        }
        Text {
            anchors.centerIn: parent
            text: "设置策略"
            color: "white"
            font.pixelSize: dp(4)
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                maskRec.visible = true
                sRec.visible = true
            }
        }
    }

    Rectangle{
        id:maskRec
        opacity: 0.2
        color: "black"
        anchors.fill: parent
        visible: false
        z:2
        MouseArea{
            anchors.fill: parent
            onPressed: {
                if(visible)
                    mouse.accepted = true
                else mouse.accepted = false
            }
            onClicked: {
                sRec.visible = false
                maskRec.visible = false
            }
        }
    }

    //策略设置局面
    Rectangle{
        id:sRec
        width: parent.width
        height: parent.height / 3
        color: "#F1DDDD"
        visible: false
        anchors{
            top: header.bottom
        }
        z:99
        MouseArea{
            anchors.fill: parent
            onPressed: {
                if(visible) mouse.accepted = true
                else mouse.accepted = false
            }
        }

        //保存按钮
        //制定策略按钮
        Rectangle{
            id:saveRec
            width: parent.width / 5
            height:  header.height * 0.55
            color: allColor
            radius: dp(3)
            anchors{
                top: parent.top
                topMargin: dp(3)
                horizontalCenter: parent.horizontalCenter
            }
            Text {
                anchors.centerIn: parent
                text: "保 存"
                color: "white"
                font.pixelSize: dp(4)
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    page3.wordNum = setSp.value;
                    mdifficulty = tmpdiffer;
                    if(root.userSno != -1)
                        wordDB.setDiffer(root.userSno,setSp.value,mdifficulty);
                    sRec.visible = false
                    maskRec.visible = false
                    root.showMsgHint("保存成功")
                    isGetWord = false
                }
            }
        }

        Column{
            id:ro
            width: parent.width * 0.8
            height: parent.height * 0.6
            anchors{
                top: saveRec.bottom
                topMargin: dp(3)
                horizontalCenter: parent.horizontalCenter
            }
            spacing: dp(2)

            //设置单词个数
            Rectangle{
                width: parent.width
                height: parent.height * 0.4
                color: "transparent"
                Rectangle{
                    id:wrec
                    width: parent.width / 3
                    height: parent.height
                    color: "transparent"
                    Text {
                        id: wtxt
                        anchors.centerIn: parent
                        text: "单词个数:"
                        font.pixelSize: dp(5)
                    }
                }
                SpinBox{
                    id:setSp
                    width: parent.width / 2
                    height: parent.height * 0.8
                    value: 20
                    from: 10
                    to: 100
                    stepSize: 5
                    anchors{
                        left:wrec.right
                        leftMargin: dp(3)
                        top: parent.top
                        topMargin: (parent.height - setSp.height) / 2
                    }
                    font.pixelSize: dp(5)
                }
            }

            //难度设置
            Rectangle{
                width: parent.width
                height: parent.height * 0.4
                color: "transparent"
                Rectangle{
                    id:nrec
                    width: parent.width / 3
                    height: parent.height
                    color: "transparent"
                    Text {
                        id: ntxt
                        anchors.centerIn: parent
                        text: "单词难度:"
                        font.pixelSize: dp(5)
                    }
                }
                //图形排列
                Row{
                    id:imgRow
                    anchors{
                        left: nrec.right
                        leftMargin: dp(3)
                    }
                    height: parent.height
                    width: setSp.width * 0.8
                    spacing: dp(3)

                    Image {
                        id: star1
                        source: mdifficulty > 0 ? "../../assets/mdpi/diff_red.png" : "../../assets/mdpi/diff_grey.png"
                        height: parent.height * 0.6
                        fillMode: Image.PreserveAspectFit
                        anchors{
                            top: parent.top
                            topMargin: (parent.height - star1.height) / 2
                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                parent.source = "../../assets/mdpi/diff_red.png"
                                star2.source = "../../assets/mdpi/diff_grey.png"
                                star3.source = "../../assets/mdpi/diff_grey.png"
                                diffTxt.text = "简单"
                                tmpdiffer = 1;
                            }
                        }
                    }
                    Image {
                        id: star2
                        source: mdifficulty > 1 ? "../../assets/mdpi/diff_red.png" : "../../assets/mdpi/diff_grey.png"
                        height: parent.height * 0.6
                        fillMode: Image.PreserveAspectFit
                        anchors{
                            top: parent.top
                            topMargin: (parent.height - star1.height) / 2
                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                parent.source = "../../assets/mdpi/diff_red.png"
                                star1.source = "../../assets/mdpi/diff_red.png"
                                star3.source = "../../assets/mdpi/diff_grey.png"
                                diffTxt.text = "一般"
                                tmpdiffer = 2;
                            }
                        }
                    }
                    Image {
                        id: star3
                        source: mdifficulty > 2 ? "../../assets/mdpi/diff_red.png" : "../../assets/mdpi/diff_grey.png"
                        height: parent.height * 0.6
                        fillMode: Image.PreserveAspectFit
                        anchors{
                            top: parent.top
                            topMargin: (parent.height - star1.height) / 2
                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                parent.source = "../../assets/mdpi/diff_red.png"
                                star1.source = "../../assets/mdpi/diff_red.png"
                                star2.source = "../../assets/mdpi/diff_red.png"
                                diffTxt.text = "困难"
                                tmpdiffer = 3;
                            }
                        }
                    }
                }
                //显示难度
                Rectangle{
                    color: "transparent"
                    anchors{
                        left: imgRow.right
                        right: parent.right
                    }
                    height: parent.height
                    Text {
                        id: diffTxt
                        anchors.centerIn: parent
                        color: "red"
                        font.pixelSize: dp(4)
                        text: ""
                    }
                }
            }

        }
        onVisibleChanged: {
            if(visible)
            {
                setSp.value = wordNum
                console.log("The mdifficult is = ",mdifficulty)
                if(mdifficulty > 0) star1.source = "../../assets/mdpi/diff_red.png"
                else star1.source = "../../assets/mdpi/diff_grey.png"
                if(mdifficulty > 1) star2.source = "../../assets/mdpi/diff_red.png"
                else star2.source = "../../assets/mdpi/diff_grey.png"
                if(mdifficulty > 2) star3.source = "../../assets/mdpi/diff_red.png"
                else star3.source = "../../assets/mdpi/diff_grey.png"
                if(mdifficulty == 1) diffTxt.text ="简单";
                else if(mdifficulty == 2) diffTxt.text ="一般"
                else diffTxt.text = "困难"
            }
        }

    }

    //微调控件
    Text {
        text: "设置单词间隔时间（单位秒）"
        anchors{
            bottom:sp.top
            bottomMargin: dp(2)
            horizontalCenter: sp.horizontalCenter
        }
    }
    SpinBox{
        id:sp
        width: parent.width * 0.4
        height: setRec.height
        value: 5
        stepSize: 5
        from: 5
        to: 60
        anchors{
            top: header.bottom
            topMargin: dp(10)
            left: parent.left
            leftMargin: (parent.width - sp.width) / 2
        }
    }

    Rectangle{
        anchors.top: header.bottom;
        anchors.bottom: sp.bottom
        width: parent.width
        color: "white"
        visible: resultRec.visible
        Text {
            anchors.centerIn: parent
            text: "点击关闭"
            font.pixelSize: dp(4)
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                resultRec.visible = false
            }
        }
    }

    ///整体作一个可滑动页面
    Flickable {
        id: inner
        clip: true

        anchors{
            top: sp.bottom
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
        }
        flickableDirection: Flickable.VerticalFlick; //只允许垂直滑动
        width: parent.width;
        contentWidth: parent.width * 2;
        contentHeight: dp(200)
        contentX: parent.width;


        //-----------------------------------右窗口显示------------------------------------
        //单词默写（全词默写）
        Rectangle{
            color: "transparent"
            height: parent.height
            width: page3.width
            x:page3.width
            anchors{
                top: parent.top
                left: parent.left
                leftMargin: page3.width
            }

            Rectangle
            {
                id:resultRec
                visible: false
                anchors.fill: parent
                color: "#F1DDDD"
                //结果显示界面
                ListView
                {
                    id:resultList
                    anchors.fill: parent
                    spacing: 2
                    model: ListModel{
                        id:mymodel
                    }
                    delegate: Rectangle{
                        z: 99
                        height: dp(15)
                        width: parent.width
                        color:myanswer == trueanswer ? "#F1DDDD" : "#FFEFD5"
                        Text {
                            id: myanswerT
                            text: myanswer
                            height: parent.height * 0.2
                            width: parent.width
                            color: myanswerT.text == trueanswerT.text ? "green" : "red"
                            anchors{
                                left: parent.left
                                leftMargin: dp(3)
                                top: parent.top
                                topMargin: dp(2)
                            }
                        }
                        Text {
                            id:trueanswerT
                            text: trueanswer
                            height:myanswerT.height
                            width: myanswerT.width
                            anchors{
                                top: myanswerT.bottom
                                topMargin: dp(1)
                                left: parent.left
                                leftMargin: dp(3)
                            }
                        }
                        Text {
                            id:chineT
                            text: chine
                            height:myanswerT.height
                            width: myanswerT.width
                            anchors{
                                top: trueanswerT.bottom
                                topMargin: dp(1)
                                left: parent.left
                                leftMargin: dp(3)
                            }
                        }
                    }
                }
                z:97
            }



            //开始测试按钮
            Rectangle{
                id:startRec
                width: parent.width / 4
                height:  header.height * 0.6
                color: allColor
                radius: dp(3)
                anchors{
                    top: parent.top
                    topMargin: dp(10)
                    horizontalCenter: parent.horizontalCenter
                }
                Text {
                    anchors.centerIn: parent
                    text: "开始测试"
                    color: "white"
                    font.pixelSize: dp(4)
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        if(!isGetWord)
                        {
                            isGetWord = true
                            getTestWord()
                        }
                        root.writeWord = []
                        yesnum = 0
                        setTime.interval = sp.value * 1000
                        showTxt(++currentWord)
                        setTime.start()
                        viewStatus(false)
                    }
                }
            }

            //只为计算长度
            Text {
                id: tmpt
                text: chineseTxt2.text
                font.pixelSize: dp(6)
                visible: false
            }

            //中文释义
            Rectangle{
                id:chinesRec
                width: page3.width * 0.8
                height:chineseTxt2.height > parent.height * 0.15 ? chineseTxt2.height : parent.height * 0.15
                color: "#FFF0F5"
                anchors{
                    top: parent.top
                    topMargin: dp(35)
                    horizontalCenter: parent.horizontalCenter
                }
                Text {
                    id:chineseTxt2
                    anchors.centerIn: parent
                    width: tmpt.contentWidth > parent.width ? parent.width :tmpt.width
                    text: ""
                    font.pixelSize: dp(6)
                    color: "black"
                    wrapMode:Text.Wrap
                }
            }

            //输入框
            TextField{
                id:tFied
                clip: false
                width: parent.width * 0.8
                height: parent.height * 0.05
                font.pixelSize: dp(4)
                background: Rectangle{
                    color: "transparent"
                }
                anchors{
                    top: chinesRec.bottom
                    topMargin: dp(5)
                    horizontalCenter: parent.horizontalCenter
                }
            }
            //下划线
            Rectangle{
                height: 1
                width: tFied.width
                color: "grey"
                anchors{
                    top:tFied.bottom
                    horizontalCenter: parent.horizontalCenter
                }
            }
        }

        //-----------------------------------right ending---------------------------------





        //-----------------------------------左窗口显示-------------------------------------
        //显示单词框
        //只为获取长度
        Text{
            id:engxx
            visible: false
            font.pixelSize: dp(8)
        }

        Rectangle{
            id:sowRec
            x:0
            width: page3.width * 0.8
            height: parent.height * 0.15
            color: "#FFF0F5"
            anchors{
                top: parent.top
                topMargin: dp(15)
                left: parent.left
                leftMargin: page3.width * 0.1
            }
            Text {
                id:englishTxt
                width: engxx.contentWidth > parent.width ? parent.width : engxx.contentWidth
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                text: ""
                font.pixelSize: dp(8)
                color: "black"
                wrapMode:Text.Wrap
            }
        }

        Row{
            id:r1
            width: sowRec.width * 0.6
            anchors{
                top: sowRec.bottom
                topMargin: dp(3)
                horizontalCenter: sowRec.horizontalCenter
            }
            spacing: dp(5)

            Image {
                id: pre
                source: "../../assets/mdpi/prefer.png"
                width: dp(10)
                fillMode:Image.PreserveAspectFit
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        if(currentWord > 0)
                            showTxt(--currentWord)
                    }
                }
            }

            Image {
                id: startBtn
                source: "../../assets/mdpi/start.png"
                width: dp(10)
                fillMode: Image.PreserveAspectFit
                property var istart: false
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        console.log("click the start..")
                        parent.source = parent.istart ? "../../assets/mdpi/start.png" : "../../assets/mdpi/stop.png"
                        parent.istart = !parent.istart
                        if(parent.istart)
                        {
                            setTime.interval = sp.value * 1000
                            if(!isGetWord)
                            {
                                getTestWord()
                                isGetWord = true
                            }
                            showTxt(++currentWord)
                            setTime.start()
                            viewStatus(false)
                        }
                        else
                        {
                            setTime.stop()
                            viewStatus(true)
                        }

                    }
                }
            }
            Image {
                id: nextBtn
                source: "../../assets/mdpi/next.png"
                width: dp(9.5)
                fillMode: Image.PreserveAspectFit
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        if(currentWord < englishword.length - 1)
                            showTxt(++currentWord)
                    }
                }
            }
        }

        Row{
            id:r2
            width: sowRec.width * 0.6
            anchors{
                top: r1.bottom
                topMargin: dp(3)
                horizontalCenter: sowRec.horizontalCenter
            }
            spacing: dp(5)

            Image {
                id: falsebtn
                source: "../../assets/mdpi/false.png"
                width: dp(9.5)
                fillMode:Image.PreserveAspectFit
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        if(root.userSno == -1) return
                        console.log("current word is = ",englishword[currentWord])
                        wordDB.setLastMistake(root.userSno,englishword[currentWord],1)
                        wordDB.setAccuracy(root.userSno,englishword[currentWord],false)
                        root.showMsgHint("已标记")
                    }
                }
            }

            Image {
                id: anserBtn
                source: "../../assets/mdpi/noshowanswer.png"
                width: dp(10)
                fillMode: Image.PreserveAspectFit
                property var isshow: false
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        parent.source = parent.isshow ? "../../assets/mdpi/noshowanswer.png" : "../../assets/mdpi/showanser.png"
                        parent.isshow = !parent.isshow
                    }
                }
            }

            Image {
                id: rightBtn
                source: "../../assets/mdpi/right.png"
                width: dp(9.5)
                fillMode: Image.PreserveAspectFit
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        if(root.userSno == -1) return
                        console.log("current word is = ",englishword[currentWord])
                        wordDB.setLastMistake(root.userSno,englishword[currentWord],0)
                        wordDB.setAccuracy(root.userSno,englishword[currentWord],true)
                        root.showMsgHint("已标记")
                    }
                }
            }
        }

        //答案显示框
        Rectangle{
            id:answerRec
            visible: anserBtn.isshow
            width: page3.width * 0.8
            height: chineseTxt.height > parent.height * 0.15 ? chineseTxt.height : parent.height * 0.15
            color: "#FFF0F5"
            anchors{
                top: r2.bottom
                topMargin: dp(10)
                horizontalCenter: sowRec.horizontalCenter
            }
            Text {
                id:chineseTxt
                anchors.centerIn: parent
                width: tmpt.contentWidth > parent.width ? parent.width :tmpt.width
                text: ""
                font.pixelSize: dp(6)
                color: "black"
                wrapMode:Text.Wrap
            }
        }
        //--------------------------------left ending------------------------

        PropertyAnimation {
            id: switchAni;
            property var testt: false
            target: inner;
            property: "contentX";
            from: switchAni.testt ? parent.width : 0;
            to:switchAni.testt ?  0 : parent.width;
            duration: 150;
            easing.type: Easing.OutQuart;
        }
    }

    Timer{
        id:setTime
        interval: 5000 //设置定时器定时时间，默认为1000
        repeat: true //是否重复定时，默认为false
        running: false
        onTriggered: {
            if(combox.currentIndex == 1)
                endWrite();
            ++currentWord;
            //结束
            if(currentWord >= wordNum + merrorNum)
            {
                startBtn.source = "../../assets/mdpi/start.png"
                startBtn.istart = false
                setTime.stop()
                englishTxt.text = "";
                engxx.text = "";
                chineseTxt.text = "";
                chineseTxt2.text = "";
                viewStatus(true)
                currentWord = -1
                if(combox.currentIndex == 1){
                    getResult();
                    resultRec.visible = true
                    if(root.userSno == -1) return
                    //记录本次测试结果
                    var currenTime = dateManager.getCurrenTime()
                    console.log("current time is = ",currenTime);
                    dateManager.insetRecord(root.userSno,currenTime,wordNum + merrorNum,yesnum)
                    root.finishTest()
                }
            }
            else showTxt(currentWord)
        }
    }

    onEndWrite:{
        console.log("The current index is = ",currentWord,"  and  ",tFied.text)
        root.writeWord.push(tFied.text);
        if(tFied.text != englishword[currentWord])
        {
            if(root.userSno == -1){
                tFied.text = ""
                return
            }
            wordDB.setLastMistake(root.userSno,englishword[currentWord],1)
            wordDB.setAccuracy(root.userSno,englishword[currentWord],false)
        }
        else
        {
            ++yesnum;
            if(root.userSno == -1){
                tFied.text = ""
                return
            }
            wordDB.setLastMistake(root.userSno,englishword[currentWord],0)
            wordDB.setAccuracy(root.userSno,englishword[currentWord],true)
        }

        tFied.text = ""
    }

    //收集被测试单词
    function getTestWord()
    {
        var tmp = getLevel() + mdifficulty - 1;
        englishword = []
        chinesemena = []
        currentWord = -1
        merrorNum = 0
        var res = wordDB.rememberWord(root.userSno,page3.wordNum,diffratio[tmp][0],diffratio[tmp][1],diffratio[tmp][2],diffratio[tmp][3]);
        console.log("The test number is = ",page3.wordNum)
        for(var i = 0 ;i < page3.wordNum ; ++i)
        {
            var tmpWord = res[i].split('&');
            englishword.push(tmpWord[0]);
            chinesemena.push(tmpWord[1]);
        }
        //上一次错误单词
        if(root.userSno == -1) return
        var tmpw = wordDB.lastErrorWord(root.userSno);
        for( ; tmpw[merrorNum] != undefined ; ++merrorNum){
            var tm = tmpw[merrorNum].split('&');
            englishword.push(tm[0]);
            chinesemena.push(tm[1]);
        }
    }

    function showTxt(index)
    {
        if(index >= wordNum)
        {
            englishTxt.color = "red"
            chineseTxt2.color = "red"
        }
        else {
            englishTxt.color = "black"
            chineseTxt2.color = "black"
        }
        englishTxt.text = englishword[index];
        engxx.text = englishword[index];
        chineseTxt.text = chinesemena[index];
        chineseTxt2.text = chinesemena[index];
    }

    //选框的状态
    function setSpStatus(status)
    {
        if(!status)
        {
            sp.from = sp.value
            sp.to = sp.value
        }
        else{
            sp.from = 5
            sp.to = 60
        }
    }

    //界面剩余按钮状态
    function viewStatus(status)
    {
        combox.enabled = status;
        setRec.enabled = status
        setSpStatus(status)
        startRec.enabled = status
    }

    function getResult(){
        mymodel.clear();
        for(var i = 0; i < wordNum + merrorNum ; ++i)
        {
            mymodel.append({"myanswer":root.writeWord[i],"trueanswer":englishword[i],"chine":chinesemena[i]})
        }
    }
}
