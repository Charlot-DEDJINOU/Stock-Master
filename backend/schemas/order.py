# schemas/order.py
from pydantic import BaseModel
from datetime import datetime
from typing import Optional

class OrderBase(BaseModel):
    product_id: int
    quantity: int
    total_amount: float
    status: str
    customer_name: str
    customer_contact: str

class OrderCreate(OrderBase):
    pass

class OrderUpdate(OrderBase):
    order_id: int

class Order(OrderBase):
    order_id: int
    order_date: Optional[datetime] = None

    class Config:
        orm_mode = True
        from_attributes=True
        
