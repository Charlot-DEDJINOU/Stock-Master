# routes/supplier.py
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from functions.supplier import create_supplier, get_suppliers, get_supplier, update_supplier, delete_supplier
from routes.auth import get_db,  get_current_user
from schemas.supplier import SupplierCreate, Supplier as SupplierResponse

supplier_router = APIRouter(prefix="/suppliers", tags=["Les actions sur les fournisseurs"], dependencies=[Depends(get_current_user)])

@supplier_router.post("/", response_model=SupplierResponse)
def create_supplier_api(supplier: SupplierCreate, db: Session = Depends(get_db)):
    return create_supplier(db, supplier)

@supplier_router.get("/", response_model=list[SupplierResponse])
def read_suppliers(db: Session = Depends(get_db)):
    return get_suppliers(db)

@supplier_router.get("/{supplier_id}", response_model=SupplierResponse)
def read_supplier(supplier_id: int, db: Session = Depends(get_db)):
    return get_supplier(db, supplier_id)

@supplier_router.put("/{supplier_id}", response_model=SupplierResponse)
def update_supplier_api(supplier_id: int, updated_supplier: SupplierResponse, db: Session = Depends(get_db)):
    return update_supplier(db, supplier_id, updated_supplier)

@supplier_router.delete("/{supplier_id}", response_model=SupplierResponse)
def delete_supplier_api(supplier_id: int, db: Session = Depends(get_db)):
    return delete_supplier(db, supplier_id)
