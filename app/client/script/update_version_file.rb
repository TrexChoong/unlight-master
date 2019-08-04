# -*- coding: utf-8 -*-
require 'find'
require 'pathname'

filename = "./lib/Version.as"
MAIN_VERSION = "Community 1."
OUTPUT = false

no = MAIN_VERSION
revision = "Test"

#SVN
#info = `svn info`
#revision = /リビジョン:\s(\d*)$/.match(info).to_a[1]

#git
# cmd = "git log -1"
# change_log = `#{cmd}`
# revision = /@(\d*) / =~ change_log

p revision if OUTPUT

file = Pathname.new(filename)
file.open('w') {|f| f.puts DATA.read.gsub('__NO__', no).gsub('__REVISION__', revision) }

__END__
package
{
    public class Version
    {
        public static const NO:String = "__NO__";
        public static const REVISION:String = "__REVISION__";

    }
}
