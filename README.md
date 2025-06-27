# DietRX
Project Overview
->DietRx: A web-based platform integrating food, gene, disease, and chemical data.
->Technologies used: Flask (Python), SQLAlchemy, MySQL, Elasticsearch, Bootstrap/HTML/JS, etc.

<!-- Create Env and activate for Windows -->
python -m venv env   
.\env\Scripts\activate
<!-- Install the packages -->
pip install -r requirements.txt

<!-- Run Elasticsearch through this zip in one the terminal (see the path)-->
cd C:\elasticsearch-7.17.13\bin  

.\elasticsearch.bat

<!-- Run reset_elasticsearch.py in another terminal -->
python reset_elasticsearch.py  


<!-- Once reset_elasticsearch.py runs then-->
<!-- RUn Python File -->
python app.py   

