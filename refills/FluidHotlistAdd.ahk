/**
 * File containing Refill class to add hotlists
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
objRetype.refill( new FluidHotlistAdd() )


/**
 * Refill for RTP hotlisting
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2014 Dominic Wrapson
 */
class FluidHotlistAdd extends Fluid {

	;strHotkey		:= "^!+c"
	strMenuPath		:= "/CusMan"
	strMenuText		:= "Add Hotlist"
	intMenuIcon		:= 110

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
msgbox.stop( "Functionality still under construction!" )
				; In customer manager, let's rock
				intIP 			:= InputBox.show( "Enter IP code on which to comment" )

				; Hunt down the customer
				objRetype.objRTP.CustomerSearchAndSelect( intIP )
return
; @todo SOME CHECKS: Make sure customer is an adult, etc, if PassAdmin want to, else let them decide first and just hit hotlist as appropriate
/*
				blnLoadedPassMediaProfile := _screenImageSearch( 100, 100, 500, 200, "img\search_cusman_passmediaprofile.png" )
				if ( !blnLoadedPassMediaProfile )
				{
					_rtpCustomerResetTreeview()

					; Navigate to Pass Media Profile
					SendInput {Down 3}{Right}{Down}
					; Wait for the damn thing to finish
					Loop {
						Sleep 500

						ControlFocus, WindowsForms10.BUTTON.app.0.30495d1_r11_ad14, ahk_id %idWinRTP%
						If ErrorLevel
						{
							SB_SetText( "Still cannot focus" )
							continue
						}

						If ( "Wait" = %A_Cursor% ) {
							SB_SetText( "Cursor is still wait!" )
							continue
						}

						if ( !_screenImageSearch( 290, 110, 460, 150, "img\cussearch_cusman_smediaprofile.png" ) )
						{
							SB_SetText( "Search still active!" )
							continue
						}

						SB_SetText( "Waiting..." )
						break
					}
				} else {
					ControlFocus, WindowsForms10.BUTTON.app.0.30495d1_r11_ad14, ahk_id %idWinRTP%
				}
*/
				; Move to first pass in list
				Send {Tab 2}
				; Find out which control it is so we can click it (neither space nor enter will click open the profile)
				ControlGetFocus, strControlFocus, ahk_id %idWinRTP%
				Sleep 500
				;ControlClick, %strControlFocus%, ahk_id %idWinRTP%

			; @todo check pass number begins with "(50" otherwise tab to next, check, repeat

				; Seeing as apparently Control Click doesn't work either (RTP controls are such shit)
				; we're instead going to have to literally click on it
				ControlGetPos, intX, intY,,, %strControlFocus%, ahk_id %idWinRTP%
				intX := intX+5
				intY := intY+5
				Click %intX%, %intY%

				; Wait for it to open
				WinWait, Pass Media Profile, 5

				; Now the damn thing is finally open
				;
				; Select hotlist reason
				strControl := objRetype.objRTP.formatClassNN( "COMBOBOX", this.getConf( "ComboBox", 16 ) )
				Control, ChooseString, Autocharge Problem, %strControl%

				;intTomorrow := A_MM . "/" . A_DD+1 . "/" . A_YYYY
				;SendInput {Tab 5}%intTomorrow%

				SendInput {Tab 5}{Right}{Up}
				SendInput {Tab}Pass hotlisted, problem processing charges. Please see comments on file. %A_UserName% x7055


			; @todo Add timeout 5? seconds, if no input, close and save
				SendInput {Tab}{Space}
				; Auto apply hotlist?
				SendInput {Tab 2}{Space}
			return
			}
		}
	}

}