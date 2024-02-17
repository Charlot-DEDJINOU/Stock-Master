# functions/customer.py
from sqlalchemy.orm import Session
from schemas.customer import CustomerCreate, Customer as CustomerResponse
from models.customer import Customer
from fastapi import HTTPException, status

def create_customer(db: Session, customer: CustomerCreate):
    db_customer = Customer(**customer.dict())
    db.add(db_customer)
    db.commit()
    db.refresh(db_customer)
    return CustomerResponse.from_orm(db_customer)

def get_customers(db: Session, skip: int = 0, limit: int = 10):
    customers = db.query(Customer).offset(skip).limit(limit).all()
    return [CustomerResponse.from_orm(customer) for customer in customers]

def get_customer(db: Session, customer_id: int):
    db_customer = db.query(Customer).filter(Customer.customer_id == customer_id).first()
    if db_customer is None:
        return None
    return CustomerResponse.from_orm(db_customer)

def update_customer(db: Session, customer_id: int, customer: CustomerCreate):
    db_customer = db.query(Customer).filter(Customer.customer_id == customer_id).first()
    if db_customer:
        for key, value in customer.dict().items():
            setattr(db_customer, key, value)
        db.commit()
        db.refresh(db_customer)
        return CustomerResponse.from_orm(db_customer)
    else:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Customer not found")

def delete_customer(db: Session, customer_id: int):
    db_customer = db.query(Customer).filter(Customer.customer_id == customer_id).first()
    if db_customer:
        db.delete(db_customer)
        db.commit()
        return CustomerResponse.from_orm(db_customer)
    else:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Customer not found")
