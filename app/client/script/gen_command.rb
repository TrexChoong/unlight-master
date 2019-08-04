# -*- coding: utf-8 -*-
require 'pathname'
require 'erb'
# TODO: readIntをreadUnsignedIntにする
# 通信コマンドをサーバ側のソースから自動的に生成するスクリプト
module Unlight
class Command

  def self.camelize(a)
    ret = []
    a.each do |c|
      name = c[0].id2name
      while name=~/_/
        i = name=~/_/
        name[i+1]=name[i+1].upcase
#        name.gsub!("_","")
        name.slice!(i)
      end
      ret << name
    end
    ret
  end

  def self.gen_command()
    cpath =File.expand_path(File.dirname(__FILE__))
    $: << cpath.gsub("client/script","")+'server/src/'
    file=ARGV[0]
    out =ARGV[1]
    puts file
    require file.gsub(".rb","")
 #     require 'protocol/command/authcommand'
    rec_cmd_list =""
    r = camelize(SEND_COMMANDS)
    r.each do |a|
      rec_cmd_list << "            receiveCommands.push(#{a});\n"
      end
    r = camelize(RECEIVE_COMMANDS)
    s = camelize(SEND_COMMANDS)
    file = Pathname.new(cpath.gsub("script","src/net/command")+"/#{out.capitalize}Command.as")

    # erb のテンプレートを作成
    erb = ERB.new(IO.read(cpath+"/command_template.erb"), nil, "" )
#    file.open('w') {|f| f.puts data }

    file.open("w") { |f| f.write( erb.result(binding) )}
  end

# 送信コマンドの内容を生成する（書き込み部分）
    def self.gen_send(a)
      ret = ''
      if a
        a.each do |c|
          ret << type_send_res(c[2],c[1],c[0])
        end
      end
      ret
    end

    # 型によって返す変換する文字列を返す
    def self.type_send_res(l,t,v)
      ret = ''
      case t
      when :String
        if l == 0
          ret << "            cmd.writeUTF(#{v});\n"
        else
          ret << "            cmd.writeUTFBytes(#{v});\n"
        end
      when :int
#        ret << "            cmd.writeShort(#{v}.length);\n" if l==0
        ret << "            cmd.writeInt(#{v});\n"
      when :char
#        ret << "            cmd.writeShort(#{v}.length);\n" if l==0
        ret << "            cmd.writeByte(#{v});\n"
      when :Boolean
#        ret << "            cmd.writeShort(#{v}.length);\n" if l==0
        ret << "            cmd.writeBoolean(#{v});\n"
      else
        raise "No define type error.(存在しない型指定です) "+t.to_s
      end
    end




# 受信コマンドの内容を生成する（読み込み部分）
    def self.gen_rec(a,comp)
      ret = ''
      if a
        ret << "            ba.uncompress();\n" if comp
        a.each do |c|
        if c[2] == 0

          ret << "            var #{c[0]}_length:int;\n"
          ret << "            #{c[0]}_length = ba.readUnsignedInt();\n"
          ret << type_rec_res(c[1],c[0],"#{c[0]}_length")
        else
          ret << type_rec_res(c[1],c[0],c[2])
        end
        end
      end
      ret
    end

    # 型によって返す変換する文字列を返す
    def self.type_rec_res(t,v,s)
      ret =""
      case t
      when :String
        ret << "            var #{v}:String;\n"
        ret << "            #{v} = ba.readUTFBytes(#{s});\n"
      when :int
        ret << "            var #{v}:int;\n"
        ret << "            #{v} = ba.readInt();\n"
      when :char
        ret << "            var #{v}:int;\n"
        ret << "            #{v} = ba.readByte();\n"
      when :Boolean
        ret << "            var #{v}:Boolean;\n"
        ret << "            #{v} = ba.readBoolean();\n"
      else
        raise "No define type error.(存在しない型指定で)す "
      end
    end
    def self.gen_arg(t)
      case t
      when :String
        "String"
      when :int
        "int"
      when :char
        "int"
      when :Boolean
        "Boolean"
      else
        raise "No define type error.(存在しない型指定です) "+t.to_s
      end
    end

  end
end

#Command::gen_command
Unlight::Command::gen_command
