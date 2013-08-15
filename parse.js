PEG = require("./peg.js");

function test(source) {
	console.log(source);
	var result = PEG.parse(source)[1];
	console.log("--result--");
	console.log(JSON.stringify(result, null, "  "));
}


test("* goal\n");
test("* goal");
test("* goal\ndesc");
test("* goal @hi @bye\ndesc");
test("* goal @task\ndesc\ntodo::");
test("* goal @task @test\ntodo::\n\tto: shida\n\t subject: hi\nticket::\n\tto: shida");
test("* goal @task @test\ndesc\ntodo::\n\tto: shida\n\t subject: hi\nticket::\n\tto: shida");
test("* goal\nhi\n*context\nhi");
test("* goal\nhi\n* context\nhi\ntodo::");
test("* goal\n*context");
test("* goal @task @test\ndesc\ntodo::\n\tto: shida\n\t subject: hi\nticket::\n\tto: shida\n*context\nhi");
test("* goal @task @test\ndesc\ntodo::\n\tto: shida\n\t subject: hi\nticket::\n\tto: shida\n*context\nhi\ntodo::");
test("* goal\n* strategy\n** goal\n**strategy\n***goal");
test("* goal\n* strategy\n** goal\n**strategy @test\n***goal");
test("* goal\n* strategy\n** goal\ntest\n**strategy @test\n***goal\n** goal\n** strategy @test\n**context *** goal");
test("* goal\nTODO::\n\tsystem is dependable");
test("* goal\nTODO::\n\tto: all\n\tsystem is dependable");
test("* goal\n* evidence");
test("* goal\nsystem is dependable\ntodo::\n\tTo: all\n\tprovide all available evidence\nagda::\n\tthe claim is ambiguous\n* context");
test("* goal\nsystem is dependable\n* context @def\n* strategy\n** goal\n** evidence @task\n**goal");
test("* goal\n* context");
test("* goal\n* evidence");
test("* goal\n* strategy");
test("* goal\n* strategy\n**goal @task @test\ndesc\ntodo::\n\tto:tsuji\n\tsubject:hi\nticket::\n\tto:tsuji\n** strategy\n** goal\n** goal\n** goal"); 
test("* strategy\n** goal");
test("* evidence\n* context");
test("* strategy\n*context\n**goal");

test("*Goal\n*Strategy\n*Context\n**Goal\nHoge\n**Evidence\n**Goal\n**Context\n**Evidence\n**Context\n**Evidence\n**Goal\n**Evidence");
test("*Goal\n*Evidence\n*Evidence");
test("*context @def");
test("*goal\ntodo::\n\tkey: value");
test("*goal\n日本語\nhi");
test("*evidence\nhi\n*context");
test("*evidence\nMonitor::\n\tScript: \"return 1;\"");
test("*Strategy");
test("*Evidence\nMonitor::\n\thi: bye\n\tbye: bye");
test("*Evidence\nScript::\n\tint f() {\n\t    return 1;\n\t}");
test("*Goal\nStakeholders are identified in this project\n*Context\nundefined::\n\tProjectName: Development of Assure S\n\tStakeholders: LDAPName\n\tVisible: true\n    \n*Strategy\nArguing over types of stakeholders\n**Goal\nFounders are identified\n**Evidence\nkimio\n**Goal\nDevelopers are identified\n**Evidence\nuchida\nmatsumura\n**Goal\nOperators are identified\n**Evidence\nishii");
test("*goal\n*context\n  \n*strategy");
