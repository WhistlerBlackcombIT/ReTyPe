/**
 * Abstract (if it was supported) base class for objects that will make a decision
 * as to whether or not they will return a false on failure or just exit the thread
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
 * @copyright	Copyright (C) 2013 Dominic Wrapson
 * @license 	GNU AFFERO GENERAL PUBLIC LICENSE http://www.gnu.org/licenses/agpl-3.0.txt
 */

class _returnableClass {
;Abstract keyword not supported, therefore underscore _prefix signifies internally

	static RETURN_ON_USER_CANCEL := False

	_RETURN_ON_USER_CANCEL() {
		return this.RETURN_ON_USER_CANCEL
	}

}