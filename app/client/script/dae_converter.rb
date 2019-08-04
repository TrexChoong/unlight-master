# -*- coding: utf-8 -*-
# Specファイルのテンプレートを作るスクリプト
# rakeから使う。
$:.unshift(File.join(File.expand_path("."), "src"))
require 'find'
require 'pathname'
OUTPUT = false

h = Hash.new()
Find.find('./public')do |f|
  next if File.directory?(f)
  # Public以下のファイルをに対して
  if File::extname(f) == ".dae"
    p './script/replace.sh "_1_-_Default" "_Default"'+f if OUTPUT
    system('./script/replace.sh "_1_-_Default" "_Default" '+f)
  end
end
