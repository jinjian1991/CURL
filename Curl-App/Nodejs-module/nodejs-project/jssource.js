var helloWorld = "Hello World!"


function getFullname(firstname, lastname) {
    return firstname + " " + lastname;
}

function demoAlert(title, message) {
    // var truthBeTold = window.confirm("单击“确定”继续。单击“取消”停止。")
    // if (truthBeTold) {
    //     window.alert("欢迎访问我们的 Web 页！");
    // } else
    window.alert("再见啦！");
}

function generateLuckyNumbers() {
    console.log("This_if_consoleLog_from_js");
    console.log("test");
    
    var luckyNumbers = [];
    while (luckyNumbers.length != 6) {
        var randomNumber = Math.floor((Math.random() * 50) + 1);
 
        if (!luckyNumbers.includes(randomNumber)) {
            luckyNumbers.push(randomNumber);
        }
    }
 
    // call swift methods 1
    consoleLog(luckyNumbers);
    
    // call swift methods 2
    handleLuckyNumbers(luckyNumbers);
}
