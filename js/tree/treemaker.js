var exports = {};

(function() {
    var stackFrameRegex, currentTrace;
    stackFrameRegex = /(\S+):\s+(\d+):[\s\S]+([><]+)(\S+)/;

    function buildTree(lines) {
        currentTrace = [{name:'root', children:[]}];
        lines.forEach(function(line){processLine(line)});
        return currentTrace;
    }

    function processLine(line) {
        var splits;
        line = $.trim(line);
        splits = stackFrameRegex.exec(line);
        if (splits) {
            processEntry(splits[1], splits[2], splits[3], splits[4]);
        }
    }

    function processEntry(fileName, lineNumber, entryExitIndicator, methodName) {
        var method;
        switch(entryExitIndicator) {
        case '>':
            method = {name:methodName + '@' + fileName+':'+lineNumber, children:[]};
            currentTrace[currentTrace.length - 1].children.push(method);
            currentTrace.push(method);
            break;
        case '<':
            currentTrace.splice(-1, 1);
            break;
        default:
            throw "Unknow indicator " + entryExitIndicator;
        }
    }

    var processor = {};
    processor.buildTree = buildTree;
    exports['CallTraceProcessor'] = processor;
})();
