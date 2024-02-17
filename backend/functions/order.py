# functions/order.py
from datetime import datetime
from sqlalchemy.orm import Session
from models.order import Order
from schemas.order import OrderCreate, Order as OrderResponse
from fastapi import HTTPException, status


def create_order(db: Session, order: OrderCreate):
    try:
        db_order = Order(**order.dict())
        db_order.order_date = datetime.now()
        db.add(db_order)
        db.commit()
        db.refresh(db_order)
        return OrderResponse.from_orm(db_order)
    except Exception as e:
        print(f"\n\n erreur: {e} \n\n")
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="An error occured when creating order. Review the data format"
        )


def get_orders(db: Session):
    db_orders = db.query(Order).all()
    return [OrderResponse.from_orm(db_order) for db_order in db_orders]



def get_order(db: Session, order_id: int):
    db_order = db.query(Order).filter(Order.order_id == order_id).first()
    if db_order : 
        return OrderResponse.from_orm(db_order)
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Order not found"
        )

def update_order(db: Session, order_id: int, updated_order: OrderResponse):
    db_order = db.query(Order).filter(Order.order_id == order_id).first()
    if db_order:
        for key, value in updated_order.dict().items():
            setattr(db_order, key, value)
        db.commit()
        db.refresh(db_order)
        return OrderResponse.from_orm(db_order)
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Order not found"
        )

def delete_order(db: Session, order_id: int):
    db_order = db.query(Order).filter(Order.order_id == order_id).first()
    if db_order:
        db.delete(db_order)
        db.commit()
        return OrderResponse.from_orm(db_order)
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Order not found"
        )