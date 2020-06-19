cat DataSetPage.html | grep -E 'href=".*download=1|md5:' | grep -v 'pull-right' > newfiltered.out
