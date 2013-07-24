start
	= initializer goalnode

initializer /* FIXME */
	= ""
	{
		_PEG = {
			CaseType: {
				Goal: "Goal",
				Context: "Context",
				Strategy: "Strategy",
				Evidence: "Evidence",
				//Goal: 0,
				//Context: 1,
				//Strategy: 2,
				//Evidence: 3,
			},

			Case: function() {
				/* TODO */
			},

			CaseModel: function(Case, Parent, Type, Label, Statement) {
				this.Case = Case;
				this.Parent = Parent;
				this.Type = Type;
				this.Label = Label;
				this.Statement = Statement;
				this.Children = [];
				this.Annotations = [];
				this.Notes = [];
				this.x = 0;
				this.y = 0;
			},
			CaseNote: function(Name, Body) {
				this.Name = Name;
				this.Body = Body;
			},
			currentParsingLevel: 1,
		};
		return "";
	}

whitespace
	= text:[ \t\n\r]+
	{ return text }

newline
	= [\n]+

symbol
	= symbol:([a-z]i+ [0-9a-z]i*)
	{ return symbol; }

goalnodes
	= list:goalnode*
	{ return list; }

goalnode
	= depth:nodedepth whitespace? goal:goal body:goalbody? /* children:goalchildren*/
	{ console.log(body); return goal + " " + depth; }

goalbody
	= desc:description? notes:notes?
	{ console.log("desc" + desc + "\nnotes" + notes); return {desc: desc.join(""), notes: notes}; }

description
	= singleline:[a-z]i* newline
	{ return singleline; }

notes
	= list:note+
	{ return list; }

note
	= subject:notesubject whitespace* "::" whitespace* notebody newline
	{ return new _PEG.CaseNote(subject, subjectbody); }

notesubject
	= subject:symbol
	{ return subject; }

notebody
	= kvs:notekeyvalues* desc:notedescription*
	{
		var res = {};
		for (var kv in kvs)  {
			res[kv[0]] = kv[1];
		}
		res["Description"] = desc;
		return res;
	}

notekeyvalues
	= kvs:notekeyvalue*
	{ return kvs; }

notekeyvalue
	= key whitespace ":" whitespace value newline
	{ return [key, value]; }

key
	= key:symbol
	{ return key; }

value
	= value:[a-z]i* newline

notedescription
	= "" /* TODO */

goalchildren
	= "" /* TODO */

goal
	= text:("goal" / "Goal")
	{ console.log("goal"); return "Goal"; }

nodedepth 
	= asterisks:[*]+
	{ return asterisks.length; }

nodename
	= name: (goal / context / strategy / evidence)
	{ return _PEG.CaseType[name]; }

context
	= "context" whitespace
	{ return "Context"; }

strategy
	= "strategy" whitespace
	{ return "Strategy"; }

evidence
	= "evidence" whitespace
	{ return "Evidence"; }

//start
//  = additive
//
//additive
//  = left:multiplicative "+" right:additive { return left + right; }
//  / multiplicative
//
//multiplicative
//  = left:primary "*" right:multiplicative { return left * right; }
//  / primary
//
//primary
//  = integer
//  / "(" additive:additive ")" { return additive; }
//
//integer "integer"
//  = digits:[0-9]+ { return parseInt(digits.join(""), 10); }
