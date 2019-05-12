#!/bin/bash
counter=0
while [ $counter -le 56 ]
do
    pipenv run python menuScrape.py `date +%D -d "+$counter days"`
    ((counter = counter + 7))
done
