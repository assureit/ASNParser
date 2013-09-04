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
test("* goal @task @test\ntodo:: shida\nsubject:: test");
test("* goal\nhi\n*context\nhi");
test("* goal\nhi\n* context\nhi\ntodo::");
test("* goal\n*context");
test("* goal @task @test\ndesc\ntodo::*context\nhi");
test("* goal\n* strategy\n** goal\n**strategy\n***goal");
test("* goal\n* strategy\n** goal\n**strategy @test\n***goal");
test("* goal\n* strategy\n** goal\ntest\n**strategy @test\n***goal\n** goal\n** strategy @test\n**context *** goal");
test("* goal\nTODO:: system is dependable");
test("* goal\nTODO::");
test("* goal\n* evidence");
test("* goal\nsystem is dependable\n* context @def\n* strategy\n** goal\n** evidence @task\n**goal");
test("* goal\n* context");
test("* goal\n* evidence");
test("* goal\n* strategy");
test("* strategy\n** goal");
test("* evidence\n* context");
test("* strategy\n*context\n**goal");

test("*Goal\n*Strategy\n*Context\n**Goal\nHoge\n**Evidence\n**Goal\n**Context\n**Evidence\n**Context\n**Evidence\n**Goal\n**Evidence");
test("*Goal\n*Evidence\n*Evidence");
test("*context @def");
test("*goal\n日本語\nhi");
test("*evidence\nhi\n*context");
test("*evidence\nMonitor:: \"return 1;\"");
test("*Strategy");
test("*Goal\nStakeholders are identified in this project\n*Context\nProjectName: Development of Assure S\n\tStakeholders: LDAPName\n\tVisible: true\n    \n*Strategy\nArguing over types of stakeholders\n**Goal\nFounders are identified\n**Evidence\nkimio\n**Goal\nDevelopers are identified\n**Evidence\nuchida\nmatsumura\n**Goal\nOperators are identified\n**Evidence\nishii");
test("*goal\n*context\n  \n*strategy");
test("*strategy\n*context\nhi\n**goal");
test("*goal\n*context\n*context");
test("*evidence\n*context");
test("*G1");
test("*G100");
test("*G @param (Monitor.X.callAdmin == 1)");
test("*G @param (Monitor.X.callAdmin == 1) @param2");
test("*G @param hi @param2");
test("*G @param (Monitor.X.callAdmin == 1)\n*C");
test("*G @after (E1.Monitor() == true) @test");
test("*G @after (E1.Action == true) @test");
test("*G @after (E1.Action == true) @test\n*S\nnewnode");
test("*G0");
test("* goal @task\ndesc\ntodo::");
test("* goal @task @test\ntodo:: shida");
