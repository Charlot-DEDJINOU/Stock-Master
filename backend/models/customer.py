from sqlalchemy import Column, Integer, String
from .base import Base

class Customer(Base):
    __tablename__ = 'customers'
    
    customer_id = Column(Integer, primary_key=True, index=True)
    customer_name = Column(String)
    email = Column(String, index=True)
    phone = Column(String)
    address = Column(String)
    

