# -*- coding: utf-8 -*-
$:.unshift(File.join(File.expand_path("../server"), "src"))

#puts ARGV[0]
dirname = File.dirname(ARGV[0])
filename = File.basename(ARGV[0], ".*")
puts dirname+"/"+filename
