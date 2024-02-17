# models/supplier.py
from sqlalchemy import Column, Integer, String
from .base import Base

class Supplier(Base):
    __tablename__ = "suppliers"

    supplier_id = Column(Integer, primary_key=True, index=True)
    supplier_name = Column(String, index=True)
    email = Column(String, unique=True, index=True)
    phone = Column(String)
