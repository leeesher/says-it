<?

/*
badge.php
Copyright (C) 2008, Ryland Sanders

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

$thispage = getenv("SCRIPT_NAME");

$params = array('text1', 'text2', 'shieldfgcolor', 'shieldbgcolor', 'imgbgcolor', 'fgcolor', 'emblemfgcolor', 'tsize', 'tshift', 'outline');

if ($_POST['go']) {
	$text1 = trim(stripslashes($_POST['text1']));
	$text2 = trim(stripslashes($_POST['text2']));
	$outline = $_POST['outline']+0;
	$tsize = $_POST['tsize']+0;
	$tshift = $_POST['tshift']+0;
	$shieldfgcolor = trim(stripslashes($_POST['shieldfgcolor']));
	$shieldbgcolor = trim(stripslashes($_POST['shieldbgcolor']));
	$imgbgcolor = trim(stripslashes($_POST['imgbgcolor']));
	$fgcolor = trim(stripslashes($_POST['fgcolor']));
	$emblemfgcolor = trim(stripslashes($_POST['emblemfgcolor']));
} else {
	$text1 = "EXAMPLE TEXT";
	$text2 = "EXAMPLE TEXT";
	$outline = 0;
	$tsize = 0;
	$tshift = 0;
	$shieldfgcolor = '837000';
	$shieldbgcolor = 'FFFF66';
	$imgbgcolor = 'FFFFFF';
	$fgcolor = '837000';
	$emblemfgcolor = '837000';
}

?><!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML>
<HEAD>
<TITLE>Generator Example</TITLE>

<style type="text/css">
BODY { background-color: white; color: black; font-family: Verdana, sans-serif; }
</style>

</HEAD>
<BODY>

<h2>Example Generator</h2>

<p>Welcome to the Example Generator. Enter some text, choose a an emblem, pick your colors, and click the 'Go' button.</p>
<p>Some options were removed from the original for simplicity and clarity, such a choice of font, emblem, etc. I also left out the color picker, because there's a whole Javascript library that goes along with it.</p>

<script language="Javascript" type="text/javascript">

function usepreset() {
	var presets = new Array(
		new Array('837000','FFFF66','837000','837000','FFFFFF'), // gold
		new Array('333333','CCCCCC','333333','333333','FFFFFF'), // silver
		new Array('000000','FFFFFF','000000','000000','FFFFFF'), // black and white
		new Array('006600','CCFF66','004B00','004B00','FFFFFF'), // Cool Green
		new Array('462E0C','FFFF7F','462E0C','563A0F','FFFFFF'), // Cappuccino
		new Array('FF0000','FFFF00','000000','FF0000','FFFFFF'), // Hot Dog Stand
		new Array('15B8E3','D2EFFC','26767D','26767D','FFFFFF'), // Ocean
		new Array('000000','CC0000','FFFFFF','000000','FFFFFF') // Zombie Hunter
	)
	var frm = document.mainform;
	var presetid = frm.presets.selectedIndex;

	frm.shieldfgcolor.value = presets[presetid][0];
	frm.shieldbgcolor.value = presets[presetid][1];
	frm.fgcolor.value       = presets[presetid][2];
	frm.emblemfgcolor.value = presets[presetid][3];
	frm.imgbgcolor.value    = presets[presetid][4];
}

function checkform(frm) {
	if (frm.text1.value.length < 1 && frm.text2.value.length < 1) {
		alert ("Please enter some text.");
		frm.text1.focus();
		return false;
	}
}

</script>

<table width="780">
	<tr valign="top">
		<td>

<form name="mainform" action="<? echo getenv("SCRIPT_NAME"); ?>" method="post" onSubmit="return checkform(this)">
<table border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td><SMALL>Top:</SMALL></td>
		<td><input type="text" name="text1" size="35" value="<? echo htmlspecialchars($text1); ?>"></td>
	</tr>
	<tr>
		<td><SMALL>Bottom:</SMALL></td>
		<td><input type="text" name="text2" size="35" value="<? echo htmlspecialchars($text2); ?>"></td>
	</tr>
	<tr>
		<td><SMALL>Font:</SMALL></td>
		<td>
		<table border="0" cellspacing="0" cellpadding="0">
			<tr valign="bottom">
				<td><small><small>Font</small></small></td>
				<td><small><small>Size</small></small></td>
				<td><small><small>Baseline</small></small></td>
			</tr>
			<tr>
				<td>Alternate Gothic No. 2&nbsp;</td>
				<td><select name="tsize" style="font-size: .75em;">
<?
for ($i = 6; $i > -1; $i--) {
	echo "				<option value=\"".($i-3)."\"";
	if ($i - 3 == $tsize) { echo " selected"; }
	echo ">";
	if ($i - 3 > 0) { echo '+'; }
	echo ($i - 3) ."</option>\n";
}
?>
				</select></td>
				<td><select name="tshift" style="font-size: .75em;">
<?
for ($i = 10; $i > -1; $i--) {
	echo "				<option value=\"".($i-5)."\"";
	if ($i-5 == $tshift) { echo " selected"; }
	echo ">";
	if ($i - 5 > 0) { echo '+'; }
	echo ($i-5)."</option>\n";
}
?>
				</select></td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td><input type="radio" name="outline" id="outline0" value="0"<? if (!$outline) { echo " checked"; }?>> <SMALL><label for="outline0">filled</label></SMALL>
		<input type="radio" name="outline" id="outline1" value="1"<? if ($outline == 1) { echo " checked"; }?>> <SMALL><label for="outline1">outlined</label></SMALL></td>
	</tr>
</table>

<br />
<table width="75%" cellspacing="0" cellpadding="0">
	<tr valign="top">
		<td><small>You just get the one emblem in the demo.</small></td>
		<td><img alt="emblem preview" src="images/eagle.thumb.gif" width="48" height="48" border="1"></td>
	</tr>
</table>

<p><SMALL><B>Colors:</B></SMALL>
<table>
	<tr>
		<td><SMALL>Shield outline:</SMALL></td>
		<td><input type="text" size="6" name="shieldfgcolor" value="<? echo $shieldfgcolor; ?>"></td>
	</tr>
	<tr>
		<td><SMALL>Shield fill:</SMALL></td>
		<td><input type="text" size="6" name="shieldbgcolor" value="<? echo $shieldbgcolor; ?>"></td>
	</tr>
	<tr>
		<td><SMALL>Text color:</SMALL></td>
		<td><input type="text" size="6" name="fgcolor" value="<? echo $fgcolor; ?>"></td>
	</tr>
	<tr>
		<td><SMALL>Emblem color:</SMALL></td>
		<td><input type="text" size="6" name="emblemfgcolor" value="<? echo $emblemfgcolor; ?>"></td>
	</tr>
	<tr>
		<td><SMALL>Image background:</SMALL></td>
		<td><input type="text" size="6" name="imgbgcolor" value="<? echo $imgbgcolor; ?>"></td>
	</tr>
</table>
<table width="100%">
	<tr>
		<td><SMALL>Presets:</SMALL></td>
		<td><select name="presets" onChange="usepreset()">
<?
$presets = array('Gold','Silver','Black/white','Cool Green','Cappuccino','Hot Dog Stand','Ocean','Zombie Hunter');
for ($i = 0; $i < sizeof($presets); $i++) {
	echo "<option value=\"$i\"";
	if ($_POST['presets'] == $i) { echo " selected"; }
	echo ">" . $presets[$i] . "</option>\n";
}
?>
		</select></td>
	</tr>

</table>

<input type="submit" name="go" value="Go">
</form>

		</td>
		</td>
		<td style="font-size: 75%" width="350" align="center">
<?
if ($_POST['go'] == 'Go') {
	echo "Here's your badge:\n<center><img alt=\"your official badge\" src=\"badge.pl?";
	for ($i = 0; $i < sizeof($params); $i++) {
		if ($i) { echo '&'; }
		echo $params[$i]."=".urlencode(stripslashes($_POST[$params[$i]]));
	}
	echo "\" width=\"$imgwidth\" height=\"$imgheight\" border=\"0\">\n<br><a href=\"badge.pl?";
	for ($i = 0; $i < sizeof($params); $i++) {
		if ($i) { echo '&'; }
		echo $params[$i]."=".urlencode(stripslashes($_POST[$params[$i]]));
	}
	echo "&download=1&filename=/badge.gif\">click here to download this image to your computer</a>\n";
} else {
?>
			<p>&nbsp;</p>
			<img src="images/demo-badge.gif" width="370" height="380" alt="example generator">
<?
}
?>
		</td>
	</tr>
</table>

</BODY>
</HTML>