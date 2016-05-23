
objRetype.refill( new FluidCommentChargeSuccess() )

; @todo Make generic commenting class (with prompt), and extend to pass admin / config file editable sub-class
class FluidCommentChargeSuccess extends Fluid {

	;strHotkey		:= "^!+c"
	strMenuPath		:= "/CusMan/Comments"
	strMenuText		:= "Charge Success"
	intMenuIcon		:= 145

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
				; In customer manager, let's get IP code input
				intIP 			:= InputBox.show( "Enter IP code on which to comment" )
				; IP Validation
; @todo Validation
				; 6 <= Len( IP ) <= 7

				; Get sale date, format (mm/dd/yyyy)
				intSaleDate		:= InputBox.show( "Enter charge date", "mm/dd/yyyy" )
				; isDate( )

				; Get total owed (decimal)
				intAmountOwed	:= InputBox.show( "Enter charge amount (without $ prefix)" )
				; substr( intAmountOwed, 0, 1 ) = "$"
				; isFloat || isInt
				; 2 decimal places

				; Make sure in RTP, then find customer
				objRetype.objRTP.Activate()
				objRetype.objRTP.CustomerSearchAndSelect( intIP )

				; Construct subject and comment
				strSubject = Paid $%intAmountOwed% (RC Charge)
				strComment = For %intSaleDate%. CC updated and charges cleared. %A_UserName% x7055

				; Add comment to profile
				objRetype.objRTP.CustomerAddComment( strSubject, strComment )
/*
	strSubject = Paid $xx.xx - RC charge
	strComment = For 09.05.10 – CC updated online and charges cleared. #Name#-7055
*/
			}
		}
	}

}