#!/bin/bash

export FLASK_APP=app.py
export FLASK_DEBUG=1
source myenv/Scripts/activate
flask run
