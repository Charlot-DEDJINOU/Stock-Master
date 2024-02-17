# functions/stock_movement.py
from fastapi import HTTPException, status
from sqlalchemy.orm import Session
from schemas.stock_movement import StockMovementCreate, StockMovement as StockMovementResponse
from models.stock_movement import StockMovement
from functions.product import update_product_quantity
from datetime import datetime

def create_stock_movement(db: Session, stock_movement: StockMovementCreate):
    try:
        db_stock_movement = StockMovement(**stock_movement.dict())
        db_stock_movement.movement_date = datetime.now()
        update_product_quantity(db, stock_movement.product_id, stock_movement.quantity, stock_movement.movement_type)
        db.add(db_stock_movement)
        db.commit()
        db.refresh(db_stock_movement)

        # Mise à jour de la quantité en stock dans la table des produits
        return StockMovementResponse.from_orm(db_stock_movement)
    except HTTPException as http_exception:
        if http_exception.status_code == status.HTTP_417_EXPECTATION_FAILED:
            print("\n\n Expected failure: Insufficient quantity in stock \n\n")
            raise http_exception
        else:
            # Handle other HTTPExceptions with different status codes
            print(f"\n\n HTTPException: {http_exception} \n\n")
            raise
    except Exception as e:
        # Handle other exceptions
        print(f"\n\n Error: {e} \n\n")
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"An error occurred when creating StockMovement. Review the data format {e}"
        )

def get_stock_movements(db: Session):
    stock_movements = db.query(StockMovement).all()
    return [StockMovementResponse.from_orm(movement) for movement in stock_movements]

def get_stock_movement(db: Session, movement_id: int):
    db_movement = db.query(StockMovement).filter(StockMovement.movement_id == movement_id).first()
    if db_movement is None:
        return None
    return StockMovementResponse.from_orm(db_movement)

def update_stock_movement(db: Session, id: int, stock_movement : StockMovementResponse):
    db_mouvement = db.query(StockMovement).filter(StockMovement.movement_id == id).first()
    if db_mouvement:
        for key, value in stock_movement.dict().items():
            setattr(db_mouvement, key, value)
        db.commit()
        db.refresh(db_mouvement)
        return StockMovementResponse.from_orm(db_mouvement)
    raise HTTPException(
        status_code=status.HTTP_404_NOT_FOUND,
        detail="Stock movement not found"
    )
    

def delete_stock_movement(db: Session, id: int):
    db_mouvement = db.query(StockMovement).filter(StockMovement.movement_id == id).first()
    if db_mouvement:
        db.delete(db_mouvement)
        db.commit()
        return StockMovementResponse.from_orm(db_mouvement)
    else :
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, 
            detail="supplier not found"
        )


