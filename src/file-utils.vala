/* -*- Mode: vala; tab-width: 4; indent-tabs-mode: t -*- */
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

namespace Tabler {

	public errordomain FileError {
		COULD_NOT_READ
	}
	
	public void save_to_file (Arrangement arrangement, string filename)
		throws Error {		
		File file = File.new_for_path (filename);

		if (!file.query_exists ()) {
			Xml.Doc* doc = new Xml.Doc ("1.0");
			Xml.Node* node = arrangement.to_xml ();
			string xmlstr;

			// TODO: set a namespace
			doc->set_root_element (node);
			
			doc->dump_memory (out xmlstr);

			var dos =
				new DataOutputStream (file.create (FileCreateFlags.REPLACE_DESTINATION));
			var data = xmlstr.data;
			long written = 0;

			while (written < data.length) {
				written += dos.write (data[written:data.length]);
			}

			stdout.printf ("written %ld bytes\n", written);

			delete doc;
		} else {
			//TODO: throw an error
		}
	}

	public Arrangement? load_from_file (string filename)
		throws ParserError, FileError {
		Xml.Doc* doc = Xml.Parser.parse_file (filename);

		try {
			if (doc == null) {
				throw new FileError.COULD_NOT_READ (_("File doesn't exist, or could not be accessed."));
			}

			Xml.Node* root = doc->get_root_element ();
			if (root == null) {
				stderr.printf ("File is empty: %s\n", filename);
				throw new ParserError.INVALID (_("Error loading file"));
			}

			var parser = new ArrangementParser ();
			var arrangement = parser.create_from_xml (root);
			return arrangement;
		} finally {
			delete doc;
		}
	}
		
}