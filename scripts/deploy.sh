#!/bin/bash
git push heroku master && heroku run rails db:migrate -a pathpen && heroku restart -a pathpen
