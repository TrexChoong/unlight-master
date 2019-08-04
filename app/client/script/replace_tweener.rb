# -*- coding: utf-8 -*-
# Specファイルのテンプレートを作るスクリプト
# rakeから使う。
#!/usr/bin/env ruby
# 引数で与えられたディレクトリを再帰的に処理して置き換えを行う

require 'tempfile'

dir = ARGV.shift

class DirSub

  def initialize(dir)
    @list = []
    dirlist(dir).each{|file|
      p file
      substitute(file)
    }
  end

  def dirlist(dir)
    d = Dir::open(dir)
    d.each{|f|
      next if f == '.' || f == '..'
      fullpath = "#{dir}/#{f}"
      if File::directory?(fullpath)
        dirlist(fullpath)
      else
        @list << fullpath if File::extname(fullpath) == '.as'
      end
    }
    d.close
    return @list
  end

  def substitute(file)
    temp = Tempfile::new('dirsub', '/tmp')
    File::open(file, 'r') do |f| 
      while line = f.gets
        #       f.read.each{|line|
        #        line.gsub!(before_word, after_word)
        #        var logoBG1Tween:Thread = new TweenerThread(_logo.BG1, {  alpha: 0.88, transition:"easeOutSine", time: 2.0, delay: 1.0, show: true } );
        #                                    BeTweenAS3Thread(_loginPanel, { alpha: 1.0}, null, 1.0, BeTweenAS3Thread.EASE_OUT_SINE, 0.0, true);

        if line.match("new TweenerThread")
          # 以前のTweenを残す
          org = line
          m = org.match(/TweenerThread.?\((.*)\{([^}]*)\}/)
          args = Hash[*(m[2].gsub!(" ","").split(",").map!{ |a| a.split(":")}).flatten] if m
          # アンダースコア入りの特殊プロパティを操作しているTweenerを排除する
          p args
          sp_prop = false
          args.each do |k, v|
            sp_prop = true if k.match(/^_/)
          end

          unless sp_prop
            line = "//"+line

            if args["time"]
              time =  args["time"]
              args.delete("time")
            end
            if args["delay"]
              delay =  args["delay"]
              args.delete("delay")
            end
            if args["transition"]
              transition =  args["transition"]
              args.delete("transition")
            end
            if args["wait"]
              wait =  args["wait"]
              args.delete("wait")
            end
            if args["show"]
              visible =  true
              args.delete("show")
            end
            if args["hide"]
              visible =  false
              args.delete("hide")
            end
            if delay
              delay = " ,"+delay.to_s
            else
              delay = ""
            end

            if visible == nil
              visible = ""
            else
              delay = ", 0.0" if delay ==""
              visible = " ,"+visible.to_s
            end


            unless time
              time = "1.0"
            end

            transition = "BeTweenAS3Thread."+underscore(transition).gsub('"', "")
            args_str =""
            args.each{ |k,v| args_str += "#{k.gsub('"',"")}:#{v.to_s.gsub('"',"")} ,"}
            args_str.chomp!(" ,")
            new_line = org.gsub(/TweenerThread.?\((.*)\{([^}]*)\}(.*;)/, "BeTweenAS3Thread(\\1{#{args_str}}, null, #{time}, #{transition}#{delay}#{visible}\\3")

            line.gsub!("////", "//")
            p line
            p new_line
            time =  nil
            delay =  nil
            transition =  nil
            wait =  nil
            visible =  nil
          end
        else
          new_line = nil

        end
        temp.puts(line)
        if new_line
          temp.puts(new_line)
        end

      end
    end

    temp.close
    temp.open

    File::open(file, 'w') do |f|
      p file
      temp.each_line do |line|
        puts line
        f.puts(line)
      end
    end
    temp.close(true)
  end

  def underscore(camel_cased_word)
    camel_cased_word.
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      upcase
  end

end

DirSub::new(dir)


