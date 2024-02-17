from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import relationship
from .base import Base

class Category(Base):
    __tablename__ = 'categories'
    
    category_id = Column(Integer, primary_key=True, index=True)
    category_name = Column(String, index=True)
    
    products = relationship("Product", back_populates="category")

