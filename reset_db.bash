#!/bin/bash

export FLASK_APP=app.py
export FLASK_DEBUG=1

# Remove old database and migrations
rm -rf migrations/ app.db

# Activate your environment
source myenv/Scripts/activate

# Recreate the database
flask db init
flask db migrate
flask db upgrade
