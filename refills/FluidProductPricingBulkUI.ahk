/**
 * File containing Refill class to add text-searching for access codes to components
 * Class will add itself to the parent retype instance
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
 * @copyright	Copyright (C) 2015 Dominic Wrapson
 * @license 	GNU AFFERO GENERAL PUBLIC LICENSE http://www.gnu.org/licenses/agpl-3.0.txt
 */


; Trigger my damn self (in a horrible way due to AHK limitations)
objRetype.refill( new FluidProductPricingBulkUI() )

/**
 * Refill that resizes combo-box in bulk pricing window to make pricing seasons legible
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2014 Dominic Wrapson
 */
class FluidProductPricingBulkUI extends Fluid {

	static intTimer	:= 500

	/**
	 * Triggered when appropriate window conditions met
	 */
	pour() {
		global objRetype

		strRTP		:= % objRetype.objRTP.classNN()
		strGroup	:= this.__Class
		GroupAdd, %strGroup%, Product Header Pricing Bulk Update ahk_class %strRTP%, Selected Price Update Details

		; BULK PRICING:	Resize the pricing season drop-down
		IfWinActive, ahk_group %strGroup%
		{
			if ( Window.CheckActiveProcess( "rtponecontainer" ) ) {
				strControl := objRetype.objRTP.formatClassNN( "COMBOBOX", this.getConf( "ComboBox", 11 ) )
				ControlMove, %strControl%, , , 400, , A
			}
		}
	}

}