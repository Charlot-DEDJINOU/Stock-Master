from sqlalchemy import Column, Integer, String, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from .base import Base


class StockMovement(Base):
    __tablename__ = 'stock_movements'
    
    movement_id = Column(Integer, primary_key=True, index=True)
    product_id = Column(Integer, ForeignKey('products.product_id'))
    movement_type = Column(String)
    quantity = Column(Integer)
    movement_date = Column(DateTime)
    notes = Column(String)
    
    # Ajoutez cette ligne pour définir la relation avec product
    products = relationship("Product", back_populates="stock_movements")
