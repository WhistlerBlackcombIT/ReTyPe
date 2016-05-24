/**
 * File containing Refill class to facilitate copying media output across sales channels
 * Class will add itself to the parent retype instance
 *
 * AutoHotKey v1.1.13.01+
 *
 * LICENSE: This work is licensed under a version 4.0 of the
 * Creative Commons Attribution-ShareAlike 4.0 International License
 * that is available through the world-wide-web at the following URI:
 * http://creativecommons.org/licenses/by-sa/4.0/deed.en_US
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2015 Dominic Wrapson
 * @license		Creative Commons Attribution-ShareAlike 4.0 International License http://creativecommons.org/licenses/by-sa/4.0/deed.en_US
 */


; Trigger my damn self (in a horrible way due to AHK limitations)
objRetype.refill( new FluidComponentVoucherOutputCopy() )


/**
 * Refill to automatically duplicate text from first output entry to following X entries
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2015 Dominic Wrapson
 */
class FluidComponentVoucherOutputCopy extends Fluid {

	strHotkey		:= "^!v"
	strMenuPath		:= "/Admin/Component"
	strMenuText		:= "Voucher Output Copy"
	intMenuIcon		:= 135 ;272

	/**
	 * Setup controls, window group, etc
	 */
	__New() {
		global objRetype
		base.__New()

		strGroup 	:= this.id
		strRTP		:= % objRetype.objRTP.classNN()
		GroupAdd, %strGroup%, Add ahk_class %strRTP%, Voucher Quantity
		GroupAdd, %strGroup%, Update ahk_class %strRTP%, Voucher Quantity
	}

	/**
	 * Where the magic happens
	 * NOTE:
	 * -- 256 CHAR LIMIT PER FIELD
	 * -- Max usable 20 chars per ticket line
	 */
	pour() {
		global objRetype
		static intIterate := 4

		; Activate RTP (after toolbar has been clicked)
		objRetype.objRTP.Activate()
; @todo Check needs to be removed once I've managed to wall-in shortcuts in to the RTP only window
		; Run if it's ready!
		strGroup := this.__Class
		IfWinActive, ahk_group %strGroup%
		{
			; Did you execute from an RTP window?
			if ( objRetype.objRTP.isActive() ) {
				idWinRTP	:= WinActive("A")

				; This searches the screen for a VISUAL match against an image to check it can be seen!
				ImageSearch intX, intY, 170, 20, 350, 70, *100 %A_ScriptDir%\img\component_tab_voucherproduct.png

				if ( !intX or !intY ) {
					MsgBox.error( "Execution error: Attempted in wrong window or panel." )
					return
				}

				; Prompt for components and channels
				intIterate := InputBox.Show( "To how many more Sales Channels will we copy the output?", intIterate )

				; Clear the Clipboard
				clipboard = 

				; Botch around the fact that I cannot seem to apply focus to a SysListView32 control
				ControlFocus, Add, A
				Send {Up}{Space}
				; Open update window
				Send {Home}{Tab 2}{Space}
				; Wait for output window to actually load before proceeding
				WinWaitActive, Update Output
				; Move to label 1
				Send {Tab 4}
				; Copy box and pre-pend to next then copy again
				Loop 8
				{
					; Copy contents of text input
					Send ^a^c{Tab}{Home}
					; Prepend to next field, separate by field delimeter
					SendInput %clipboard%
					Sleep 5
					Send |
				}
				Send ^a^c{Tab 2}{Space}
				; Update next X sales channels
				Loop %intIterate%
				{
					; Open update window
					Send +{Tab 2}{Down}{Tab 2}{Space}
					; Wait for update window to open and activate
					WinWaitActive, Update Output
					; Tab to first label
					Send {Tab 4}
					; Iterate delimited clipboard and paste per label
					Loop, parse, clipboard, |
					{
						SendInput ^a{BackSpace}%A_LoopField%{Tab}
					}
					; Final tab on loop puts us on Update button, hit space to confirm
					Send {Space}
				}


			}
		}
	}

}
