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
	= &{ _PEG.currentParsingLevel += 1; return true; }
	head:goalnode tail:(newline goalnode)*
	{
		var res = [head];
		for (var i in tail) {
			res.push(tail[i][1]);
		}
		return res;
	}

contextnode
	= node:contextnode_
	{ return node; }

contextnode_
	= depth:nodedepth &{ return depth == _PEG.currentParsingLevel; }
	whitespace context:context whitespace anno:annotations? body:(newline goalbody)?
	{
		var desc = (body == "") ? "" : body[1].desc;
		var notes = (body == "") ? "" : body[1].notes;
		return new _PEG.CaseModel(null, null, _PEG.CaseType[context], anno, desc, notes);
	}

strategynode
	= node:strategynode_ goalnodes:goalnodes?
	{
		if (goalnodes != "") {
			node.Children.concat(goalnodes);
		}
		return node;
	}

strategynode_
	= depth:nodedepth &{ return depth == _PEG.currentParsingLevel; }
	whitespace strategy:strategy whitespace anno:annotations? body:(newline goalbody)?
	{
		var desc = (body == "") ? "" : body[1].desc;
		var notes = (body == "") ? "" : body[1].notes;
		return new _PEG.CaseModel(null, null, _PEG.CaseType[strategy], anno, desc, notes);
	}

goalnode
	= node:goalnode_ context:(newline? contextnode)? strategy:(newline? strategynode)?
	{ 
		if (context != "") {
			node.Children.push(context[1]);
		}
		if (strategy != "") {
			node.Children.push(strategy[1]);
		}
		return node; 
	}

goalnode_
	= depth:nodedepth &{ return depth == _PEG.currentParsingLevel; } 
	whitespace goal:goal whitespace anno:annotations? body:(newline goalbody)?
	{
		var desc = (body == "") ? "" : body[1].desc;
		var notes = (body == "") ? "" : body[1].notes;
		return new _PEG.CaseModel(null, null, _PEG.CaseType[goal], anno, desc, notes);
	}
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
	/ description:description? notes:(newline notes)?
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

goal
	= text:("goal" / "Goal")
	{ return "Goal"; }

nodedepth 
	= asterisks:[*]+
	{ return asterisks.length; }

context
	= text:("context" / "Context")
	{ return "Context"; }

strategy
	= text:("strategy" / "Strategy")
	{ return "Strategy"; }

evidence
	= text:("evidence" / "Evidence")
	{ return "Evidence"; }
