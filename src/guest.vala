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

	private static uint next_id = 1;
	
	public uint id { get; set; }
	public string name { get; set; }
	public Gender gender { get; set; }
	public bool vip { get; set; }
	public bool rsvp { get; set; }
	private Gee.HashMap<Guest, Relation> relations =
		new Gee.HashMap<Guest, Relation> ();

	private static Gee.HashMap<uint, weak Guest> guest_map =
		new Gee.HashMap<uint, weak Guest> ();

	public static Guest? find_by_id (uint id) {
		return guest_map.get (id);
	}
	
    // Constructor
    public Guest (string name, Gender gender = Gender.UNKNOWN,
                  bool vip = false, bool rsvp = false) {
		Object (id: next_id, name: name, gender: gender, vip: vip, rsvp: rsvp);
		guest_map.set (next_id, this);
		next_id++;
    }

	public Guest.with_id (uint id, string name, Gender gender = Gender.UNKNOWN,
	                      bool vip = false, bool rsvp = false) {
		Object (id: id, name: name, gender: gender, vip: vip, rsvp: rsvp);
		guest_map.set (id, this);
		if (id > next_id) {
			next_id = id + 1;
		}
	}

	~Guest () {
		guest_map.unset (this.id);
	}

	public void set_relation_to (Guest to, Relation relation) {
		relations.set (to, relation);
	}

	public void remove_relation_to (Guest to) {
		relations.unset (to);
	}

	public bool has_relation_to (Guest to) {
		return relations.has_key (to);
	}
	
	public Relation get_relation_to (Guest to) {
		return relations.get (to);
	}

	public Xml.Node* to_xml () {
		Xml.Node* node = new Xml.Node (null, "guest");

		node->new_prop ("id", id.to_string ());
		node->new_prop ("name", name);
		node->new_prop ("gender",
		                gender == Gender.MALE ? "male" :
			            gender == Gender.FEMALE ? "female" : "unknown");
		node->new_prop ("vip", vip.to_string ());
		node->new_prop ("rsvp", rsvp.to_string ());

		// add node for relations
		Xml.Node* relations_node = node->add_child ("relations");

		foreach (var guest in guest_map.values) {
			if (has_relation_to (guest)) {
				Xml.Node* relation_node = relations_node->add_child ("relation");
				var relation = get_relation_to (guest);

				relation_node->new_prop ("to", guest.id.to_string ());
				relation_node->new_prop ("type", relation == Relation.NEXT_TO ?
				                         "next_to" : relation == Relation.NEAR_TO ?
				                     	 "near_to" : relation == Relation.NOT_NEXT_TO ?
				                         "not_next_to" : "not_near_to");
			}
		}
		
		return node;
	}
}
