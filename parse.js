PEG = require("./peg.js");

function test(source) {
	console.log(source);
	var result = PEG.parse(source)[1];
	console.log("--result--");
	console.log(result);
}


test("* goal\n");
test("* goal");
test("* goal\ndesc");
