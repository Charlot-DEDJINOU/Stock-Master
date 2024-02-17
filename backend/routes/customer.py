# routes/customer.py
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from functions.custumer import create_customer, get_customers, get_customer, update_customer, delete_customer
from schemas.customer import CustomerCreate, Customer as CustomerResponse
from routes.auth import get_db
from .auth import get_current_user



customer_router = APIRouter(prefix="/customers", tags=["Les actions sur les clients"], dependencies=[Depends(get_current_user)])

@customer_router.post("/", response_model=CustomerResponse)
def create(customer: CustomerCreate, db: Session = Depends(get_db)):
    return create_customer(db, customer)

@customer_router.get("/", response_model=list[CustomerResponse])
def read_customers(skip: int = 0, limit: int = 10, db: Session = Depends(get_db)):
    return get_customers(db, skip=skip, limit=limit)

@customer_router.get("/{customer_id}", response_model=CustomerResponse)
def read_customer(customer_id: int, db: Session = Depends(get_db)):
    _customer = get_customer(db, customer_id)
    if not _customer:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail='Customer not found'
        )

@customer_router.put("/{customer_id}", response_model=CustomerResponse)
def update(customer_id: int, customer: CustomerCreate, db: Session = Depends(get_db)):
    return update_customer(db, customer_id, customer)

@customer_router.delete("/{customer_id}", response_model=CustomerResponse)
def delete(customer_id: int, db: Session = Depends(get_db)):
    return delete_customer(db, customer_id)
