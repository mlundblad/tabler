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

public class Tabler.LongTableParser : GLib.Object {

    public LongTable? create_from_xml (Xml.Node* node)
		requires (node->name == "table" && node->get_prop ("type") == "long") {
		var capacity = node->get_prop ("capacity");
		if (capacity == null) {
			stderr.printf ("<table/> must have a capacity set\n");
			return null;
		}

		var orientation_attr = node->get_prop ("orientation");
		if (orientation_attr == null) {
			stderr.printf ("Table of type \"long\" must specify an orientation\n");
			return null;
		}

		LongTable.Orientation orientation;
		switch (orientation_attr) {
			case "horizontal":
				orientation = LongTable.Orientation.HORIZONTAL;
				break;
			case "vertical":
				orientation = LongTable.Orientation.VERTICAL;
				break;
			default:
				stderr.printf ("Unknow orientation: %s\n", orientation_attr);
				return null;
		}

		var setting = new LongTable.Setting ();

		for (var iter = node->children ; iter != null ; iter = iter->next) {
			if (iter->type == Xml.ElementType.ELEMENT_NODE &&
			    iter->name == "setting") {
				setting = create_setting_from_xml (iter);
			}
		}
			  
		return new LongTable (int.parse (capacity), orientation, setting);
	}

	private LongTable.Setting create_setting_from_xml (Xml.Node* node)
		requires (node->name == "setting") {
		bool up = true;
		bool down = true;
		bool left = false;
		bool right = false;

		var up_attr = node->get_prop ("up");
		var down_attr = node->get_prop ("down");
		var left_attr = node->get_prop ("left");
		var right_attr = node->get_prop ("right");

		if (up_attr != null) {
			up = bool.parse (up_attr);
		}
		if (down_attr != null) {
			down = bool.parse (down_attr);
		}
		if (left_attr != null) {
			left = bool.parse (left_attr);
		}
		if (right_attr != null) {
			right = bool.parse (right_attr);
		}

		return new LongTable.Setting (up, down, left, right);
	}
}
