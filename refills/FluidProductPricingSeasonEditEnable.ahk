/**
 * File containing Refill class to enable season editing when updating pricing
 *
 * AutoHotKey v1.1.13.01+
 *
 * LICENSE:
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.

 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * @category  	Automation
 * @package   	ReTyPe
 * @author    	Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	Copyright (C) 2014 Dominic Wrapson
 * @license 	GNU AFFERO GENERAL PUBLIC LICENSE http://www.gnu.org/licenses/agpl-3.0.txt
 */


; Trigger my damn self (in a horrible way due to AHK limitations)
objRetype.refill( new FluidProductPricingSeasonEditEnable() )


/**
 * Refill for enabling season editing in price update
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2014 Dominic Wrapson
 */
class FluidProductPricingSeasonEditEnable extends Fluid {

	static intTimer		:= 500

	pour() {
return
; DISABLE THIS REFILL UNTIL WE KNOW ENABLING THE COMBO AND SAVING DOESN'T BREAK A HEAP OF STUFF



		; BULK PRICING:	Resize the pricing season drop-down
		strGroup := this.__Class
		GroupAdd, %strGroup%, Pricing ahk_class WindowsForms10.Window.8.app.0.30495d1_r11_ad1, Price Allocation

		IfWinActive, ahk_group %strGroup%
		{
			strControl = WindowsForms10.COMBOBOX.app.0.30495d1_r11_ad11
			ControlGet, blnCtl, Enabled,, %strControl%
			if ( !blnCtl ) {
				WinGetPos, intWinX, intWinY,,,
				ControlGetPos, intCtlX, intCtlY,,, %strControl%,
				intGuiX := intWinX + intCtlX -53
				intGuiY := intWinY + intCtlY -1
				Gui, Pricing:Add, Button, x0 y0 gfnEnablePricingSeasonCombo, Enable?
				Gui, Pricing:Margin, 0, 0
				Gui, Pricing:-SysMenu +ToolWindow -Caption -Border +AlwaysOnTop
				Gui, Pricing:Show, NA x%intGuiX% y%intGuiY%
			}
		}
		IfWinNotExist, ahk_group %strGroup%
		{
			Gui, Pricing:Hide
		}
		return

		/**
		 * Adds a border-less UI with a single button next to the disabled Pricing combobox
		 * Appears to "add" a button to the UI when in fact it floats above it but never steals focus
		 * Now that's MAGIC!
		 */
		fnEnablePricingSeasonCombo:
			WinGet, idWin, ID, Pricing ahk_class WindowsForms10.Window.8.app.0.30495d1_r11_ad1, Price Allocation

			strControl = WindowsForms10.COMBOBOX.app.0.30495d1_r11_ad11
			Control, Enable, , %strControl%, ahk_id %idWin%
			WinActivate, Pricing ahk_id %idWin%

			Gui, Pricing:Hide
		return
	}

}