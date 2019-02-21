from requests import get
from bs4 import BeautifulSoup
import json

base_url = 'https://menus.sodexomyway.com/BiteMenu/MenuOnly?'
menu_Id = '15270'
location_Id = '32736003'

date ='01/22/2019'
location_url = 'http://ccsudining.sodexomyway.com/dining-near-me/'
dining_hall = 'hilltop-cafe'

url = base_url + 'menuId=' + menu_Id + '&locationId=' + location_Id + '&whereami=' + location_url + dining_hall + '&startDate=' + date
page = get(url)
soup = BeautifulSoup(page.text, 'html.parser')
menu_text = soup.find('div', id='nutData')
menu_json = json.loads(menu_text.text)
print (menu_json)