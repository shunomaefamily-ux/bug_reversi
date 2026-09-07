# frozen_string_literal: true

require_relative './lib/reversi_methods'

class Reversi
  include ReversiMethods

  QUIT_COMMANDS = %w[quit exit q].freeze #定数として、quit exit qの文字列（配列）を用意

  def initialize #Reversiクラスのオブジェクトを生成したら自動で実行されるメソッド
    @board = build_initial_board #reversi_methodsモジュールのメソッド
    @current_stone = BLACK_STONE #同上。 =文字列"B"
  end

  def run
    loop do #loopメソッド（チェリー本p370）。条件がないと無限ループ
      output(@board) #ReversiMethodsモジュールのメソッド

      if finished?(@board)#試合終了の判定
        puts '試合終了'
        puts "白○:#{count_stone(@board, WHITE_STONE)}"
        puts "黒●:#{count_stone(@board, BLACK_STONE)}"
        break
      end

      unless placeable?(@board, @current_stone)#手番で置く場所が存在するか
        puts '詰みのためターンを切り替えます'
        toggle_stone
        next
      end

      print "command? (#{@current_stone == WHITE_STONE ? '白○' : '黒●'}) > "
      command = gets.chomp  #改行を除いたテキストを代入
      break if QUIT_COMMANDS.include?(command)

      begin
        if put_stone(@board, command, @current_stone)
          puts '配置成功、次のターン'
          toggle_stone
        else
          puts '配置失敗、ターン据え置き'
        end
      rescue StandardError => e
        puts "ERROR: #{e.message}"
      end
    end

    puts 'finished!'
  end

  private #Reversiクラスオブジェクトから呼び出すことができない

  def toggle_stone
    @current_stone = @current_stone == WHITE_STONE ? BLACK_STONE : WHITE_STONE
  end
end

Reversi.new.run if __FILE__ == $PROGRAM_NAME #実行しているのファイルがこのファイルであるならば＝reversi.rbを実行しているならば、Reversi.new.runされる。run上記のメソッド。