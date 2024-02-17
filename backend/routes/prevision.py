from fastapi import status, HTTPException, Depends, APIRouter
from sqlalchemy.orm import Session
from .auth import get_current_user, get_db
from functions.prevision import prevision



router = APIRouter(prefix="/previsions", tags=["L'action sur les previsions"], dependencies=[Depends(get_current_user)])

@router.get("/",response_model=list[dict])
def get_previsions(db: Session = Depends(get_db)):
    return prevision(db=db)