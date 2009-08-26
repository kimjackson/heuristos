document.getElementById("search").innerHTML = "<form  method=\"post\" onsubmit=\"search(document.getElementById('query-input').value); return false;\"><input type=\"text\" id=\"query-input\"></input><input type=\"button\" value=\"search\" onclick=\"search(document.getElementById('query-input').value);\"/></form>";

