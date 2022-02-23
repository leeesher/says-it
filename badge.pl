#!/usr/bin/perl

# badge.pl
# Copyright (C) 2008, Ryland Sanders
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

use Image::Magick;
use CGI qw(:standard);
use utf8;

if (param()) {
	$text1 = param('text1');
	$text2 = param('text2');
	$imgbgcolor = uc(param('imgbgcolor'));
	$shieldfgcolor = uc(param('shieldfgcolor'));
	$shieldbgcolor = uc(param('shieldbgcolor'));
	$fgcolor = uc(param('fgcolor'));
	$emblemfgcolor = uc(param('emblemfgcolor'));
	$emblembgcolor = uc(param('emblembgcolor'));

	$font = param('font') + 0;
	$tsize = param('tsize') + 0;
	$tshift = param('tshift') + 0;
	$outline = param('outline') + 0;

	$download = param('download');
}

utf8::decode($text1);
utf8::decode($text2);

if (!$text1 && !$text2) {
	$text1 = "ENTER SOME";
	$text2 = "TEXT TO BEGIN";
}

if ($outline > 1) { $outline = 1; }
if ($outline < 0) { $outline = 0; }

# filter out non-hex color codes
$imgbgcolor =~ s/[^a-f0-9]//gi;
$shieldfgcolor =~ s/[^a-f0-9]//gi;
$shieldbgcolor =~ s/[^a-f0-9]//gi;
$fgcolor =~ s/[^a-f0-9]//gi;
$emblemfgcolor =~ s/[^a-f0-9]//gi;
$emblembgcolor =~ s/[^a-f0-9]//gi;

# replace invalid or missing colors with defaults
if (!$imgbgcolor || length($imgbgcolor) != 6) { $imgbgcolor = 'FFFFFF'; }
if (!$shieldfgcolor || length($shieldfgcolor) != 6) { $shieldfgcolor = '000000'; }
if (!$shieldbgcolor || length($shieldbgcolor) != 6) { $shieldbgcolor = 'FFFFFF'; }
if (!$fgcolor || length($fgcolor) != 6) { $fgcolor = '000000'; }
if (!$emblemfgcolor || length($emblemfgcolor) != 6) { $emblemfgcolor = '000000'; }
if (!$emblembgcolor || length($emblembgcolor) != 6) { $emblembgcolor = 'FFFFFF'; }

# we need the value of pi and 1 radian for calculations
$pi = 4 * atan2 1, 1;
$rad = $pi / 180;

# base image size
$imgwidth = 370;
$imgheight = 380;
$imgwidthx3 = 1110;
$imgheightx3 = 1140;
$imgsize = $imgwidth.'x'.$imgheight;
$imgsizex3 = $imgwidthx3.'x'.$imgheightx3;

# create the base image
$base = Image::Magick->new;
$base->Set(size=>"$imgsize");
$base->Read("xc:#$imgbgcolor");

# create an image for use as a 'paint' color and fill it with the
# shield background fill color
$tint = Image::Magick->new;
$tint->Set(size=>"$imgsize",matte=>'True');
$tint->Read("xc:#$shieldbgcolor");

# load the badge fill image. it's a greyscale GIF, and we'll use it sort
# of like a stencil.
$shieldbgmask = Image::Magick->new;
$shieldbgmask->Set(size=>"$imgsize");
$shieldbgmask->Read('images/badge-fill.gif');

# apply the fill image as an alpha transparency mask to the tint image
# and composite onto the base image
$tint->Composite(image=>$shieldbgmask, compose=>'CopyOpacity');
$base->Composite(image=>$tint,compose=>'Over',x=>0,y=>0,gravity=>'NorthWest');
undef $shieldbgmask;

# fill the tint image with the shield foreground stroke color
$tint->Draw(primitive=>"rectangle",points=>"0,0 $imgwidth,$imgheight",fill=>"#$shieldfgcolor");

# load the shield foreground stroke image
$shieldfgmask = Image::Magick->new;
$shieldfgmask->Set(size=>"$imgsize");
$shieldfgmask->Read('images/badge-stroke.gif');

# apply the stroke image to the tint image as a mask
# and composite onto the base image over the fill
$tint->Composite(image=>$shieldfgmask, compose=>'CopyOpacity');
$base->Composite(image=>$tint,compose=>'Over',x=>0,y=>0,gravity=>'NorthWest');
undef $shieldfgmask;

