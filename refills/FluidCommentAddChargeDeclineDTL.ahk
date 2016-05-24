
objRetype.refill( new FluidCommentAddChargeDeclineDTL() )

; @todo Make generic commenting class (with prompt), and extend to pass admin / config file editable sub-class
class FluidCommentAddChargeDeclineDTL extends Fluid {

	;strHotkey		:= "^!+c"
	strMenuPath		:= "/CusMan/Comments"
	strMenuText		:= "Declined DTL"
	intMenuIcon		:= 67

	/**
	 * Setup controls, window group, etc
	 */
	__New() {
		global objRetype
		base.__New()

		strRTP		:= % objRetype.objRTP.classNN()
		strGroup	:= this.id

		GroupAdd, %strGroup%, ahk_class %strRTP%
	}

	/**
	 * Make the magic happen
	 */
	pour() {
		global objRetype

		; Activate RTP (after toolbar has been clicked)
		objRetype.objRTP.Activate()

		strGroup := this.__Class
		IfWinActive, ahk_group %strGroup%
		{
			; WinActive check isn't good enough in this case, so need to make a visual search too
			ImageSearch intActiveX, intActiveY, 20, 60, 60, 100, *50 %A_ScriptDir%\img\search_icon_customermanager.png
			if ( ErrorLevel ) {
				; At this point we are not in customer manager
				MsgBox.error( "Can only be run from within Customer Manager" )
			} else {
				; Get sale date, format (mm/dd/yyyy)
				strTime := A_Now
				strTime += -1, days
				FormatTime, strTime, %strTime%, MM/dd/yyyy
				intSaleDate		:= InputBox.show( "Enter charge date`n`nFormat: mm/dd/yyyy", strTime )
				; isDate( )

				; Get total owed (decimal)
				intAmountOwed	:= InputBox.show( "Enter charge amount (without $ prefix)" )
; @todo substr( intAmountOwed, 0, 1 ) = "$"
; isFloat || isInt
; 2 decimal places


				; Make sure in RTP
				objRetype.objRTP.Activate()

				; Construct subject and comment
				strSubject = Owes $%intAmountOwed% - DTL charge
				strComment = For %intSaleDate%. Need to check CC on file. Emailed guest. %A_UserName% x7055

				; Add comment to profile
				objRetype.objRTP.CustomerAddComment( strSubject, strComment )
			}
		}
	}

}

; McWrap: 2993249
