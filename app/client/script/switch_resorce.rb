# -*- coding: utf-8 -*-
require 'find'
require 'pathname'
require 'optparse'
require 'fileutils'
OUTPUT = false
opt = OptionParser.new

mode_reg = /_jp.swf/
FileUtils.copy_entry("../server/src/constants/locale_constants.rb_sb","../server/src/constants/locale_constants.rb")
FileUtils.copy_entry("../server/script/constdata_keys_jp.rb","../server/script/constdata_keys.rb")
FileUtils.copy_entry("./data/css/UL.css.orig","./data/css/UL.css")

opt.on('-e',"--english","英語用") do|v|
  if v
    mode_reg = /_en.swf/
    FileUtils.copy_entry("../server/src/constants/locale_constants.rb_en","../server/src/constants/locale_constants.rb")
    FileUtils.copy_entry("../server/script/constdata_keys_e.rb","../server/script/constdata_keys.rb")
    FileUtils.copy_entry("./data/css/UL.css.orig","./data/css/UL.css")
  end
end

opt.on('-c',"--t_chinese","繁体中国語") do |v|
  if v
    mode_reg = /_ch.swf/
    FileUtils.copy_entry("../server/src/constants/locale_constants.rb_tcn","../server/src/constants/locale_constants.rb")
    FileUtils.copy_entry("../server/script/constdata_keys_tcn.rb","../server/script/constdata_keys.rb")
    FileUtils.copy_entry("./data/css/UL.css.cn","./data/css/UL.css")
  end
end

opt.on('-sc',"--s_chinese","繁体中国語") do |v|
  if v
    mode_reg = /_sc.swf/
    FileUtils.copy_entry("../server/src/constants/locale_constants.rb_scn","../server/src/constants/locale_constants.rb")
    FileUtils.copy_entry("../server/script/constdata_keys_scn.rb","../server/script/constdata_keys.rb")
    FileUtils.copy_entry("./data/css/UL.css.cn","./data/css/UL.css")
  end
end

opt.on('-kr',"--korean","韓国語") do|v|
  if v
    mode_reg = /_en.swf/
    FileUtils.copy_entry("../server/src/constants/locale_constants.rb_kr","../server/src/constants/locale_constants.rb")
    FileUtils.copy_entry("../server/script/constdata_keys_kr.rb","../server/script/constdata_keys.rb")
    FileUtils.copy_entry("./data/css/UL.css.orig","./data/css/UL.css")
  end
end

opt.on('-fr',"--french","フランス語語") do|v|
  if v
    mode_reg = /_fr.swf/
    FileUtils.copy_entry("../server/src/constants/locale_constants.rb_fr","../server/src/constants/locale_constants.rb")
    FileUtils.copy_entry("../server/script/constdata_keys_fr.rb","../server/script/constdata_keys.rb")
    FileUtils.copy_entry("./data/css/UL.css.fr","./data/css/UL.css")
  end
end

opt.parse!(ARGV)


Find.find('./data/image/')do |f|
  # モデル以下のファイルを全部require
  next if File.directory?(f)
  Find.prune if f=~/svn/

  if f =~ mode_reg
    puts f if OUTPUT
    FileUtils.copy_entry(f,f.gsub(mode_reg,".swf"))
  end
end

Find.find('./public/image/')do |f|
  # モデル以下のファイルを全部require
  next if File.directory?(f)
  Find.prune if f=~/svn/
  if f =~ mode_reg
    puts f if OUTPUT
    FileUtils.copy_entry(f,f.gsub(mode_reg,".swf"))
  end
end
