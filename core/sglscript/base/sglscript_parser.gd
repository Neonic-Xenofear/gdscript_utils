class_name CSGLScriptParserImpl

class CSGLScriptCommand:
	var name : String = "";
	var args : Dictionary = {};
	
#	func toString():
#		if ( args.empty() ):
#			return str( "[", name, "]" );
#
#		var argPart  : String = "";
#
#		for key in args.keys():
#			argPart += str( key, ":" );
#
#			if ( typeof( args[key] ) == TYPE_STRING ):
#				argPart += str( "\"", args[key], "\"" );
#			else:
#				argPart += str( args[key] );
#
#			argPart += " ";
#
#		return str( "[", name, ":", argPart.strip_edges( false, true ), "]" );

class CSGLScriptFunc:
	var name : String = "";
	var index : int = 0;
	var code : Array = [];
	var variables : Dictionary = {};
	var parentScript : CSGLScript = null;

#class CSGLVar:
#	enum ESGLVarType {
#		VT_NONE = 0,
#		VT_BOOL,
#		VT_STRING,
#		VT_INT,
#		VT_DOUBLE,
#		VT_FLOAT,
#		VT_ARRAY,
#	}
#
#	var type : int = 0;
#	var value : String = "";

class CSGLScriptIfState extends CSGLScriptCommand:
	var ifIndex = -1;
	var elseIndex = -1;
	var endifIndex = -1;

