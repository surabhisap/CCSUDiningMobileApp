#!/usr/bin/env python
# -*- coding: utf-8 -*-
from requests import get
from bs4 import BeautifulSoup
import json
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import datetime


def getMenuData (url):
    page = get(url)
    soup = BeautifulSoup(page.text, 'html.parser')
    menu_text = soup.find('div', id='nutData')
    menu_json = json.loads(menu_text.text)
    return menu_json

def prepMenuData (menu, dining_hall):
    for days in menu:
        for items in days['menuItems']:
            items['dining_hall'] = dining_hall 
            allergens = items.pop('allergens', None)
            allergy= {}
            for allergen in allergens:
                allergy[allergen['name']] = True
            items['allergens'] = allergy
            items['startTime'] = datetime.datetime.strptime(items['startTime'], "%Y-%m-%dT%H:%M:%S")
            items['endTime'] = datetime.datetime.strptime(items['endTime'], "%Y-%m-%dT%H:%M:%S")
    return menu 

def updateMenuData (menu):
    db = firestore.client()
    for days in menu:
        for items in days['menuItems']:
            db.collection(str(days['date'])[:10]).document(str(items['menuItemId'])).set(items)
    return True

cred = credentials.Certificate('/users/tommy/keys/ccsu.json')
firebase_admin.initialize_app(cred)
date ='02/25/2019'

devils_den = 'https://menus.sodexomyway.com/BiteMenu/MenuOnly?menuId=16669&locationId=32736&whereami=http://ccsudining.sodexomyway.com/dining-near-me/devils-den&startDate=' + date
hilltop_cafe = 'https://menus.sodexomyway.com/BiteMenu/MenuOnly?menuId=15271&locationId=32736006&whereami=http://ccsudining.sodexomyway.com/dining-near-me/hilltop-cafe&startDate=' + date
memorial_hall = 'https://menus.sodexomyway.com/BiteMenu/MenuOnly?menuId=15270&locationId=32736003&whereami=http://ccsudining.sodexomyway.com/dining-near-me/memorial-hall&startDate=' + date

devils_den_menu = updateMenuData((prepMenuData(getMenuData(devils_den), 'devils_den')))
print(devils_den_menu)
hilltop_cafe_menu = updateMenuData((prepMenuData(getMenuData(hilltop_cafe), 'hilltop_cafe')))
print(hilltop_cafe_menu)
memorial_hall_menu = updateMenuData((prepMenuData(getMenuData(memorial_hall), 'memorial_hall')))
print(memorial_hall_menu)