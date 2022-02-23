#!/usr/bin/perl

# church.pl
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
	$text3 = param('text3');
	$text4 = param('text4');

	$htext1 = param('htext1');
	$htext2 = param('htext2');

	$emblem = param('emblem');

	$hcolor = param('hcolor');
	$fcolor = param('fcolor');
	$bcolor = param('bcolor');
	$ecolor = param('ecolor');

	$download = param('download');
}

utf8::decode($text1);
utf8::decode($text2);
utf8::decode($text3);
utf8::decode($text4);

utf8::decode($htext1);
utf8::decode($htext2);

# filter out invalid hex colors
$hcolor =~ s/[^a-f0-9]//gi;
$fcolor =~ s/[^a-f0-9]//gi;
$bcolor =~ s/[^a-f0-9]//gi;
$ecolor =~ s/[^a-f0-9]//gi;

# if any colors are missing or invalid, replace them with a default.
if (!$hcolor || length($hcolor) != 6) { $hcolor = '781231'; }
if (!$fcolor || length($fcolor) != 6) { $fcolor = 'E4D0D6'; }
if (!$bcolor || length($bcolor) != 6) { $bcolor = 'A0C0BD'; }
if (!$ecolor || length($ecolor) != 6) { $ecolor = '4D862D'; }

if (!$text1 && !$text2 && !$text3 && !$text4) {
	$text1 = "";
	$text2 = "BLANK SIGNS";
	$text3 = "ARE NO FUN";
	$text4 = "";
}

if (!$htext1 && !$htext2 && !$htext3 && !$htext4) {
	$htext1 = "Church Name";
	$htext2 = "GOES HERE";
}

# load the sign photo as our base image. we'll be compositing layers
# on top of this base image to get our final image.
$base = Image::Magick->new;
$base->Set(size=>"400x300");
$base->Read("images/church-base.jpg");

# create an image for use as a 'paint' color and fill it with the
# sign header background color
$tint = Image::Magick->new;
$tint->Set(size=>"400x300",matte=>'True');
$tint->Read("xc:#$hcolor");

# load the sign header background mask. we'll use this sort of like
# a stencil to control which pixels in the tint image get composited
# onto the base image.
$mask = Image::Magick->new;
$mask->Set(size=>"400x300");
$mask->Read("images/church-header-bg-mask.gif");

# composite the tint image onto the base, using the mask image to mask it.
$base->Composite(image=>$tint,compose=>"Over",mask=>$mask,x=>0,y=>0,gravity=>"NorthWest");

# remove the mask from the base image.
$base->Set(mask=>"");

undef $mask;
undef $tint;

# create an image to hold the church name and the sign text. this
# image is 3x larger than it needs to be, because ImageMagick text
# rendering sometimes causes odd spacing errors. making the image larger
# helps hide those errors.
$content = Image::Magick->new;
$content->Set(size=>"900x750");
$content->Read("xc:none");

$hfont = "fonts/Bradley_Gratis.ttf";

# first we find out how large the sign header text is going to be
($x_ppem, $y_ppem, $ascender, $descender, $width1, $height1, $max_advance) = $base->QueryFontMetrics(text=>$htext1,font=>$hfont,pointsize=>96,fill=>'white',strokewidth=>4,stroke=>'white');
($x_ppem, $y_ppem, $ascender, $descender, $width2, $height2, $max_advance) = $base->QueryFontMetrics(text=>$htext2,font=>$hfont,pointsize=>48,fill=>'white',strokewidth=>4,stroke=>'white');

if ($width1 > $width2) { $w = $width1; } else { $w = $width2; }
$w += 40;
$h = ($height1 + $height2) * 2;

# now we create another image large enough to contain the text using
# the values we got above
$letters = Image::Magick->new;
$letters->Set(size=>$w."x".$h);
$letters->Read("xc:none");

# write the text onto that image
if ($htext1) {
	$letters->Annotate(text=>$htext1,font=>$hfont,pointsize=>96,fill=>"#$fcolor",x=>int($w/2),y=>int($h/2),align=>"Center");
}

if ($htext2) {
	$letters->Annotate(text=>$htext2,font=>$hfont,pointsize=>48,fill=>"#$fcolor",x=>int($w/2),y=>int($h/2)+54,align=>"Center");
}

