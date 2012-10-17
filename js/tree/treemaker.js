var exports = {};

(function() {
    var callTraceRegex, currentTrace, backTraceMethodRegex, callTraceProcessor;
    callTraceRegex = /(\S+):\s+(\d+):[\s\S]+([><]+)(\S+)/;

    function buildTree(lines, callback) {
        currentTrace = [{name:'root', children:[]}];
        lines.forEach(function(line){callback.call(this, line)});
        return currentTrace;
    }

    function buildCallTraceTree(lines) {
        return buildTree(lines, processCallTraceLine);
    }

    function processCallTraceLine(line) {
        var splits;
        line = $.trim(line);
        splits = callTraceRegex.exec(line);
        if (splits) {
            processActivity(splits[1], splits[2], splits[3], splits[4]);
        }
    }

    // Processes a entry to exit call, entries have > and exits have <
    function processActivity(fileName, lineNumber, entryExitIndicator, methodName) {
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

    callTraceProcessor = {};
    callTraceProcessor.buildTree = buildCallTraceTree;
    exports['CallTraceProcessor'] = callTraceProcessor;

    backTraceMethodRegex = /#\d+  \S+ in (\S+) \S+/;
    backTraceSourceInfoRegex =   /\s+at \S+\/(\S+:\d+)/;
    
    function buildBackTraceTree(lines) {
        return buildTree(lines, processBackTraceLine);
    }
    function processBackTraceLine(line) {
        if (backTraceSourceInfoRegex.test(line)) {
            processSourceInfo(backTraceSourceInfoRegex.exec(line)[1]);
        } else if (backTraceMethodRegex.test(line)) {
            processMethodInfo(backTraceMethodRegex.exec(line)[1]);
        }
    }

    function processSourceInfo(sourceInfo) {
        var stackFrames = currentTrace[0].children;
        if (stackFrames.length > 0) {
            stackFrames[stackFrames.length - 1 ].name += '@'+sourceInfo;
        }
    }

    function processMethodInfo(methodName) {
        currentTrace[0].children.push({name:methodName});
    }

    backTraceProcessor = {};
    backTraceProcessor.buildTree = buildBackTraceTree;
    exports['BackTraceProcessor'] = backTraceProcessor;

    
})();
