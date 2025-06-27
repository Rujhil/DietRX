from core import app
from models import Food, Disease, Gene, Chemical

with app.app_context():
    app.elasticsearch.indices.delete(index='food', ignore=[400, 404])
    app.elasticsearch.indices.delete(index='disease', ignore=[400, 404])
    app.elasticsearch.indices.delete(index='gene', ignore=[400, 404])
    app.elasticsearch.indices.delete(index='chemical', ignore=[400, 404])

    Food.reindex("food_id")
    Disease.reindex("disease_id")
    Gene.reindex("gene_id")
    Chemical.reindex("pubchem_id")