# trim excess pixels and then resize it to fit into the content image
$letters->Trim();
($w,$h) = $letters->Get('columns','rows');
if ($w > 355 || $h > 132) {
	if ($w > 355) { $w = 355; }
	if ($h > 132) { $h = 132; }
	$letters->Resize(width=>$w, height=>$h, filter=>"Lanczos");
}

# composite the church name onto the content image
$content->Composite(image=>$letters,compose=>"Over",x=>384-int($w/2),y=>200-int($h/2),gravity=>"NorthWest");

undef $letters;

# draw a circular background for the emblem image
$content->Draw(primitive=>"circle",fill=>"#$bcolor",points=>"622,200 622,145");

# create an image for the emblem
$emblemimg = Image::Magick->new;
$emblemimg->Set("100x100");
$emblemimg->Read("xc:none");

# load the emblem GIF and use it as a mask for the tint image
$mask = Image::Magick->new;
$mask->Set(size=>"100x100");
$mask->Read("images/church.gif");

$tint = Image::Magick->new;
$tint->Set(size=>"100x100",matte=>'True');
$tint->Read("xc:#$ecolor");

# composite the tint image onto the emblem image
$emblemimg->Composite(image=>$tint,compose=>"Over",mask=>$mask,x=>0,y=>0,gravity=>"NorthWest");

# composite the emblem image onto the content image
$content->Composite(image=>$emblemimg,compose=>"Over",x=>572,y=>150,gravity=>"NorthWest");

undef $mask;
undef $emblemimg;
undef $tint;

# define the center point and the top edge of the sign text area
$x_center = 445;
$y_offset = 362;

$line_height = 58;

# load the lines of text into an array
@text = ('',uc($text1),uc($text2),uc($text3),uc($text4));

$fontname = "fonts/Signage_Geometric.ttf";
# font width and kerning values are contained in this file in wx and kpx arrays
require "fonts/Signage_Geometric.pl";
$max_line_width = 8650;
$fontcolor = "222222";

# loop through lines array and process each line
for ($l = 1; $l < 5; $l++) {
	$x_offset = 0;
	$truncate_to = 0;

	# loop through each letter in each line and get its width
	# and kerning value (if any). if a line is too long to fit
	# on the sign, it gets truncated.
	for ($i = 0; $i < length($text[$l]); $i++) {
		$char = substr($text[$l], $i, 1);
		if ($x_offset + ($wx[ord($char)]) <= $max_line_width) {
			$x_offset += $wx[ord($char)];
			$truncate_to++;
		}
	}
	$text[$l] = substr($text[$l],0,$truncate_to);

	# draw the line onto the content image
	$content->Annotate(text=>$text[$l],font=>$fontname,antialias=>'True',pointsize=>52,fill=>"#$fontcolor",align=>'Center',x=>$x_center,y=>$y_offset,gravity=>'NorthWest');

	# adjust the top edge down for the next line
	$y_offset += $line_height;
}

# resize the content image to smooth it down and hide errors
$content->Resize(width=>400,height=>300,filter=>"Lanczos");

# apply a perspective distortion to the content image
$content->Distort('virtual-pixel'=>"transparent", method=>"Perspective", points=>[88,50,85,52, 88,215,88,216, 305,50,304,49, 305,215,307,214]);

# composite the content image onto the base image
$base->Composite(image=>$content,composite=>"Over",x=>0,y=>0,gravity=>"NorthWest");

undef $content;

# load the overlay image. this overlay image contains a
# reflection of a tree-lined street. it's semi-transparent
# so that the letters and the sign show through.
$overlay = Image::Magick->new;
$overlay->Set(size=>"400x300");
$overlay->Read("images/church-overlay.png");

# composite the overlay onto the base image.
$base->Composite(image=>$overlay,compose=>'Over',x=>0,y=>0,gravity=>'NorthWest');

undef $overlay;

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
print "Content-Disposition: $disposition; filename=churchsign.jpg\n";

# the second header is a Content-Type header, which tells the browser
# to expect a JPEG image.
print "Content-Type: image/jpeg;\n\n";

# now we write the image data to standard output, and we're done.
binmode STDOUT;
$base->Set(compression=>'JPEG',quality=>'85');
$base->Write('jpg:-');

undef $base;