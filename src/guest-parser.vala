/* -*- Mode: vala; tab-width: 4; intend-tabs-mode: t -*- */
/* tabler
 *
 * Copyright (C) Marcus Lundblad 2012 <ml@update.uu.se>
 *
tabler is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * tabler is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

public class Tabler.GuestParser : GLib.Object {

    public Guest create_from_xml (Xml.Node* node) throws ParserError
		requires (node->name == "guest") {
		var id = node->get_prop ("id");
		var name = node->get_prop ("name");
		var gender = node->get_prop ("gender");
		var child = node->get_prop ("child");
		var vip = node->get_prop ("vip");
		var rsvp = node->get_prop ("rsvp");

		if (id == null) {
			throw new ParserError.INVALID (_("A guest must have an ID set."));
		}
		if (name == null) {
			throw new ParserError.INVALID (_("A guest must have a name set."));
		}

		return new Guest.with_id (int.parse (id),
		                          name, gender == null ? Gender.UNKNOWN :
			              		  gender == "male" ? Gender.MALE :
			              	      gender == "female" ? Gender.FEMALE :
			                      Gender.UNKNOWN,
			                      bool.parse (child ?? "false"),
			          			  bool.parse (vip ?? "false"),
			                      bool.parse (rsvp ?? "false"));
	}
}
