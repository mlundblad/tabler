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

    public Guest? create_from_xml (Xml.Node* node)
		requires (node->name == "guest") {
		var name = node->get_prop ("name");
		var gender = node->get_prop ("gender");
		var vip = node->get_prop ("vip");

		if (name == null) {
			stderr.printf ("A guest must have a name set\n");
			return null;
		}

		return new Guest (name, gender == null ? Gender.UNKNOWN :
			                  gender == "male" ? Gender.MALE :
			                  gender == "female" ? Gender.FEMALE :
			                  Gender.UNKNOWN, bool.parse (vip));
	}
}
