#!/usr/bin/env python3

import os

# raise Exception(os.getcwd())

tracking = os.popen("programs/trks").read()
tracking = tracking.strip()
tracking = tracking.split("\n")
tracking = ["<li>" + x + "</li>" for x in tracking]
tracking = "<ul>" + "\n".join(tracking) + "</ul>"

rsp = f"""
<!DOCTYPE html>
<html>

<head>
  <meta charset="utf-8">
  <title>time-tracker</title>
  <link href="http://fonts.googleapis.com/css?family=Open+Sans" rel="stylesheet" type="text/css">
  <link href="/styles/style.css" rel="stylesheet" type="text/css">
</head>

<body>
    <form action="" method="post">
        <button name="foo" value="upvote">Upvote</button>
    </form>
    {tracking}
</body>

</html>
"""

print(rsp)