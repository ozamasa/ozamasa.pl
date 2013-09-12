#!C:/perl/bin/perl

print "Content-type: text/html\n\n";
print "<html><head>";
print "<title>ENV</title></head>\n";
print "<body>";
	while (($key, $val) = each %ENV) {
        print "$key = $val<br>";
	}
print "<br>\n";
print "</body></html>";