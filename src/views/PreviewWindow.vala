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

using App.Structs;
using App.Utils;
using App.Connection;
using Granite.Widgets;

namespace App.Views {

    /**
     * The {@code PreviewWindow} class.
     *
     * @since 1.0.0
     */

    public class PreviewWindow : Gtk.Window {
        private Granite.AsyncImage      image;
        private Gtk.ProgressBar         bar;
        private Gtk.Stack               stack;
        private AppConnection           connection;
        private Photo                   photo;
        private Toast                   toast;
        private int                     w_photo;
        private int                     h_photo;
        public  Wallpaper               wallpaper {get; set;}
        public signal void closed_preview ();

        public PreviewWindow (Photo photo) {
            this.connection = AppConnection.get_instance();
            this.w_photo = (int) photo.width;
            this.h_photo = (int) photo.height;
            this.photo = photo;
            get_style_context ().add_class ("prev-window");

		    fullscreen ();

            // Detect ESC key to close window
            this.key_press_event.connect ((e) => {
                uint keycode = e.hardware_keycode;
                print ("Key" + keycode.to_string());
                    if (keycode == 9) {
                         close ();
                     }
                return true;
            });

            this.destroy.connect (() => {
                closed_preview ();
		    });

            // Loading label
            var label = new Gtk.Label(_("Loading ..."));
            label.get_style_context ().add_class ("h1");
            label.get_style_context ().add_class ("label_loading");
            bar = new Gtk.ProgressBar ();

            // Container
            var box = new Gtk.Box(Gtk.Orientation.VERTICAL, 20);
            box.valign = Gtk.Align.CENTER;
            box.halign = Gtk.Align.CENTER;
            box.pack_start(label, true, true, 0);
            box.pack_start(bar, true, true, 0);

            // Image
            var box_img = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
            box_img.valign = Gtk.Align.START;
            box_img.halign = Gtk.Align.CENTER;
            toast = new Toast ("Press Esc to Exit");
            image = new Granite.AsyncImage ();
            box_img.pack_start(toast, true, true, 0);
            box_img.pack_end(image, true, true, 0);

            // Stack
            stack = new Gtk.Stack();
            stack.set_transition_duration (500);
            stack.set_transition_type (Gtk.StackTransitionType.CROSSFADE);

            stack.add_named (box, "box");
            stack.add_named (box_img, "image");
            stack.set_visible_child_name ("box");

            this.add (stack);
        }

        /****************************
            Method to setup the window
            * Get direct url photo
            * Resize the image to current screen
            * Show message (ESC to exit)
        *****************************/
        public void load_content () {
            string? url_photo = connection.get_url_photo(photo.links_download_location);
            wallpaper = new Wallpaper(url_photo, photo.id, photo.username, bar);
            wallpaper.download_picture ();
            var path_wallpaper = wallpaper.full_picture_path;

            // Create File Object
            var file_photo = File.new_for_path (path_wallpaper);

            // Calc Screen Width & Heigth
            int w_screen;
            int h_screen;
            this.get_size (out w_screen, out h_screen);
            if (w_photo > w_screen) {
                scale (w_photo, w_screen);
                if (h_photo > h_screen) {
                    scale (h_photo, h_screen);
                }
            }
            // Show image
            image.set_from_file_async.begin (file_photo, w_photo, h_photo, true);
            stack.set_visible_child_name ("image");

            // Show Toast
            toast.send_notification ();
            toast.margin = 0;
        }

        /***************************
        Recived a size original and a standar size
        * monitor_scale get a decimal to resize a photo
        ****************************/
        private void scale (int w_h_photo, int w_h_screen) {
            double monitor_scale = (double) w_h_screen / (double) w_h_photo;
            w_photo = (int)(w_photo * monitor_scale);
            h_photo = (int)(h_photo* monitor_scale);
        }
    }

}
