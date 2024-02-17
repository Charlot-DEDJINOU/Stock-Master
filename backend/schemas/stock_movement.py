from pydantic import BaseModel
from datetime import datetime
from typing import List

class StockMovementBase(BaseModel):
    product_id: int
    movement_type: str
    quantity: int
    notes: str

class StockMovementCreate(StockMovementBase):
    pass

class StockMovement(StockMovementBase):
    movement_id: int
    movement_date: datetime

    class Config:
        orm_mode = True
        from_attributes=True

