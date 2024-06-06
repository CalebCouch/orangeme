function hello(string) {
    return "hello"+string;
}

function sendBack() {
   messageHandler.postMessage("Hello from JS");
}

function runner() {
    sendMessage("increment", "{}");
    runner();
}

sendMessage("increment", "{}")
//runner()
