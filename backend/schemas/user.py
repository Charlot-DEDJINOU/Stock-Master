from pydantic import BaseModel
from enum import Enum
from typing import Dict

class RoleEnum(str, Enum):
    admin = "admin"
    manager = "manager"
    # Ajoutez d'autres rôles au besoin

class UserBase(BaseModel):
    username: str
    password: str
    full_name: str
    email: str
    

class UserCreate(UserBase):
    pass

class User(UserBase):
    user_id: int
    role: str

    class Config:
        orm_mode = True
        from_attributes=True
        
class LoginDataForm(BaseModel): 
    email :str
    password : str
        
class UserLogin(BaseModel): 
    data :  LoginDataForm
    
class PasswordFormat(BaseModel):
    user_id: int
    new_password: str
    old_password: str