# fill the tint image with the emblem color
$tint->Draw(primitive=>"rectangle",points=>"0,0 $imgwidth,$imgheight",fill=>"#$emblemfgcolor");

# load the emblem image
$emblemimg = Image::Magick->new;
$emblemimg->Set(size=>"$imgsize");
$emblemimg->Read("images/eagle.gif");

# apply the emblem image to the tint image as a mask
# and composite onto the base
$tint->Composite(image=>$emblemimg, compose=>'CopyOpacity');
$base->Composite(image=>$tint,compose=>'Over',x=>0,y=>0,gravity=>'NorthWest');

undef $emblemimg;

# create an image for the text arcs. this image will be 3x larger than
# the base image, because ImageMagick places the origin of a text annotation
# at the nearest whole pixel. while this is normally no problem, when you're
# placing each letter individually it leads to weird spacing.
# we make the image larger so that the errors don't show as much, and
# then resize it to fit onto the base.
$textimg = Image::Magick->new;
$textimg->Set(size=>"$imgsizex3");
$textimg->Read("xc:none");

# define our center point
$xc = 555;
$yc = 570;

if ($tsize > 2) { $tsize = 2; }
if ($tsize < -2) { $tsize = -2; }
if ($tshift > 5) { $tshift = 5; }
if ($tshift < -5) { $tshift = -5; }

$fontname = "fonts/Alternate_Gothic_No_2_BT.ttf";

# load an external file that contains the width and kerning
# values for this font, so that letters will be spaced properly
# along the arc path
require "fonts/Alternate_Gothic_No_2_BT.pl";

# the relation of point size to pixels is kind of complicated. this set
# of calculations determines the proper point size by getting the
# maximum vertical space (the difference between the diameters of inner
# and outer radiuses of the text arc, and adjusting for the user
# choices for text size and baseline shift.

$inner_radius = 284 - $tsize * 9;
$outer_radius = 409 + $tsize * 9;

$max_height = $outer_radius - $inner_radius;

$font_height = $ttftop - $ttfbottom;
$unit_multiplier = $font_height / $max_height;
$point_size_multiplier = $font_height / 1000;

$point_size = $max_height / $point_size_multiplier;
$baseline_height = abs($ttfbottom) / $unit_multiplier;

$radius1 = $inner_radius + $baseline_height + $tshift * 3;
$radius2 = $outer_radius - $baseline_height - $tshift * 3;

$circumference1 = 2 * $radius1 * $pi * $unit_multiplier;
$circumference2 = 2 * $radius2 * $pi * $unit_multiplier;

$arc_multiplier1 = 360 / $circumference1;
$arc_multiplier2 = 360 / $circumference2;

# start on the upper text arc
if (length($text1)) {
	$arc1 = 0;
	$text1t = "";
	$i = 0;
	# loop through the string of text and get the width
	# for each character and the kerning value between it
	# and the next character, if any. the sum of these
	# values gives us a total arc length for this arc in
	# pixels. if it goes over the maximum (a complete circle)
	# the string is truncated.
	while ($i < length($text1) && $arc1 < $circumference1) {
		$width = 0;
		if ($wx[ord(substr($text1,$i,1))] > 0) {
			$width = $wx[ord(substr($text1,$i,1))];
		}
		$text1t .= substr($text1,$i,1);
		$arc1 += $width;
		$i++;
	}

	# the arc offset is the starting angle at which we start
	# to draw letters. It's half the arc offset (which centers
	# the text on the arc) plus 90 degrees.
	$arc_offset = ($arc1 / 2 * $arc_multiplier1) + 90;
	$arc1 = 0;

	# start drawing letters
	for ($i = 0; $i < length($text1t); $i++) {
		# grab the current character
		$char = substr($text1t, $i, 1);

		# get the width of the character (its ordinal value
		# corresponds with the index of an array in the font
		# info file mentioned earlier). we add half this width
		# now, and half after drawing the character, so that
		# the character is centered rather than left-aligned
		# at the current position on the arc.
		$arc1 += $wx[ord($char)] / 2;
		$arc = ($arc1 * $arc_multiplier1) - $arc_offset;

		# calculate where to put the letter
		$x = $radius1 * cos($arc * $rad);
		$y = $radius1 * sin($arc * $rad);

		# if the text is to be outlined rather than solid,
		# we draw the letter twice, once in the foreground color
		# with a large border, and once over the top of the first
		# letter in the shield background color. this is because
		# simply setting the stroke width in the Annotate method
		# produces unsatisfactory results; the stroke on sharp corners
		# tends to bleed over into the fill area of the character.
		if ($outline) {
			$textimg->Annotate(text=>$char,font=>$fontname,pointsize=>$point_size,antialias=>'true',align=>"Center",stroke=>"#$fgcolor",strokewidth=>9,fill=>"#$fgcolor",x=>$xc+$x,y=>$yc+$y,rotate=>$arc + 90);
			$textimg->Annotate(text=>$char,font=>$fontname,pointsize=>$point_size,antialias=>'true',align=>"Center",fill=>"#$shieldbgcolor",x=>$xc+$x,y=>$yc+$y,rotate=>$arc + 90);
		} else {
			$textimg->Annotate(text=>$char,font=>$fontname,pointsize=>$point_size,antialias=>'true',align=>"Center",fill=>"#$fgcolor",x=>$xc+$x,y=>$yc+$y,rotate=>$arc + 90);
		}

		# add the other half of the width value plus the kern
		# width, if any, to the arc position
		$arc1 += $wx[ord($char)] / 2 + $kpx[ord(substr($text1t,$i,1))][ord(substr($text1t,$i+1,1))];
	}
}

