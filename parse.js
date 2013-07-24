PEG = require("./peg.js");

function test(source) {
	console.log(source);
	console.log(PEG.parse(source)[1]);
}


test("* goal");
