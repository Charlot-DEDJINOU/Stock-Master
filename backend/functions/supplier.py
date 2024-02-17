# functions/supplier.py
from sqlalchemy.orm import Session
from models.supplier import Supplier
from schemas.supplier import SupplierCreate, Supplier as SupplierResponse
from fastapi import HTTPException, status



def create_supplier(db: Session, supplier: SupplierCreate):
    try :
        db_supplier = Supplier(**supplier.dict())
        db.add(db_supplier)
        db.commit()
        db.refresh(db_supplier)
        return SupplierResponse.from_orm(db_supplier)
    except Exception as e:
        print(f"\n\n erreur: {e} \n\n")
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="An error occured when creating supplier. Review the data format. May be email already exist"
        )


def get_supplier(db: Session, supplier_id: int):
    
    db_supplier = db.query(Supplier).filter(Supplier.supplier_id == supplier_id).first()
    if db_supplier is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, 
            detail="supplier not found"
        )
    return SupplierResponse.from_orm(db_supplier)


def get_suppliers(db: Session):
    db_suppliers = db.query(Supplier).all()
    return [SupplierResponse.from_orm(supplier) for supplier in db_suppliers]



def update_supplier(db: Session, supplier_id: int, updated_supplier: SupplierResponse):
    db_supplier = db.query(Supplier).filter(Supplier.supplier_id == supplier_id).first()
    if db_supplier:
        for key, value in updated_supplier.dict().items():
            setattr(db_supplier, key, value)
        db.commit()
        db.refresh(db_supplier)
        return SupplierResponse.from_orm(db_supplier)
    else :
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, 
            detail="supplier not found"
        )

def delete_supplier(db: Session, supplier_id: int):
    db_supplier = db.query(Supplier).filter(Supplier.supplier_id == supplier_id).first()
    if db_supplier:
        db.delete(db_supplier)
        db.commit()
        return SupplierResponse.from_orm(db_supplier)
    else :
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, 
            detail="supplier not found"
        )
