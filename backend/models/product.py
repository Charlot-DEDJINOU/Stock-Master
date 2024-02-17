from sqlalchemy import Column, Integer, String, Float, ForeignKey
from sqlalchemy.orm import relationship
from .base import Base

class Product(Base):
    __tablename__ = 'products'
    
    product_id = Column(Integer, primary_key=True, index=True)
    product_name = Column(String(250), index=True)
    product_description = Column(String(250))
    category_id = Column(Integer, ForeignKey('categories.category_id'))
    purchase_price = Column(Float)
    selling_price = Column(Float)
    quantity_in_stock = Column(Integer)
    quantity_min = Column(Integer)
    quantity_max = Column(Integer)
    
    category = relationship("Category", back_populates="products")
    # Ajoutez cette ligne pour définir la relation avec stock_movements
    stock_movements = relationship("StockMovement", back_populates="products")
    orders = relationship("Order", back_populates="products")

