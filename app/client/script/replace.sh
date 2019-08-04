#!/bin/sh
# $* の $1 を $2 に置き換えます。
# 使用方法：replace "old-pattern" "new-pattern" file [file...]
OLD=$1          # スクリプトの最初のパラメータ
NEW=$2          # 2 番目のパラメータ
shift ; shift   # 最初の二つのパラメータを捨てる。次はファイル名です。
for file in $*  # パラメータとして与えられた全てのファイルでループします。
do
#  OLD を NEW に置換して、テンポラリファイルに保存します。
  sed "s/$OLD/$NEW/g" ${file} > ${file}.new
# テンポラリファイルをオリジナルファイル名にリネームします。
  /bin/mv ${file}.new ${file}
done
