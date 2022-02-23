<?

/*
church.php
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

if ($_POST) {
	$text1 = $_POST['text1'];
	$text2 = $_POST['text2'];
	$text3 = $_POST['text3'];
	$text4 = $_POST['text4'];
	$htext1 = $_POST['htext1'];
	$htext2 = $_POST['htext2'];
	$hcolor = $_POST['hcolor'];
	$fcolor = $_POST['fcolor'];
	$bcolor = $_POST['bcolor'];
	$ecolor = $_POST['ecolor'];
} else {
	$text1 = "";
	$text2 = "CHURCH SIGN";
	$text3 = "GENERATOR";
	$text4 = "";
	$htext1 = "Twin Lakes";
	$htext2 = "Lutheran Church";
	$hcolor = "10702D";
	$fcolor = "DBEAE0";
	$bcolor = "DBEAE0";
	$ecolor = "5E194A";
}

$params = array('text1','text2','text3','text4','htext1','htext2','hcolor','fcolor','bcolor','ecolor');

?><!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML>
<HEAD>
<TITLE></TITLE>

<style type="text/css">
BODY { background-color: white; color: black; }
</style>

</HEAD>
<BODY>

<h2>Example church sign</h2>

<p>Enter some text and click the 'Go' button.</p>

<script language="Javascript">
function checkform(frm) {
	if (frm.text1.value.length < 1 && frm.text2.value.length < 1 && frm.text3.value.length < 1 && frm.text4.value.length < 1) {
		alert ("Please enter some text.");
		frm.text1.focus();
		return false;
	}
}
</script>

<table>
	<tr valign="top">
		<td>
<form name="mainform" action="<? echo $thispage; ?>" method="post" onSubmit="return checkform(this)">

<p><b>Church name:</b></p>

<SMALL>line 1:</SMALL> <input type="text" size="18" name="htext1" value="<? echo htmlspecialchars(stripslashes($htext1)); ?>">
<br><SMALL>line 2:</SMALL> <input type="text" size="18" name="htext2" value="<? echo htmlspecialchars(stripslashes($htext2)); ?>">
<br>
<br><SMALL>text color:</SMALL> <input type="text" size="6" name="fcolor" value="<? echo $fcolor; ?>">
<br><SMALL>background color:</SMALL> <input type="text" size="6" name="hcolor" value="<? echo $hcolor; ?>">

<table>
	<tr valign="top">
		<td><SMALL>emblem:
		<br><small>Just the one emblem for this example.</small></SMALL></td>
		<td><img alt="emblem preview" src="images/church.thumb.gif" width="48" height="48" border="1"></td>
	</tr>
</table>

<SMALL>emblem color:</SMALL> <input type="text" size="6" name="ecolor" value="<? echo $ecolor; ?>">
<br><SMALL>background color:</SMALL> <input type="text" size="6" name="bcolor" value="<? echo $bcolor; ?>">

<p><b>Sign text:</b></p>

<br><SMALL>line 1:</SMALL> <input type="text" name="text1" value="<? echo htmlspecialchars(stripslashes($text1)); ?>">
<br><SMALL>line 2:</SMALL> <input type="text" name="text2" value="<? echo htmlspecialchars(stripslashes($text2)); ?>">
<br><SMALL>line 3:</SMALL> <input type="text" name="text3" value="<? echo htmlspecialchars(stripslashes($text3)); ?>">
<br><SMALL>line 4:</SMALL> <input type="text" name="text4" value="<? echo htmlspecialchars(stripslashes($text4)); ?>">

<p><input type="submit" name="go" value="Go"></p>
</form>

		</td>
		<td align="center">

<?
if ($_POST['go'] == 'Go') {
	echo "<img src=\"church.pl?";
	for ($i = 0; $i < sizeof($params); $i++) {
		if ($i) { echo '&'; }
		echo $params[$i]."=".urlencode(stripslashes($_POST[$params[$i]]));
	}
	echo "\" width=\"400\" height=\"300\" border=\"0\">\n<br><small>Source photo courtesy of <a target=\"_blank\" href=\"http://www.stewartsigns.com/church-signs.php?code=15CSG\">Stewart Church Signs</a></small>\n";
	echo "<p><a href=\"church.pl?";
	for ($i = 0; $i < sizeof($params); $i++) {
		if ($i) { echo '&'; }
		echo $params[$i]."=".urlencode(stripslashes($_POST[$params[$i]]));
	}
	echo "&download=1&filename=/churchsign.jpg\">click here to download this image to your computer</a>";
} else {
?>
	<img src="images/demo-church.jpg" width="400" height="300">
	<br><small>Source photo courtesy of <a target="_blank" href="http://www.stewartsigns.com/church-signs.php?code=15CSG">Stewart Church Signs</a></small>
<?
}
?>
		</td>
	</tr>
</table>

</BODY>
</HTML>