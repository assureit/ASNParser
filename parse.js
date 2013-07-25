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
test("* goal\n* strategy");
test("* goal\n* strategy\n** goal\n**strategy\n***goal");
test("* goal\n* strategy\n** goal\n**strategy @test\n***goal");
test("* goal\n* strategy\n** goal\ntest\n**strategy @test\n***goal\n** goal\n** strategy @test\n**context *** goal");
