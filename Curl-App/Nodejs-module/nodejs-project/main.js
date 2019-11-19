var express = require('express');
const vm = require('vm');
const fetch = require('node-fetch');
const { parseCurl } = require('./parser');

// Swift传值
var postCurl = "";

var test = require('./swiftjsbridge');

// test
global.testMethod = (aStatus) => {
    console.log("global.testMethod");
    console.log("aStatus:" + aStatus);
}

global.getStatus = (aStatus) => {
    console.log("getStatus_aStatus:" + aStatus);
    
//    jsToswift_pushData(aStatus);
}


// fetch 请求 js 代码的模版
var jsCodeModle = `
var run = async (jsonObj) => {
        var url = jsonObj["url"];
        delete jsonObj['url'];
        var props = jsonObj;
        cllbackJsCodeRunStart();
        try {
                const response = await fetch(url, props)
                console.log("-----------status-------------")
                console.log(response.status)
                console.log("-----------header-------------")
                // test Method
                getStatus(response.status);
                for (var pair of response.headers.entries()) {
                        console.log(pair[0] + ': ' + pair[1]);
                }
                const body = await response.text(); // 除非是后面要读取键值，否则只用作显示的化 text 结果是一样的。
                console.log("-----------body-------------")
                console.log(body)
        } catch (error) {
                console.log("-----------error-------------")
                console.log(error.message);
        }
        console.log("-----------end-------------")
        cllbackJsCodeRunEnd();
}
run(curlObj);
`

// 全局变量用作保存待回复的 Response
var stringForResponse = "";

// 全局变量用作和 vm 通信
global.curlObj = {};
global.fetch = fetch;
global.print = (message) => {
        stringForResponse = stringForResponse + message + "/n";
        console.log(message);
};

global.cllbackJsCodeRunStart = () => {
        console.log("cllbackJsCodeRunStart");
        stringForResponse = "";
}
global.cllbackJsCodeRunEnd = () => {
        console.log("cllbackJsCodeRunEnd");
        // console.log(stringForResponse);

        if (responseToGiveBack !== null) {
                responseToGiveBack.json({ data: stringForResponse });
                responseToGiveBack = null;
        }
}

//开启一个小服务器，为 app 服务。app 会调用 api 把 curl 命令字符串传递过来，执行结果作为 response 返回。
var express = require('express')
var app = express()
app.use(express.json()) // for parsing application/json
app.use(express.urlencoded({ extended: true })) // for parsing application/x-www-form-urlencoded

var responseToGiveBack = null;
app.post('/curl', function (req, res, next) {

        // 只能同时服务一个请求
        if (responseToGiveBack !== null) {
                res.json({ error: "Waiting for last request. Try again later, or restart the app." });
                return;
        }

        //1. 从客户端的请求 body 拿到 curl 命令字符串
        //2. curl 转换 curlObj
        //3. curlObj 复制到全局变量 global.curlObj
        //4. 在虚拟机执行模版代码 jsCodeModle
        //5. 在执行完毕的地方，返回 response 给客户端
        var curlString = "";
        var curlObj = "";
        try {
                curlString = req.body['curl'];
                var curlObj = parseCurl(curlString, 0); //用 parseCurl 将 curl 命令解析成对象字典
                if (undefined === curlObj["headers"]["User-Agent"]){ // 添加我们自己的 User-Agent 头部
                        curlObj["headers"]["User-Agent"] = "curl app";
                }
        } catch (e) {
        }
        global.curlObj = curlObj;
        console.log(curlObj);
        responseToGiveBack = res; // 先全局变量收集起来，后续用
        jsCodeModle = jsCodeModle.replace(/console.log/g, "print");
        vm.runInThisContext(jsCodeModle);
})

app.listen(3000, function () {
        print('本地服务器端口 3000')
})
