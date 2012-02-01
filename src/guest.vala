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

public class Tabler.Guest : GLib.Object, Tabler.XmlSerializable {

	public string name { get; set; }
	public Gender gender { get; set; }
	
    // Constructor
    public Guest (string name, Gender gender = Gender.UNKNOWN) {
        this.name = name;
		this.gender = gender;
    }

	public Xml.Node* to_xml () {
		Xml.Node* node = new Xml.Node (null, "guest");
	
		node->new_prop ("name", name);
		node->new_prop ("gender",
		                gender == Gender.MALE ? "male" :
			            gender == Gender.FEMALE ? "female" : "unknown");

		return node;
	}
}
