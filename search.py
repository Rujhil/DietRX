from core import app

def add_to_index(index, model, id):
    if not app.elasticsearch:
        return
    payload = {}
    for field in model.__searchable__:
        payload[field] = getattr(model, field)
    app.elasticsearch.index(index=index, id=getattr(model, id), body=payload)


def remove_from_index(index, model, id):
    if not app.elasticsearch:
        return
    app.elasticsearch.delete(index=index, id=getattr(model, id))
