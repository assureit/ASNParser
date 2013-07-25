start
	= initializer goalnode whitespace

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

			CaseModel: function(Case, Parent, Type, Annotations, Statement, Notes) {
				this.Case = Case;
				this.Parent = Parent;
				this.Type = Type;
				this.Label = null; /* TODO how's Label used? */
				this.Statement = Statement;
				this.Children = [];
				this.Annotations = Annotations;
				this.Notes = Notes;
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
	= _*

_
	= [ \t\r]

newline
	= [\n]

symbol
	= symbol:([a-z]i+ [0-9a-z]i*)
	{ return symbol[0].join("") + symbol[1].join(""); }

goalnodes
	= list:goalnode*
	{ return list; }

goalnode
	= depth:nodedepth whitespace goal:goal whitespace anno:annotations? body:(newline goalbody)?
	{
		var desc = (body == "") ? "" : body[1].desc;
		var notes = (body == "") ? "" : body[1].notes;
		return new _PEG.CaseModel(null, null, _PEG.CaseType[goal], anno, desc, notes);
	}
	/* children:goalchildren*/

annotations
	= head:annotation tail:(whitespace annotation)*
	{
		var res = [head];
		for (var i in tail) {
			res.push(tail[i][1]);
		}
		return res;
	}

annotation
	= "@" symbol:symbol
	{ return symbol; }

goalbody
	= notes:notes {return "";}
	/ description:description notes:(newline notes)?
	{ return {notes: notes == "" ? [] : notes[1], desc: description}; }


description
	= singleline:[a-z]i* /* FIXME */
	{ return singleline.join(""); }

notes
	= head:note tail:(newline note)*
	{ 
		var res = [head];
		for (var i in tail) {
			res.push(tail[i][1]);
		}
		return res;
	}

note
	= subject:notesubject whitespace "::" body:(newline whitespace notebody)?
	{ return new _PEG.CaseNote(subject, body == "" ? {} : body[2]); }

notesubject
	= subject:symbol
	{ return subject; }

notebody
	= kvs:notekeyvalues
	{
		return kvs;
	}

notekeyvalues
	= head:notekeyvalue tail:(newline whitespace notekeyvalue)* !note
	{ 
		var res = [head];
		for (var i in tail) {
			res.push(tail[i][2]);
		}
		return res;
	}

notekeyvalue
	= key:key whitespace ":" whitespace value:value
	{ return [key, value]; }

key
	= key:symbol
	{ return key; }

value
	= value:symbol /* FIXME */

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
