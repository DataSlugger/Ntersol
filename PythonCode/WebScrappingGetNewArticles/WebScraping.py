from bs4.element import ContentMetaAttributeValue
from requests import get
from bs4 import BeautifulSoup
import urllib
import sys
import json

# url example - https://edition.cnn.com/travel/article/india-beautiful-places/index.html
url = input("Enter Web Url: ")

raw = urllib.request.urlopen(url).read()
bs = BeautifulSoup(raw, "html.parser")

fSave = open("webscraping.txt", "w+")
fSave.write(str(bs))
fSave.close()

# using Classes to retrieve data
pageTitle = bs.find("meta", attrs={'property': "og:title"})
print("Page Title")
print("***********************************************")
print(pageTitle["content"])

#articleAuthor = bs.find('title', class_="title")
#print("Article Author")
# print("***********************************************")
# print(articleAuthor.text)

#articleAuthor = bs.find('div', class_="Article__subtitle")
#print("Article Author")
# print("***********************************************")
# print(articleAuthor.text)

# using meta attributes to retrieve data
pageDescription = bs.find("meta", property="og:description")

print("Article Description")
print("***********************************************")
# print(pageDescription.text)
print(pageDescription["content"])

pageType = bs.find("meta", property="og:type")
print("***********************************************")
print("Content Type")
print("***********************************************")
# print(pageDescription.text)
print(pageType["content"])


Author = bs.find("meta", property="og:author")
print("***********************************************")
print("Article Author")
print("***********************************************")
# print(pageDescription.text)
print(Author["content"])

keyWords = bs.find("meta", attrs={'name': 'keywords'})
print("***********************************************")
print("Keywords")
print("***********************************************")
# print(pageDescription.text)
print(keyWords["content"])

pubDate = bs.find("meta", attrs={'name': 'pubdate'})
print("***********************************************")
print("Publication Date")
print("***********************************************")
# print(pageDescription.text)
print(pubDate["content"])

lastUDate = bs.find("meta", attrs={'name': 'lastmod'})
print("***********************************************")
print("Last Modification Date")
print("***********************************************")
# print(pageDescription.text)
print(lastUDate["content"])


# Saving as json format to use saving as file or sending to APIs

jsonFile = json.loads(
    json.dumps(
        {
            "article title": pageTitle.text,
            "page type": pageType["content"],
            "article author": Author["content"],
            "article description": pageDescription["content"],
            "keywords": keyWords["content"],
            "original publication date": pubDate["content"],
            "Last Update": lastUDate["content"]
        }
    )
)

with open('data.json', 'w+', encoding='utf-8') as f:
    json.dump(jsonFile, f, ensure_ascii=False, indent=4)
