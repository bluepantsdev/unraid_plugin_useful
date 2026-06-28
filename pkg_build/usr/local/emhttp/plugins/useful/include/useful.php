<?php
$plugin    = "useful";
$pluginDir = "/usr/local/emhttp/plugins/$plugin";
$configDir = "/boot/config/plugins/$plugin";

if (!is_dir($configDir)) mkdir($configDir, 0755, true);
?>
<!DOCTYPE html>
<html>
<head><title>Useful</title></head>
<body>
  <div class="title">
    <span class="left"><i class="fa fa-wrench title"></i>Useful Scripts</span>
  </div>
  <p>Select a script to view, configure, or run.</p>
  <div id="useful-scripts">
    <p><em>No scripts configured yet.</em></p>
  </div>
</body>
</html>