class CSGLScript:
	var index : int = 0;
	var code : Array = [];
	var funcs : Dictionary = {};
	var labelMap : Dictionary = {};
	var variables : Dictionary = {};
	
	func preprocess() -> void:
		genFuncs();
		genIfMap();
	
	func genIfMap() -> void:
		setupIfStates();
		
		var ifInd : int = getNextCommandIndexByName( "if" );
		if ( ifInd != -1 ):
			genSingleIf( ifInd );
	
	func setupIfStates() -> void:
		var ind = index;
		while ( ind < code.size() ):
			if ( isIfState( ind ) ):
				var resIfState : CSGLScriptIfState = CSGLScriptIfState.new();
				resIfState.name = code[ind].name;
				resIfState.args = code[ind].args;
				
				code[ind] = resIfState;
			
			ind += 1;
	
	func genSingleIf( ifIndex : int ) -> void:
		var ifInd : int = getNextFreeIfStatementByName( "if", ifIndex );
		var elseIf : int = getNextFreeIfStatementByName( "else", ifIndex );
		var endIf : int = getNextFreeIfStatementByName( "endif", ifIndex );
		
		var resIfState : CSGLScriptIfState = CSGLScriptIfState.new();
		#By this code editor crash._.
		#resIfState = code[ifInd];
		resIfState.name = code[ifIndex].name;
		resIfState.args = code[ifIndex].args;
		
		while ( ifInd != -1 && ( ifInd < elseIf || ifInd < endIf ) ):
			genSingleIf( ifInd );
			ifInd = getNextFreeIfStatementByName( "if", ifIndex );
		
		if ( !isIfStateFree( elseIf ) ):
			elseIf = getNextFreeIfStatementByName( "else", ifIndex );
		
		if ( !isIfStateFree( endIf ) ):
			endIf = getNextFreeIfStatementByName( "endif", ifIndex );
		
		resIfState.ifIndex = ifIndex;
		if ( elseIf < endIf ):
			resIfState.elseIndex = elseIf;
		resIfState.endifIndex = endIf;
		code[ifIndex] = resIfState;
		
		if ( resIfState.elseIndex != -1 ):
			var resElseState : CSGLScriptIfState = CSGLScriptIfState.new();
			resElseState.name = code[elseIf].name;
			resElseState.args = code[elseIf].args;
			resElseState.ifIndex = ifIndex;
			resElseState.elseIndex = elseIf;
			resElseState.endifIndex = endIf;
			code[elseIf] = resElseState;
		
		if ( endIf != -1 ):
			var resEndState : CSGLScriptIfState = CSGLScriptIfState.new();
			resEndState.name = code[endIf].name;
			resEndState.args = code[endIf].args;
			resEndState.ifIndex = ifIndex;
			resEndState.elseIndex = elseIf;
			resEndState.endifIndex = endIf;
			code[endIf] = resEndState;
	
	func genFuncs() -> void:
		var funcInd : int = getNextCommandIndexByName( "func", -1 );
		while ( funcInd != -1 ):
			var funcEndInd : int = getNextCommandIndexByName( "func_end", funcInd );
			if ( funcEndInd == -1 ):
				print( "SGLScript: Cannot find function end!" );
			
			var resFunc : CSGLScriptFunc = CSGLScriptFunc.new();
			resFunc.name = code[funcInd].args["name"];
			
			var i : int = funcInd + 1;
			while ( i < funcEndInd ):
				resFunc.code.append( code[i] );
				code.remove( i );
				i += 1;
			
			code.remove( getNextCommandIndexByName( "func", -1 ) );
			code.remove( getNextCommandIndexByName( "func_end", -1 ) );
			funcs[resFunc.name] = resFunc;
			
			funcInd = getNextCommandIndexByName( "func", -1 );
	
	#Parse values like: "{a} / {b} > 10" or "{a} + 10"
	func parseInputVal( val ):
		if ( typeof( val ) != TYPE_STRING ):
			return val;
		
		var resStr : String = val;
		var reg : Expression = Expression.new();
		
		for v in variables:
			resStr = resStr.format( { v: variables[v] } );
		
		reg.parse( resStr );
		return reg.execute();
	
	func getNextCommandIndexByName( name_ : String, startInd : int = index ) -> int:
		var ind = startInd + 1;
		while ( ind < code.size() ):
			var block = code[ind];
			if ( typeof( block ) != TYPE_STRING ):
				if ( block.name == name_ ):
					return ind;
			
			ind += 1;
		
		return -1;
	
	func getNextFreeIfStatementByName( name_ : String, startInd : int = index ) -> int:
		var ind = startInd + 1;
		while ( ind < code.size() ):
			var block : CSGLScriptIfState = code[ind];
			if ( isIfStateFree( ind ) ):
				# block.ifIndex == -1 && block.elseIndex == -1 &&
				if ( block.name == name_ ):
					return ind;
			
			ind += 1;
		
		return -1;
	
	func isIfState( ind : int ) -> bool:
		if ( typeof( code[ind] ) != TYPE_STRING && ind > 0 ):
			return code[ind].name == "if" || code[ind].name == "else" || code[ind].name == "endif";
		
		return false;
	
	func isIfStateFree( ind_ : int ) -> bool:
		if ( isIfState( ind_ ) ):
			return code[ind_].ifIndex == -1 && code[ind_].endifIndex == -1;
		
		return false;
	
	func dc_import( args ) -> void:
		var interpr : CSGLScriptParser = CSGLScriptParser.new();
		if ( args.has( "path" ) ):
			var file : File = File.new();
			file.open( args["path"], file.READ );
			interpr.rawText = file.get_as_text();
			file.close();
			
			interpr.index = 0;
			code.remove( index );
			
			CArrayUtil.insertArray( index, code, interpr.parse( interpr.rawText ).code );
			
			index -= 1;
	
#	func dc_call( args : Dictionary ) -> void:
#		if ( !args.has( "name" ) ):
#			Console.Log.error( "SGLScript: Cannot call funciton without name!" );
#			return;
#
#		var name : String = args["name"];
#		if ( !funcs.has( name ) ):
#			Console.Log.error( "SGLScript: Invalid funcition call name!" );
#			return;
#
#		var currFunc = funcs[name];
	
	#Register new variable
	func dc_var( args ) -> void:
		for v in args:
			variables[v] = args[v];
	
	func dc_array_var( args ) -> void:
		for v in args:
			variables[v] = Array();
			
			if ( typeof( args[v] ) == TYPE_ARRAY ):
				variables[v] = args[v];
			else:
				variables[v] = [args[v]];
	
	func dc_array_append( args ) -> void:
		for v in args:
			if ( variables.has( v ) ):
				
				if ( typeof( args[v] ) != TYPE_ARRAY ):
					variables[v].append( args[v] );
				else:
					for item in args[v]:
						variables[v].append( item );
	
	func dc_set_val( args ) -> void:
		for v in args:
			if ( variables.has( v ) ):
				variables[v] = parseInputVal( args[v] );
	
	func dc_print( args ) -> void:
		if ( typeof( args["val"] ) != TYPE_STRING ):
			print( args["val"] );
			return;
		
		var resStr : String = args["val"];
		var reg : Expression = Expression.new();
		
		for v in variables:
			resStr = resStr.format( { v: str( v, ":", variables[v], " " ) } );
		
		print( resStr );
	
	func dc_if( args ) -> void:
		var res : bool = parseInputVal( args["val"] );
		
		if ( !res ):
			var currInd : CSGLScriptIfState = code[index];
			if ( currInd.elseIndex != -1 ):
				index = currInd.elseIndex;
			elif ( currInd.endifIndex != -1 ):
				index = currInd.endifIndex;
			else:
				print( "SGLScript: Can't find ENDIF statement!" )
		
	
	func dc_endif( args ) -> void:
		pass
	
	func dc_else( args ) -> void:
		if ( code[index].endifIndex != -1 ):
			index = code[index].endifIndex;
		else:
			print( "SGLScript: Can't find ENDIF statement!" );

