/**
 * File containing Refill class to add RTP comment
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
objRetype.refill( new FluidCommentAddDeclineChargeGuestSpoken() )


/**
 * Refill for RTP commenting
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2014 Dominic Wrapson
 */
class FluidCommentAddDeclineChargeGuestSpoken extends Fluid {
; @todo Make generic commenting class (with prompt), and extend to pass admin / config file editable sub-class

	strMenuPath		:= "/CusMan/Comments"
	strMenuText		:= "Guest Spoken To"
	intMenuIcon		:= 161

	pour() {
		global objRetype

		strRTP		:= % objRetype.objRTP.classNN()
		strGroup	:= this.__Class
		GroupAdd, %strGroup%, ahk_class %strRTP%

		; Activate RTP (after toolbar has been clicked)
		objRetype.objRTP.Activate()

		IfWinActive, ahk_group %strGroup%
		{
			; WinActive check isn't good enough in this case, so need to make a visual search too
			ImageSearch intActiveX, intActiveY, 20, 60, 60, 100, *50 %A_ScriptDir%\img\search_icon_customermanager.png
			if ( ErrorLevel ) {
				; At this point we are not in customer manager
				MsgBox.error( "Can only be run from within Customer Manager" )
			} else {
				; Name of contact
				strGuest		:= InputBox.show( "With whom did you speak?" )
; @todo: Check for blank input

				; Make sure in RTP, then find customer
				objRetype.objRTP.Activate()

				; Construct subject and comment
				strSubject = Phoned guest, spoke to %strGuest%
				strComment = Re: RC charge owing. Guest says they will contact their CC company and remove the hold. Will call us back when we can retry CC. %A_UserName% x7055

				; Add comment to profile
				objRetype.objRTP.CustomerAddComment( strSubject, strComment )
			}
		}
	}

}