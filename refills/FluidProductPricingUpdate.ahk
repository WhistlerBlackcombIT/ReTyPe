/**
 * File containing Refill class to facilitate updating multiple pricing rows on a product header
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
objRetype.refill( new FluidProductPricingUpdate() )


/**
 * Refill to automatically update X pricing rows on a product header
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2015 Dominic Wrapson
 */
class FluidProductPricingUpdate extends Fluid {


	strHotkey		:= "^!u"
	strMenuPath		:= "/Admin/Product"
	strMenuText		:= "Pricing Update"
	intMenuIcon		:= 147


	/**
	 * Setup controls, window group, etc
	 */
	__New() {
		global objRetype
		base.__New()

		strGroup 	:= this.id
		strRTP		:= % objRetype.objRTP.classNN()
		GroupAdd, %strGroup%, Add ahk_class %strRTP%, Sales Report Group
		GroupAdd, %strGroup%, Update ahk_class %strRTP%, Sales Report Group
	}


	/**
	 * Where the magic happens
	 */
	pour() {
		global objRetype
		static intIterate := 1

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

				; Are we in the pricing tab of a product header?
				if ( Window.CheckVisibleTextContains( "sales report group", "pricing" ) ) {
					; Check which control has focus.  If it's not the pricing ListView then don't proceed
					if ( Window.CheckControlFocus( objRetype.objRTP.formatClassNN( "SysListView32", this.getConf( "PricingList", 11 ) ), "Pricing ListView" ) ) {

						; Detect PriceType selection for how we update the pricing with keystrokes
						 ;WindowsForms10.COMBOBOX.app.0.30495d1_r11_ad18
						strControlListPricing := objRetype.objRTP.formatClassNN( "COMBOBOX", this.getConf( "PricingType", 18 ) )
						ControlGet, strSelected, Choice, , %strControlListPricing%, A
						; Check if we can actually find the pricing type combo, and exit with error if not
						if ( 0 = StrLen( strSelected ) ) {
							MsgBox.Stop( "Could not determine pricing type, exiting" )
						}

						; Prompt for iteration count
						intPrice := InputBox.Show( "What's the NEW price?", 9999 )
						intIterate := InputBox.Show( "How many rows are we updating?", intIterate )

						; Loop around the specified number of times
						Loop %intIterate%
						{
							; Select row in ListView, right-click, choose Update
							SendInput {Space}{AppsKey}u
							; Wait for Pricing update window to load, max of 2 seconds then continue
							WinWait, Pricing, , 5
							; Send extra tabs for price by date
							if ( strSelected = "By Date") {
								SendInput {Tab 2}
							}
							; Send the new price for both unit and price
							SendInput %intPrice%{Tab}%intPrice%
							; Get to OK button, press it, move down a row
							SendInput {Tab 4}{space}{Down}
						}
					}
				}
			}
		}
	}


}