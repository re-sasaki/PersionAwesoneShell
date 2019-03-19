# coding: UTF-8
import urllib2
from bs4 import BeautifulSoup

# アクセスするURL
url = "https://aws.koiwaclub.com/sample/aws-sample-exam/"

# URLにアクセスする htmlが帰ってくる → <html><head><title>経済、株価、ビジネス、政治のニュース:日経電子版</title></head><body....
html = urllib2.urlopen(url)

# htmlをBeautifulSoupで扱う
soup = BeautifulSoup(html, "html.parser")

# タイトル要素を取得する → <title>経済、株価、ビジネス、政治のニュース:日経電子版</title>
title_tag = soup.find("div",id="mtq_question_text-1-1")
title_tag2 = soup.find("div",id="mtq_answer_text-1-1-1")
title_tag3 = soup.find("div",id="mtq_answer_text-1-2-1")
title_tag4 = soup.find("div",id="mtq_answer_text-1-3-1")
title_tag5 = soup.find("div",id="mtq_answer_text-1-4-1")
# 要素の文字列を取得する → 経済、株価、ビジネス、政治のニュース:日経電子版
# title = title_tag.string

# タイトル要素を出力
print title_tag.string
print title_tag2.string
print title_tag3.string
print title_tag4.string
print title_tag5.string

# タイトルを文字列を出力
# print title

