# routes/stock_movement.py
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from functions.stock_movement import create_stock_movement, get_stock_movements, get_stock_movement, update_stock_movement, delete_stock_movement
from schemas.stock_movement import StockMovementCreate, StockMovement as  StockMovementResponse
from .auth import get_current_user, get_db



stock_router = APIRouter(prefix="/stock_movements", tags=["Les actions sur les mouvement de stock"], dependencies=[Depends(get_current_user)])

@stock_router.post("/", response_model=StockMovementResponse)
def create_stock(stock_movement: StockMovementCreate, db: Session = Depends(get_db)):
    return create_stock_movement(db, stock_movement)

@stock_router.get("/", response_model=list[StockMovementResponse])
def read_stock_movements( db: Session = Depends(get_db)):
    return get_stock_movements(db)

@stock_router.get("/{movement_id}", response_model=StockMovementResponse)
def read_stock_movement(movement_id: int, db: Session = Depends(get_db)):
    _stock_movement = get_stock_movement(db, movement_id)
    if _stock_movement is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, 
            detail='stock not found'
        )
    return _stock_movement


@stock_router.put("/{movement_id}", response_model=StockMovementResponse)
def update_stock(movement_id: int, stock_movement: StockMovementCreate, db: Session = Depends(get_db)):
    return update_stock_movement(db=db, stock_movement=stock_movement, id=movement_id)



@stock_router.delete("/{movement_id}", response_model=StockMovementResponse)
def delete_stock(movement_id: int, db: Session = Depends(get_db)):
    return delete_stock_movement(id=movement_id, db=db)
