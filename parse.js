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
test("* goal @task\ndesc\ntodo::\n\tto: shida");
test("* goal @task @test\ndesc\ntodo::\n\tto: shida\n\t subject: hi");
