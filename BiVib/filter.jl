using HTTP
using MD5

baseUrl = "https://zenodo.org"
pathRE = r"^.*(/record.*load=1).*$"m
md5RE = r"^.*md5:(.*) <i.*$"m
fnRE = r"^.*/files/(.*)\?download=1.*$"m
#f = open("newfiltered.out")
s = read("newfiltered.out",String)
println(s)
pathmatches = eachmatch(pathRE,s)
md5matches = eachmatch(md5RE,s)
fnmatches = eachmatch(fnRE,s)
for tup in zip(collect(pathmatches),collect(md5matches),collect(fnmatches))
	path = tup[1].captures[1]
	mymd5 = tup[2].captures[1]
	fn = tup[3].captures[1]
	fullurl = string(baseUrl,path)
	println(path)
	println(fullurl)
	println(fn)
	println(mymd5)
	try
		if !isfile(fn)  # check for file already downloaded
			a = HTTP.open(:GET, fullurl) do data
			   write(fn,data)
			end
		else
			println("$fn already existed, skipped DL")
		end
		open(fn) do data
			if bytes2hex(md5(data)) == mymd5
				println("MD5 match!")	
			else
				println("MD5 mismatched!!! for $fn")
			end
		end
	catch e
		println("Error for $fn")
		println(e)
	end
end
