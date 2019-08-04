# -*- coding: utf-8 -*-
require 'find'
require 'pathname'

filename = "./lib/Version.as"
MAIN_VERSION = 1.0
OUTPUT = false

no = MAIN_VERSION
info = `git log -n 15`
revision = /trunk@(\d*)/.match(info).to_a[1]

p info if OUTPUT
p revision if OUTPUT

file = Pathname.new(filename)
file.open('w') {|f| f.puts DATA.read.gsub('__NO__', no.to_s).gsub('__REVISION__', revision) }

__END__
package
{
    public class Version
    {
        public static const NO:String = "__NO__";
        public static const REVISION:String = "__REVISION__";


    }
}

