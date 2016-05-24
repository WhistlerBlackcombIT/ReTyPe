#Include AHK-Lib-JSON\JSON_FromObj.ahk
#Include AHK-Lib-JSON\JSON_ToObj.ahk
#Include Class_Console-master\Class_Console.ahk
; majkinetor script
#Include lib_ahk\_.ahk
; Configure debug method
;_( "mo wd" )

class Debug extends console {

	static env 	:= "dev"

	static strFileLog	= "debug.log"

	__New() {
		; @todo use ini environment parameter (dev/prod)

		; @todo Do we need headers?
		; @todo Maybe store in JSON
		FileAppend, Headers, this.strFileLog
	}

	log( e ) {
		if ( isObject( e ) ) {
			; Add Date and Time to exception to log
			e.date := Date

			; Encode exception
			strDebug := this.jsonEncode( e ) "`n"
			;~ strDebug := % "Exception thrown{when:" A_Now "|what:" e.what "|file:" e.file "|line:" e.line "|message:" e.message "|extra:" e.extra "}`n"
			strFile := this.strFileLog
			FileAppend, %strDebug%, %strFile%
		} else {
			; @todo some array stuff
		}
	}

	/**
	 * Environment dependant debug message output that will also show stack-trace of from where it was called
	 * @see https://gist.github.com/hoppfrosch/7672038
	 *
	 * @param String strMessage Debug message to be displayed along with stack-trace
	 * @return void
	 */
	msg( strMessage="" ) {
		; Should we read and display line of code in output?
		blnCode := false

		; Only do this if we're in a dev environment otherwise we don't want debug info (like in Prod)
		; And if we're running in a non-compiled environment (which we can infer is dev/testing)
		if ( "dev" = this.env AND 1 != A_IsCompiled ) {
			; Instantiate exceptions to grab necessary stack-trace info
			objTrace := Exception("", -1)
			objTracePrev := Exception("", -2)

			; Only read-file for code if required
			if ( blnCode ) {
				FileReadLine, strLine, % objTrace.file, % objTrace.line
				StringReplace, strLine, strLine, `t, 
			}

			; Strip full-path leaving just sub-directory and filename
			strFile := SubStr( objTrace.file, StrLen( A_ScriptDir )+2, 100 )

			; Concatenate together for stack trace
			strStack := "File:`t" strfile "`nLine:`t" objTrace.line (objTracePrev.What = -2 ? "" : "`nIn:`t" objTracePrev.What) (blnCode ? "`nCode:`t" strLine : "") "`n`n"

			; Display trace and message
			msgbox % strStack strMessage
		}
	}

; @todo abstract json in to its own class
	jsonDecode( strJSON ) {
		return json_toobj( strJSON )
	}


	jsonEncode( objObject ) {
		return json_fromobj( objObject )
	}

	exploreObj(Obj, NewRow="`n", Equal="  =  ", Indent="`t", Depth=12, CurIndent="") { 
		for k,v in Obj
			ToReturn .= CurIndent . "[ " . k . " ]" . (IsObject(v) && depth>1 ? NewRow . this.exploreObj(v, NewRow, Equal, Indent, Depth-1, CurIndent . Indent) : Equal . v) . NewRow
		return RTrim(ToReturn, NewRow)
	}

}