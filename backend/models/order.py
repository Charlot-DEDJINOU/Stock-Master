# models/order.py
from sqlalchemy import Column, Integer, String, ForeignKey, DateTime, Float
from sqlalchemy.orm import relationship
from .base import Base
from .product import Product
from .customer import Customer
from datetime import datetime

class Order(Base):
    __tablename__ = "orders"

    order_id = Column(Integer, primary_key=True, index=True)
    order_date = Column(DateTime, default=datetime.utcnow)
    product_id = Column(Integer, ForeignKey("products.product_id"))
    #customer_id = Column(Integer, ForeignKey("customers.customer_id"))
    quantity = Column(Integer)
    total_amount = Column(Float)    
    status = Column(String)
    customer_name = Column(String)
    customer_contact = Column(String)

    products = relationship("Product", back_populates="orders")
    #customers = relationship("Customer", back_populates="orders")
