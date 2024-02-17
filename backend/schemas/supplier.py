# schemas/supplier.py
from pydantic import BaseModel

class SupplierBase(BaseModel):
    supplier_name: str
    email: str
    phone: str

class SupplierCreate(SupplierBase):
    pass

class Supplier(SupplierBase):
    supplier_id: int

    class Config:
        orm_mode = True
        from_attributes=True