class CSGLScriptParser:
	var rawText : String = "";
	var index : int = 0;
	var result : Array = [];
	var macros : Dictionary = {};
	var macrosBeginnings : Array = [];
	
	var capsHeaderCommand : String = "";
	var capsHeaderArgument : String = "";
	
	var labelMap : Dictionary = {};
	
	var bAddParagraphCommands = true;
	
	func getChar() -> String:
		return rawText[index];
	
	func getPrevChar() -> String:
		if ( index > 0 ):
			return rawText[index - 1];
		else:
			return "";
	
	func getNextChar() -> String:
		if ( index < rawText.length() ):
			return rawText[index + 1];
		else:
			return "";
	
	func prev() -> void:
		index -= 1;
		if ( index < 0 ):
			index = 0;
	
	func next() -> void:
		index += 1;
	
	func inBounds() -> bool:
		return index < rawText.length();
	
	func lastItem():
		if ( result.empty() ):
			return null;
		
		return result[-1];
	
	func isWhitespace( character : String ) -> bool:
		return character == " " || character == "\n" || character == "\t" || character == "\r";
	
	func isString( val ) -> bool:
		return typeof( val ) == TYPE_STRING;
	
	func isLastString() -> bool:
		return isString( lastItem() );
	
	func addRes( res ) -> void:
		result.append( res );
	
	func addChar( character : String ) -> void:
		if ( isLastString() ):
			result[-1] += character;
		else:
			addRes( character );
	
	func parseWhitespace() -> void:
		while ( isWhitespace( getChar() ) ):
			next();
	
	func skipToNewLine() -> void:
		while ( getChar() != "\n" ):
			next();
	
	func parseLine() -> String:
		var currChar : String = "";
		var block : String = "";
		
		while ( inBounds() && currChar != "\n" ):
			currChar = getChar();
			
			if ( isWhitespace( currChar ) ):
				if ( block.length() > 0 && block[-1] != " " ):
					block += " ";
			elif ( currChar == ";" && getNextChar() == ";" ):   #Обработка комментариев
				skipToNewLine();
				prev();
				break;
			else:
				block += currChar;
		
		return block.strip_edges();
	
	func parseVal():
		var currChar : String = "";
		var block = "";
		
		parseWhitespace();
		
		while ( getChar() == ";" && getNextChar() == ";" ):
			skipToNewLine();
			parseWhitespace();
		
		currChar = getChar();
		
		if ( currChar == "\"" || currChar == "'" ):
			var startString : String = currChar;
			next();
			
			while ( inBounds() ):
				currChar = getChar();
				
				if ( currChar == "\\" ):
					#next();
					block += getChar();
				elif ( currChar == startString ):
					break;
				else:
					block += currChar;
				
				next();
		else:
			while ( inBounds() ):
				currChar = getChar();
				
				if ( currChar == "[" ):
					return parseArray();
				elif ( isWhitespace( currChar ) ):
					break;
				elif ( currChar == "]" || currChar == ";" ):
					prev();
					break;
				else:
					block += currChar.to_lower();
				
				next();
			
			if ( block.is_valid_integer() ):
				block = block.to_int();
			elif ( block.is_valid_float() ):
				block = block.to_float();
		
		return block;
	
	func parseArray() -> Array:
		var result : Array = [];
		var currChar : String = "";
		var block : String = "";
		
		parseWhitespace();
		
		while ( inBounds() ):
			currChar = getChar();
			
			if ( currChar == "," ):
				result.append( block.strip_edges().replace( "[", "" ).replace( "\"", "" ) );
				block = "";
				next();
				continue;
			elif ( isWhitespace( currChar ) ):
				next();
				continue;
			elif ( currChar == "]" ):
				result.append( block.strip_edges().replace( "\"", "" ) );
				return result;
			elif ( currChar == ";" && getNextChar() == ";" ):
				skipToNewLine();
				prev();
			else:
				block += currChar.to_lower();
			
			next();
		
		return result;
	
	func parseCommand() -> CSGLScriptCommand:
		var result : CSGLScriptCommand = CSGLScriptCommand.new();
		var currChar : String = "";
		var block : String = "";
		
		next();  #We started of "["
		
		while ( inBounds() ):
			currChar = getChar();
			
			if ( currChar == ":" ):
				result.name = block.strip_edges();
				block = "";
				next();
				break;
			elif ( currChar == "]" ):
				result.name = block.strip_edges();
				return result;
			elif ( isWhitespace( currChar ) ):
				if ( block.length() > 0 && block[-1] != " " ):
					block += " ";
			elif ( currChar == ";" && getNextChar() == ";" ):
				skipToNewLine();
				prev();
			else:
				block += currChar.to_lower();
			
			next();
		
		var argName : String = "";
		var argVal = "";
		
		while ( inBounds() ):
			currChar = getChar();
			
			if ( currChar == ":" ):
				argName = block.strip_edges();
				next();
				argVal = parseVal();
				result.args[argName] = argVal;
				
				block = "";
			elif ( currChar == "]" ):
				break;
			elif ( isWhitespace( currChar ) ):
				if ( block.length() > 0 && block[-1] != " " ):
					block += " ";
			elif (  currChar == ";" && getNextChar() == ";" ):
				skipToNewLine();
				prev();
			else:
				block += currChar.to_lower();
			
			next();
		
		return result;
	
	func parse( text : String ) -> CSGLScript:
		rawText = text;
		index = 0;
		result = [];
		macros = {};
		macrosBeginnings = [];
		labelMap = {};
		capsHeaderCommand = "";
		capsHeaderArgument = "";
		
		var currChar : String = "";
		var block = "";
		var bLineEmpty : bool = true;
		var bParagraphEmpty : bool = true;
		var bSuppressSpace : bool = false;
		var lastTextIndex : int = -1;
		
		while ( inBounds() ):
			currChar = getChar();
			
			if ( currChar == "\\" ):
				next();
				addChar( getChar() );
				lastTextIndex = result.size() - 1;
			elif ( currChar == "[" ):
				block = parseCommand();
				
				if ( block.name == "label" ):
					labelMap[block.args["name"]] = result.size();
					bParagraphEmpty = true;
					addRes( block );
				else:
					addRes( block );
					bLineEmpty = false;
			elif (  currChar == ";" && getNextChar() == ";" ):
				skipToNewLine();
				prev();
			elif ( currChar == "\n" ):
				if ( bLineEmpty && !bParagraphEmpty ):
					result[lastTextIndex] = result[lastTextIndex].strip_edges( false, true );
					
					if ( bAddParagraphCommands ):
						block = CSGLScriptCommand.new();
						block.name = "paragraph";
						addRes( block );
					
					bParagraphEmpty = true;
				
				bLineEmpty = true;
			elif ( currChar == " " || currChar == "\t" ):
				var bLastStringWhitespace : bool = isLastString() && lastItem()[-1] != " ";
				var bDebLastString : bool = !isLastString() && !bLineEmpty;
				
				if ( bLastStringWhitespace || bDebLastString ):
					if ( !bSuppressSpace ):
						addChar( currChar );
						lastTextIndex = result.size() - 1;
			else:
				addChar( currChar );
				lastTextIndex = result.size() - 1;
				bSuppressSpace = false;
				bLineEmpty = false;
				bParagraphEmpty = false;
			
			next();
		
		var script : CSGLScript = CSGLScript.new();
		script.code = result;
		script.labelMap = labelMap;
		script.preprocess();
		return script;
	
