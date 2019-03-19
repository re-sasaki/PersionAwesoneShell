# -*- coding: utf-8 -*-
import sys
import codecs

args = sys.argv

hiragana_list = list(args[1].decode('utf-8'))

emoji = ''
for h in hiragana_list:
  emoji += ':' + h + ':'
print(emoji)
