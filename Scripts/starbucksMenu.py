#!/usr/bin/env python
# -*- coding: utf-8 -*-
import firebase_admin
import csv
from firebase_admin import credentials
from firebase_admin import firestore
import datetime
import sys
from pathlib import Path

def parse_csv(parse_path):
    parse_file = Path(parse_path)
    csv_list = []
    with open(parse_file, mode='r') as csv_file:
        csv_reader = csv.DictReader(csv_file)
        line_count = 0
        for row in csv_reader:
            csv_list.append(row)
    csv_file.close()
    return csv_list

def updateMenuData (drinks):
    db = firestore.client()
    for drink in drinks:
        db.collection(str(date)).document(str(drink['menuItemId'])).set(drink)
        print(drink['formalName'] + " written to database")
    return True

def percent(percent):
    if type(percent) is str:
        return float(percent.replace("%", "")) / 100
    return percent
food = parse_csv('starbucks_food.csv')
drinks = parse_csv('starbucks_drinks.csv')
VIT_A_DV = 900
VIT_C_CV = 90
CAL_DV = 1000
IRON_DV = 8

sizes = ['Tall', 'Short', 'Venti', 'Grande']
size = ''
counter = 0
counter_b = 500
for drink in drinks:
    temp_size = drink['Beverage_prep'].split()[0]
    if temp_size in sizes:
        size = temp_size
        drink['formalName'] = drink['Beverage_prep'] + " " + drink['Beverage']
    elif drink['Beverage'] == 'Espresso':
        drink['formalName'] = drink['Beverage_prep'] + " " + drink['Beverage']
    else:
       drink['formalName'] = size + " " + drink['Beverage_prep'] + " " +drink['Beverage']
    drink['vitaminA'] = str(percent(drink['vitaminA']) * VIT_A_DV) + " " + "mcg"
    drink['vitaminC'] = str(percent(drink['vitaminC']) * VIT_C_CV) + " " + "mg"
    drink['calcium'] = str(percent(drink['calcium']) * CAL_DV) + " " + "mg"
    drink['iron'] = str(percent(drink['iron']) * IRON_DV) + " " + "mg"
    drink['menuItemId'] = counter
    counter = counter + 1
    drink['dining_hall'] = 'Starbucks'
for item in food:
  item['menuItemId'] = counter_b
  counter_b = counter_b + 1 
  item['dining_hall'] = "Starbucks"
cred = credentials.Certificate('./db_key.json')
firebase_admin.initialize_app(cred)
date = str(sys.argv[1])
#print(updateMenuData(drinks))
print(updateMenuData(food))
