from sqlalchemy import Column, Integer, String, Enum, Float, ForeignKey, DateTime
from .base import Base
from sqlalchemy.orm import relationship

class RoleEnum(str, Enum):
    admin = "admin"
    manager = "manager"
    # Ajoutez d'autres rôles au besoin

class User(Base):
    __tablename__ = 'users'
    
    user_id = Column(Integer, primary_key=True, index=True)
    username = Column(String(50), unique=True, index=True)
    password = Column(String(255))
    full_name = Column(String(255))
    email = Column(String(255), unique=True, index=True)
    role = Column(String(50))
    
