# functions/category.py
from sqlalchemy.orm import Session
from schemas.category import CategoryCreate, Category as CategoryResponse
from models.category import Category
from fastapi import HTTPException, status

def create_category(db: Session, category: CategoryCreate):
    db_category = Category(**category.dict())
    db.add(db_category)
    db.commit()
    db.refresh(db_category)
    return CategoryResponse.from_orm(db_category)

def get_categories(db: Session, skip: int = 0, limit: int = 10):
    categories = db.query(Category).offset(skip).limit(limit).all()
    return [CategoryResponse.from_orm(category) for category in categories]

def get_category(db: Session, category_id: int):
    db_category = db.query(Category).filter(Category.category_id == category_id).first()
    if not db_category:
        return None
    return CategoryResponse.from_orm(db_category)

def update_category(db: Session, category_id: int, category: CategoryCreate):
    db_category = db.query(Category).filter(Category.category_id == category_id).first()
    if db_category:
        for key, value in category.dict().items():
            setattr(db_category, key, value)
        db.commit()
        db.refresh(db_category)
        return CategoryResponse.from_orm(db_category)
    else:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Category not found")

def delete_category(db: Session, category_id: int):
    db_category = db.query(Category).filter(Category.category_id == category_id).first()
    if db_category:
        db.delete(db_category)
        db.commit()
        return CategoryResponse.from_orm(db_category)
    else:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Category not found")
