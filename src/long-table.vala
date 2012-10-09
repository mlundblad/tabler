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

using GLib;

public class Tabler.LongTable : Tabler.Table, Tabler.XmlSerializable {

	public enum Orientation {
		HORIZONTAL,
		VERTICAL
	}

	public class Setting : GLib.Object, XmlSerializable {
		// true if "up" long-side for a horizontal, or "left" side for a verical
		// table is set up for seating
		public bool up { get; construct; }

		// true if "down"/"right" long-side is set up for seating
		public bool down { get; construct; }

		// true if "left"/"up" short-end is set up for seating
		public bool left { get; construct; }

		// true if "right"/"down" short-end is set up for seating
		public bool right { get; construct; }
		
		public Setting (bool up = true, bool down = true,
		                bool left = false, bool right = false) {
			Object (up: up, down: down, left: left, right: right);
		}

		public Xml.Node* to_xml () {
			Xml.Node* node = new Xml.Node(null, "setting");

			node->new_prop ("up", up.to_string ());
			node->new_prop ("down", down.to_string ());
			node->new_prop ("left", left.to_string ());
			node->new_prop ("right", right.to_string ());

			return node;
		}
	}
	
	public Orientation orientation { get; private set; }
	public Setting setting { get; private set; }
	
    // Constructor
    public LongTable (uint capacity, Orientation orientation, Setting setting) {
        base (capacity);
		this.orientation = orientation;
		this.setting = setting;
    }

	public override void get_extents (out uint width, out uint height) {
		uint seats_long = capacity;

		if (setting.left)
			seats_long--;

		if (setting.right)
			seats_long--;

		uint length = seats_long / 2 * 5;
		uint breadth = (1 + (setting.up ? 1 : 0) + (setting.down ? 1 : 0)) * 5;

		if (orientation == Orientation.HORIZONTAL) {
			width = length;
			height = breadth;
		} else {
			width = breadth;
			height = length;
		}
	}

	public override Xml.Node* to_xml () {
		Xml.Node* node = base.to_xml ();

		node->new_prop ("type", "long");
		node->new_prop ("orientation",
		                orientation == Orientation.HORIZONTAL ?
		                "horizontal" : "vertical");
		node->add_child (setting.to_xml ());

		return node;
	}
}
