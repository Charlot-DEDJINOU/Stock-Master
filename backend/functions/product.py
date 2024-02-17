# functions/product.py
from sqlalchemy.orm import Session
from schemas.produt import ProductCreate, Product as ProductResponse
from models.product import Product
from fastapi import HTTPException, status

def create_product(db: Session, product: ProductCreate):
    db_product = Product(**product.dict())
    db.add(db_product)
    db.commit()
    db.refresh(db_product)
    return ProductResponse.from_orm(db_product)

def get_products(db: Session, skip: int = 0, limit: int = 10):
    products = db.query(Product).offset(skip).limit(limit).all()
    return [ProductResponse.from_orm(product) for product in products]

def get_product(db: Session, product_id: int):
    db_product = db.query(Product).filter(Product.product_id == product_id).first()
    if db_product is None:
        return None
    return ProductResponse.from_orm(db_product)

def update_product(db: Session, product_id: int, product: ProductCreate):
    db_product = db.query(Product).filter(Product.product_id == product_id).first()
    if db_product:
        for key, value in product.dict().items():
            setattr(db_product, key, value)
        db.commit()
        db.refresh(db_product)
        return ProductResponse.from_orm(db_product)
    else:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Product not found")

def delete_product(db: Session, product_id: int):
    db_product = db.query(Product).filter(Product.product_id == product_id).first()
    if db_product:
        db.delete(db_product)
        db.commit()
        return ProductResponse.from_orm(db_product)
    else:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Product not found")




def update_product_quantity(db: Session, product_id: int, quantity: int, movement_type: str):
    db_product = db.query(Product).filter(Product.product_id == product_id).first()

    if db_product:
        if movement_type.lower() == "achat":
            db_product.quantity_in_stock += quantity
        elif movement_type.lower() == "vente":
            if quantity > db_product.quantity_in_stock:
                raise HTTPException(
                    status_code=status.HTTP_417_EXPECTATION_FAILED,
                    detail=' Expected failure: insuffisant quantity in stock. You can add'
                )
            else:
                db_product.quantity_in_stock -= quantity

        db.commit()
        db.refresh(db_product)
    else:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Product not found")