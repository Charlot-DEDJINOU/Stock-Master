# routes/order.py
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from functions.order import create_order, get_orders, get_order, update_order, delete_order
from routes.auth import get_db, get_current_user
from schemas.order import OrderCreate, Order as OrderResponse, OrderUpdate


order_router = APIRouter(prefix="/orders", tags=["Les actions sur les commandes"], dependencies=[Depends(get_current_user)])

@order_router.post("/", response_model=OrderResponse)
def create_order_api(order: OrderCreate, db: Session = Depends(get_db)):
    return create_order(db, order)

@order_router.get("/", response_model=list[OrderResponse])
def read_orders(db: Session = Depends(get_db)):
    return get_orders(db)

@order_router.get("/{order_id}", response_model=OrderResponse)
def read_order(order_id: int, db: Session = Depends(get_db)):
    return get_order(db, order_id)

@order_router.put("/{order_id}", response_model=OrderResponse)
def update_order_api(order_id: int, updated_order: OrderUpdate, db: Session = Depends(get_db)):
    return update_order(db, order_id, updated_order)

@order_router.delete("/{order_id}", response_model=OrderResponse)
def delete_order_api(order_id: int, db: Session = Depends(get_db)):
    return delete_order(db, order_id)
