/*
* Copyright (C) 2018  Calo001 <calo_lrc@hotmail.com>
* 
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU Affero General Public License as published
* by the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
* 
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU Affero General Public License for more details.
* 
* You should have received a copy of the GNU Affero General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>.
* 
*/

using App.Widgets;
using App.Connection;
using App.Structs;
using App.Connection;

namespace App.Views {

    /**
     * The {@code AppView} class.
     *
     * @since 1.0.0
     */
    public class AppView : Gtk.FlowBox {
        /**
         * Constructs a new {@code AppView} object.
         */
        public AppView () {
            this.margin_end = 10;
            this.margin_start = 10;
            this.set_selection_mode(Gtk.SelectionMode.SINGLE);
            this.activate_on_single_click = false;
            this.set_homogeneous (false);

            this.child_activated.connect( (child)=>{
                var card = (CardPhotoView) child.get_child();
                card.popup.set_visible (true);
            });
        }

        /********************************************
           Method to insert new photos from a list
        ********************************************/
        public void insert_cards (List<Photo?> photos) {
            // A simple solution to sort photos by height
            photos.sort(compare);

            foreach (var photo in photos) {
                // if the user wants, we can show only
                // the landscape or only the portrait images.

                float aspect_ratio = photo.width / photo.height;
                if (aspect_ratio < 1) {
                    continue;
                }

                var card = new CardPhotoView (photo);
                card.valign = Gtk.Align.START;
                this.add(card);
                card.show_all();
            }
        }

        CompareFunc<Photo?> compare = (a, b) => {
            double c = (int) a.width / (int) a.height;
            double d = (int) b.width / (int) b.height;
            return (int) (c > d) - (int) (c < d);
        };
    }
}
