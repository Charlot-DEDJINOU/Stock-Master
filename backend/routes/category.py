# routes/category.py
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from functions.category import create_category, get_categories, get_category, update_category, delete_category
from schemas.category import CategoryCreate, Category
from .auth import get_current_user, get_db



category_router = APIRouter(prefix="/categories", tags=["Les actions sur categories"], dependencies=[Depends(get_current_user)])

@category_router.post("/", response_model=Category)
def create(category: CategoryCreate, db: Session = Depends(get_db)):
    return create_category(db, category)

@category_router.get("/", response_model=list[Category])
def read_categories(skip: int = 0, limit: int = 10, db: Session = Depends(get_db)):
    return get_categories(db, skip=skip, limit=limit)

@category_router.get("/{category_id}", response_model=Category)
def read_category(category_id: int, db: Session = Depends(get_db)):
    _category = get_category(db, category_id)
    if _category is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail='Category not found'
        )
    return _category

@category_router.put("/{category_id}", response_model=Category)
def update(category_id: int, category: CategoryCreate, db: Session = Depends(get_db)):
    return update_category(db, category_id, category)

@category_router.delete("/{category_id}", response_model=Category)
def delete(category_id: int, db: Session = Depends(get_db)):
    return delete_category(db, category_id)
