# -*- coding: utf-8 -*-

# -*- coding: utf-8 -*-
# ソケットに対応したテスト用のエコーサーバ

require 'rubygems'
require 'eventmachine'
require 'constants'
require 'protocol/ulserver'

module Unlight
  module Protocol
    class EchoServer < EventMachine::Connection
      def self.setup
      end

      # 受信時
      def receive_data data
        SERVER_LOG.info("echoserer: Echo:#{data.unpack('c*')}")
        send_data(data)
      end
      # 受信時
      def post_init

      end

    end
  end

  include Protocol
  EM.set_descriptor_table_size(10000) # ソケットMaxを設定
  EM.epoll                            # Epollを使用するように設定。
  EM.run do
    EchoServer.setup
#    EM.start_server "0.0.0.0", 12000, EchoServer
    EM.start_server "0.0.0.0", 12000, EchoServer
    EM.set_quantum(10)                # タイマの制度を上げる

    # 1/30でメインループを更新
    EM::PeriodicTimer.new(0.03, proc { 
#                             start_time =Time.now if x==1
#                             x += 1
#                             EventMachine.stop if x == 10000
#                             p x
#                             p Time.now-start_time if x==10000
#                             p Thread.current
                          })


  end


end
