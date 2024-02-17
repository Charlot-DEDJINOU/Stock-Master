from pydantic import BaseModel
from typing import List

class ProductBase(BaseModel):
    product_name: str
    product_description: str
    category_id: int
    purchase_price: float
    selling_price: float
    quantity_in_stock: int
    quantity_min: int
    quantity_max: int

class ProductCreate(ProductBase):
    pass

class Product(ProductBase):
    product_id: int

    class Config:
        orm_mode = True
        from_attributes=True

