#!/usr/bin/env ruby
require 'pathname'
if ARGV.empty?
  warn 'as3template Foo.as'
  exit 1
end

name = ARGV.shift
file = Pathname.new(name)

if file.exist?
  warn "#{file} is exist."
  exit 1
end

file.open('w') {|f| f.puts DATA.read.gsub('_NAME_', name.sub('.as', '')) }

__END__
package {
    import flexunit.framework.TestCase;
  import flexunit.framework.TestSuite;
            super(methodName);
        }
        public static function suite():TestSuite {
            var suite:TestSuite = new TestSuite();

            return suite;
        }
        public function testToXXX():void {
            var xx:Number = 0;
            var xxx:Number = 0;
            assertEquals("０は０", 1, xx);
        }
    }
}

