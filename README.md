# **DietRx - Project Overview**

DietRx is a web-based platform that integrates curated knowledge of **food**, **genes**, **diseases**, and **chemicals**. 

---

## **Folder Structure and Responsibilities**

```
DietRx/
│
├── app.py                  
├── core.py                 
├── config.py               
├── models.py                
├── routes.py               
├── search.py               
├── util.py                  
├── forms.py   
│ 
├── app.db 
│
├── static/                 
│   ├── css/               
│   ├── js/                  
│   └── images/..            
│
├── templates/               
│   ├── common/              
│   └── search/..             
│
├── data/
│   ├── db-dump/            
│   ├── version-3/          
│
├── requirements.txt         
├── reset_elasticsearch.py  
└── .gitattributes           
```

### • **Roles**

- **Backend**: `app.py`, `routes.py`, `models.py`, `config.py`, `forms.py`  
- **Frontend**: `templates/`, `static/`  
- **Database**: `app.db` (SQLite) — generated using the Jupyter notebooks in the `notebooks/` folder  
- **Data Processing**:  
  - Jupyter notebooks:
    - `Get Chemical Properties.ipynb`
    - `Load Data Final.ipynb`
    - `Load Data v4.ipynb`
    - `Load Data v5.ipynb`  
  - These process the `.tsv` files under the `data/` directory and populate the `app.db` database used by the application.

---

##  **Environment Setup**

**1. Create and activate virtual environment**
```bash
python -m venv env
.\env\Scripts\Activate
```

**2. Install Python dependencies**
```bash
pip install -r requirements.txt
```

---

##  **Elasticsearch Setup**

Download and extract Elasticsearch before running.

**1. Download and extract Elasticsearch 7.17.13**  
*(I have attached it in mail)*  
Extract it to:
```
C:\elasticsearch-7.17.13
```

**2. Start Elasticsearch**
```bash
cd C:\elasticsearch-7.17.13\bin
.\elasticsearch.bat
```

**Make sure this stays running in one terminal.** Elasticsearch must be active for `reset_elasticsearch.py` to work.

##  **Running the Application**

Once the environment and Elasticsearch are ready (open a new terminal):

**Step 1: Build Elasticsearch index**
```bash
python reset_elasticsearch.py
```

**Step 2: Launch the Flask application**
```bash
python app.py
```

Access the app at:  
[http://127.0.0.1:5000](http://127.0.0.1:5000)
