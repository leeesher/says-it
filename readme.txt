Sample Generators

by Ryland Sanders

(Church sign photo provided courtesy of Stewart Signs)

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

This package is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation; either version 2 of the License, or (at your option) any later
version.

This package is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
details.

You should have received a copy of the GNU General Public License along with
this package; if not, write to the Free Software Foundation, Inc., 51 Franklin
Street, Fifth Floor, Boston, MA  02110-1301, USA.

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

This package uses PHP for HTML form processing, Perl for the generator scripts
themselves, and ImageMagick for image processing. Your server must have recent
versions of these in order to use this package. The scripts have been tested
and are known to work with ImageMagick version 6.4.6; earlier version of
ImageMagick may not (probably won't) work.

Installation:

There's no installation as such; just transfer all the files and directories
to a directory on your web server somewhere under the document root, set the
permissions on the .pl files to be executable, and as long as your server is
configured correctly, it should all just work.

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

I included two example generators in this package, a badge and a church sign.
Between the two, they cover every important technique I use for generators on
Says-it.com. I removed some options for simplicity and clarity; for example, I
normally have some code at the top of the generator script to discourage
hotlinking. I also removed the color pickers from the HTML forms, because it
requires a library of Javascript files and images, and I didn't want to
include that with the package. Other than that, the generators in this package
work exactly as the generators on the site work.

If it's not obvious, half of the work of creating an image generator isn't
programming, it's preparing the source images.

I created the badge art in Adobe Illustrator. The design is copied from the
S.H.I.E.L.D. badge shown in the credits at the end of Iron Man (2008).

The church sign in the photo is manufactured by Stewart Signs, who were kind
enough to provide most of the source photos I used. I edited the photo in
Adobe Photoshop to remove any existing lettering and to do some minor color
correction. This involved removing some reflections from the plastic housing
the signs are in, so I added those back by taking a photo of a tree-lined
street, converting it to black and white, extracting highlights and shadows,
and creating an overlay that looks like a reflection, which is composited onto
the sign image in the final step. A couple of signs also needed additional
shadow overlays to replace shadows of tree leaves or electrical wires. I could
have left these out, but I felt like the reflections and shadows really help
sell the illusion.

Another thing I did was create several fonts that resemble popular styles of
sign board lettering for use with the church sign generator and other sign
board generators on Says-it.com. These fonts, along with a couple of others
I've done, are available for free at:

http://www.aboyandhiscomputer.com/fonts.php

If you have any questions or comments about this package, you can write
to me at ryland@says-it.com. I also recommend you look at the documentation
for ImageMagick at:

http://www.imagemagick.org/

If you're looking for a good book to help you along, I highly recommend
Perl Graphics Programming, written by Shawn Wallace and published by
O'Reilly.