# the second, lower arc works exactly the same as the upper arc, except
# that the angles are reversed, and spacing is increased a bit to
# compensate. the width value is increased by 10% (multiplied
# by 1.1) when it's added to the arc position.
if (length($text2)) {
	$arc2 = 0;
	$text2t = "";
	$i = 0;
	while ($i < length($text2) & $arc2 < $circumference2) {
		$width = 0;
		if (substr($text2,$i,1) eq '*' && $asterisk > 0) {
			$width = $asteriskwidths[$asterisk];
		} else {
			if ($wx[ord(substr($text2,$i,1))] > 0) {
				$width = $wx[ord(substr($text2,$i,1))] * 1.1;
			}
		}
		$text2t .= substr($text2,$i,1);
		$arc2 += $width;
		$i++;
	}

	$arc_offset = ($arc2 / 2 * $arc_multiplier2) + 90;
	$arc2 = $circumference2;

	for ($i = 0; $i < length($text2t); $i++) {
		$char = substr($text2t, $i, 1);
		$arc2 -= ($wx[ord($char)] / 2) * 1.1;
		$arc = ($arc2 * $arc_multiplier2) + $arc_offset;
		$x = $radius2 * cos($arc * $rad);
		$y = $radius2 * sin($arc * $rad);
		if ($outline) {
			$textimg->Annotate(text=>$char,font=>$fontname,pointsize=>$point_size,antialias=>'true',align=>"Center",stroke=>"#$fgcolor",strokewidth=>9,fill=>"#$fgcolor",x=>$xc+$x,y=>$yc+$y,rotate=>$arc - 90);
			$textimg->Annotate(text=>$char,font=>$fontname,pointsize=>$point_size,antialias=>'true',align=>"Center",fill=>"#$shieldbgcolor",x=>$xc+$x,y=>$yc+$y,rotate=>$arc - 90);
		} else {
			$textimg->Annotate(text=>$char,font=>$fontname,pointsize=>$point_size,antialias=>'true',align=>"Center",fill=>"#$fgcolor",x=>$xc+$x,y=>$yc+$y,rotate=>$arc - 90);
		}
		$arc2 -= ($wx[ord($char)] / 2 + $kpx[ord(substr($text2t,$i,1))][ord(substr($text2t,$i+1,1))]) * 1.1;
	}
}

# once we're finished drawing letters, we resize the layer and composite
# it onto the base.
$textimg->Resize(width=>$imgwidth,height=>$imgheight,filter=>'Lanczos');
$base->Composite(image=>$textimg,compose=>'Over',x=>0,y=>0,gravity=>'NorthWest');

undef $textimg;

# that's it, now we can send it to the browser. we have to send
# a couple of HTTP headers to let the browser know an image is
# coming.

# the first is a Content-Disposition header to tell the
# browser whether to just display the image (inline), or to
# trigger a "Save as..." dialog box (attachment).
if ($download) {
	$disposition = "attachment";
} else {
	$disposition = "inline";
}
print "Content-Disposition: $disposition; filename=badge.gif\n";

# the second header is a Content-Type header, which tells the browser
# to expect a GIF image.
print "Content-Type: image/gif;\n\n";

# now we write the image data to standard output, and we're done.
binmode STDOUT;
$base->Write('gif:-');

undef $base;