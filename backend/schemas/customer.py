from pydantic import BaseModel

class CustomerBase(BaseModel):
    customer_name: str
    email: str
    phone: str
    address: str

class CustomerCreate(CustomerBase):
    pass

class Customer(CustomerBase):
    customer_id: int

    class Config:
        orm_mode = True
        from_attributes=True

