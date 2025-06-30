from core import app
from models import Food, Disease, Gene, Chemical

with app.app_context():
    app.elasticsearch.options(ignore_status=[400, 404]).indices.delete(index='food')
    app.elasticsearch.options(ignore_status=[400, 404]).indices.delete(index='disease')
    app.elasticsearch.options(ignore_status=[400, 404]).indices.delete(index='gene')
    app.elasticsearch.options(ignore_status=[400, 404]).indices.delete(index='chemical')

    Food.reindex("food_id")
    Disease.reindex("disease_id")
    Gene.reindex("gene_id")
    Chemical.reindex("pubchem_id")
