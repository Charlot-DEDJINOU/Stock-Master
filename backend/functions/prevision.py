from models.product import Product
from sqlalchemy.orm import Session


def prevision(db: Session):
    prevs = list()
    products = db.query(Product).all()
    
    for product in products:
        if product.quantity_in_stock <= product.quantity_min : 
            prevs.append(
                {
                    "product_id" : product.product_id,
                    "product_name": product.product_name,
                    "status": -1,
                    "message": f"La quantité du produit {product.product_name}  en stock est en dessous ou égale au  seuil minimal. Veuillez enregistrer un achat"
                }
            )
        if product.quantity_in_stock >= product.quantity_max :
            prevs.append(
                {
                    "product_id" : product.product_id,
                    "product_name": product.product_name,
                    "status": 1,
                    "message": f"La quantité du produit {product.product_name} en stock est  au-dessus ou égale au seuil maximal. Arrêtez les achats pour éviter la mevente"
                }
            )
    return prevs