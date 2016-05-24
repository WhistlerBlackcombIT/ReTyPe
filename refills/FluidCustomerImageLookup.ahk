/**
 * File containing Refill class to find a customer image
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
objRetype.refill( new FluidCustomerImageLookup() )


/**
 * Refill to load a customer's image in a browser, searching by IP code
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2015 Dominic Wrapson
 */
class FluidCustomerImageLookup extends Fluid {

	;strHotkey		:= "^+i"
	strMenuPath		:= "/CusMan"
	strMenuText		:= "Customer Image"
	intMenuIcon		:= 265 ;272

	/**
	 * Where the magic happens
	 */
	pour() {
		intIP := InputBox.show( "Enter IP code to find image" )

		;Run, http://wbwebapps/wbphonelist/grabimage.aspx?RTPImage=True&ID=%intIP% ; Doesn't work in Chrome
		Run, http://wbapps/RTPImageFetch/?ipcode=%intIP%
	}

}