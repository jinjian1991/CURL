//创建了一个可以供外面的人调用的sayHi方法
exports.sayHi = function(){
    console.log('Hi,wrold');
    
    testBridgeMethod();
}


global.testBridgeMethod = () => {
    console.log("global.testBridgeMethod");
}
