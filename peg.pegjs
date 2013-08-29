start
	= initializer goalnode whitespace?
	/ initializer contextnode whitespace
	/ initializer strategynode whitespace
	/ initializer evidencenode whitespace

initializer /* FIXME */
	= ""
	{
		_PEG = {
			CaseType: {
				G: "Goal",
				C: "Context",
				S: "Strategy",
				E: "Evidence",
			},

			Case: function() {
				/* TODO */
			},

			CaseModel: function(Label, Case, Parent, Type, Annotations, Statement, Notes) {
				this.Case = Case;
				this.Parent = Parent;
				this.Type = Type;
				this.Label = Label;
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
	= [\n] ([ \t]* [\n])*

symbol
	= symbol:([0-9a-z]i+ [0-9a-z]i*)
	{ return symbol[0].join("") + symbol[1].join(""); }

goalnodes
	= &{ _PEG.currentParsingLevel += 1; return true; }
	  head:goalnode tail:(newline? goalnode)*
	  &{ _PEG.currentParsingLevel -= 1; return true; }
	{
		var res = [head];
		for (var i in tail) {
			res.push(tail[i][1]);
		}
		return res;
	}
	/* In case parsing goalnodes above decrement parsing level */
	/ &{ _PEG.currentParsingLevel -= 1; return true; }

contextnodes
	= head:contextnode tail:(newline? contextnode)*
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
		return new _PEG.CaseModel(context, null, null, _PEG.CaseType[context[0]], anno, desc, notes);
	}

evidencenode
	= node:evidencenode_ contextnodes:(newline? contextnodes)
	{
		node.Children = node.Children.concat(contextnodes[1]);
		return node;
	}
	/ node:evidencenode_
	{ return node; }

evidencenode_
	= depth:nodedepth &{ return depth == _PEG.currentParsingLevel; }
	whitespace evidence:evidence whitespace anno:annotations? body:(newline goalbody)?
	{
		var desc = (body == "") ? "" : body[1].desc;
		var notes = (body == "") ? "" : body[1].notes;
		return new _PEG.CaseModel(evidence, null, null, _PEG.CaseType[evidence[0]], anno, desc, notes);
	}

evidencenodes
	= head:evidencenode tail:(newline? evidencenode)*
	{
		var res = [head];
		for (var i in tail) {
			res.push(tail[i][1]);
		}
		return res;
	}

strategynode
	= node:strategynode_ contextnodes:(newline? contextnodes) goalnodes:(newline? goalnodes)
	{
		node.Children = node.Children.concat(contextnodes[1]);
		node.Children = node.Children.concat(goalnodes[1]);
		return node;
	}
	/ node:strategynode_ contextnodes:(newline? contextnodes)
	{
		node.Children = node.Children.concat(contextnodes[1]);
		return node;
	}
	/ node:strategynode_ goalnodes:(newline? goalnodes)
	{
		node.Children = node.Children.concat(goalnodes[1]);
		return node;
	}
	/ node:strategynode_
	{
		return node;
	}

strategynode_
	= depth:nodedepth &{ return depth == _PEG.currentParsingLevel; }
	whitespace strategy:strategy whitespace anno:annotations? body:(newline goalbody)?
	{
		var desc = (body == "") ? "" : body[1].desc;
		var notes = (body == "") ? "" : body[1].notes;
		return new _PEG.CaseModel(strategy, null, null, _PEG.CaseType[strategy[0]], anno, desc, notes);
	}

goalnode
	= node:goalnode_ contextnodes:(newline? contextnodes) strategy:(newline? strategynode)
	{ 
		node.Children = node.Children.concat(contextnodes[1]);
		node.Children.push(strategy[1]);
		return node; 
	}
	/ node:goalnode_ contextnodes:(newline? contextnodes) evidence:(newline? evidencenodes)
	{ 
		node.Children = node.Children.concat(contextnodes[1]);
		node.Children = node.Children.concat(evidence[1]);
		return node; 
	}
	/ node:goalnode_ contextnodes:(newline? contextnodes)
	{ 
		node.Children = node.Children.concat(contextnodes[1]);
		return node; 
	}
	/ node:goalnode_ evidence:(newline? evidencenodes)
	{ 
		node.Children = node.Children.concat(evidence[1]);
		return node; 
	}
	/ node:goalnode_ strategy:(newline? strategynode)
	{ 
		node.Children.push(strategy[1]);
		return node; 
	}
	/ node:goalnode_
	{ 
		return node; 
	}

goalnode_
	= depth:nodedepth &{ return depth == _PEG.currentParsingLevel; } 
	whitespace goal:goal whitespace anno:annotations? body:(newline goalbody)?
	{
		var desc = (body == "") ? "" : body[1].desc;
		var notes = (body == "") ? "" : body[1].notes;
		return new _PEG.CaseModel(goal, null, null, _PEG.CaseType[goal[0]], anno, desc, notes);
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
	{ return {"Name": symbol, "Body": ""}; }

goalbody
	= notes:notes {return {notes:notes};}
	/ !tabindent description:description? notes:(newline notes)?
	{ return {notes: notes == "" ? [] : notes[1], desc: description}; }


description
	= head:singleline tail:([\n\r] singleline)*
	{ 
		var res = [head];
		for (var i in tail) {
			res.push(tail[i][1]);
		}
		return res.join("\n");
	}
	//= singleline:[a-z0-9 ]i* /* FIXME */
	//{ return singleline.join(""); }

singleline
	= &{
		var subs = input.substr(offset);
		var toIndex = (subs.indexOf("\n") == -1) ? subs.length : subs.indexOf("\n");
		var singleline = subs.substr(0, toIndex);
		return (singleline.indexOf("::") == -1 && singleline.indexOf("*") != 0);
	}
	line:[^\n]i*
	{ return line.join(""); }

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
	= subject:notesubject whitespace "::" body:notebody?
	{ return new _PEG.CaseNote(subject, body == "" ? {} : body); }

notesubject
	= subject:symbol
	{ return subject; }

notedescription
	= newline tab:tabindent head:singleline tail:(newline subtab:tabindent singleline)*
	{ 
		console.log("tab: \"" + tab + "\"");
		var res = [head];
		for (var i in tail) {
			res.push(tail[i][1].join("").substr(tab.length) + tail[i][2]);
		}
		return res.join("\n");
	}
	//= singleline:[a-z0-9 ]i* /* FIXME */
	//{ return singleline.join(""); }

notebody
	= kvs:notekeyvalues desc:(notedescription)?
	{
		if (desc != "") {
			//kvs.push(["Description", desc]);
			kvs["Description"] = desc;
		}
		return kvs;
	}
	/ desc:(notedescription)
	{ return {"Description": desc}; }

tabindent
	= [\t ]+

notekeyvalues
	= newline tabindent head:notekeyvalue tail:(newline tabindent notekeyvalue)* !note
	{ 
		var res = {};
		res[head[0]] = head[1];
		if (tail != "") {
			for (var i in tail) {
				res[tail[i][2][0]] = tail[i][2][1];
			}
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
	= value:singleline /* FIXME */

nodedepth 
	= asterisks:[*]+
	{ return asterisks.length; }

labelnum
	= zero:[1-9]+ one:[0-9]*
	{
		return zero.join("") + one.join("");
	}

goal
	= goal:goal_ labelnum:labelnum?
	{ return goal + labelnum; }

goal_
	= text:("goal" / "Goal" / "g" / "G")
	{ return "G"; }

context
	= context:context_ labelnum:labelnum?
	{ return context + labelnum; }

context_
	= text:("context" / "Context" / "c" / "C")
	{ return "C"; }

strategy
	= strategy:strategy_ labelnum:labelnum?
	{ return strategy + labelnum; }

strategy_
	= text:("strategy" / "Strategy" / "s" / "S")
	{ return "S"; }

evidence
	= evidence:evidence_ labelnum:labelnum?
	{ return evidence + labelnum; }

evidence_
	= text:("evidence" / "Evidence" / "e" / "E")
	{ return "E"; }
