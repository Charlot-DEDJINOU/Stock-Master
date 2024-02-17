# routes/product.py
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from functions.product import create_product, get_products, get_product, update_product, delete_product
from schemas.produt import ProductCreate,  Product as ProductResponse
from routes.auth import get_db
from .auth import get_current_user

product_router = APIRouter(prefix="/products", tags=["Les actions sur les produits"], dependencies=[Depends(get_current_user)])

@product_router.post("/", response_model=ProductResponse)
def create(product: ProductCreate, db: Session = Depends(get_db)):
    return create_product(db, product)

@product_router.get("/", response_model=list[ProductResponse])
def read_products(skip: int = 0, limit: int = 10, db: Session = Depends(get_db)):
    return get_products(db, skip=skip, limit=limit)

@product_router.get("/{product_id}", response_model=ProductResponse)
def read_product(product_id: int, db: Session = Depends(get_db)):
    _product = get_product(db, product_id)
    
    if _product is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, 
            detail="Product not found"
        )
    return _product

@product_router.put("/{product_id}", response_model=ProductResponse)
def update(product_id: int, product: ProductCreate, db: Session = Depends(get_db)):
    return update_product(db, product_id, product)

@product_router.delete("/{product_id}", response_model=ProductResponse)
def delete(product_id: int, db: Session = Depends(get_db)):
    return delete_product(db, product_id)
