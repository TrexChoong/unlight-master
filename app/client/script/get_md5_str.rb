# -*- coding: utf-8 -*-
$:.unshift(File.join(File.expand_path("../server"), "src"))
require 'digest/md5'
require File::expand_path(__FILE__).gsub(/client\/script\/get_md5_str.rb/, "")+"server/script/constdata_keys.rb"

dirname = File.dirname(ARGV[0])
filename = File.basename(ARGV[0])
str = File.basename(ARGV[0], ".*")
str = str + IMAGEFILE_HASHKEY

ret = Digest::MD5.hexdigest(str)
puts dirname+"/"+filename+"."+ret
