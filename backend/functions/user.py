from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import random
import smtplib
import string
from sqlalchemy.orm import Session
from routes.auth import get_password_hash
from models.user import User
from fastapi import HTTPException, status
from schemas.user import UserCreate, User as UserResponse, PasswordFormat
from routes.auth import verify_password, get_password_hash


def create_user(db: Session, username: str, password: str, full_name: str, email: str):
    hashed_password = get_password_hash(password)
    db_user = User(username=username, password=hashed_password, full_name=full_name, email=email, role="user")
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return UserResponse.from_orm(db_user)

def get_user(db: Session, email: str):
    db_user = db.query(User).filter(User.email == email).first()
    if db_user is None : 
        return None
    return UserResponse.from_orm(db_user)

def get_user_by_id(db: Session, id: int):
    db_user = db.query(User).filter(User.user_id == id).first()
    if db_user is None : 
        return None
    return UserResponse.from_orm(db_user)

def get_users(db: Session):
    users = db.query(User).all()
    return [UserResponse.from_orm(user) for user in users]


def update_user(db: Session, user_id: int, user: UserCreate):
    db_user = db.query(User).filter(User.user_id == user_id).first()
    if db_user:
        for key, value in user.dict().items():
            # if key=="password": 
            #     hashed_password = get_password_hash(value)
            #     setattr(db_user, key, hashed_password)
            # else:
            setattr(db_user, key, value)
        db.commit()
        db.refresh(db_user)
        return UserResponse.from_orm(db_user)
    else:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")

def delete_user(db: Session, user_id: int):
    db_user = db.query(User).filter(User.user_id == user_id).first()
    if db_user:
        db.delete(db_user)
        db.commit()
        return UserResponse.from_orm(db_user)
    else:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")




def generate_verification_code(length=6):
    characters = string.digits
    code = ''.join(random.choice(characters) for _ in range(length))
    return code


def send_verification_code_email(email: str, code: str, message: str):
    sender_email = "0dc70c4667bbe7"  
    sender_password = "3055376bcb5bb7"  
    recipient_email = email
    subject = "Stock Master : Code de verification"
    mes = f"{message}: {code}"

    msg = MIMEMultipart()
    msg["From"] = sender_email
    msg["To"] = recipient_email
    msg["Subject"] = subject
    msg.attach(MIMEText(mes, "plain"))

    try:
        server = smtplib.SMTP("sandbox.smtp.mailtrap.io", 587)  
        server.starttls()
        server.login(sender_email, sender_password)
        senders = server.sendmail(sender_email, recipient_email, msg.as_string())
        print(senders)
        print(recipient_email)
        server.quit()
        return True
    except:
        return False
    
    
    


def password_forgot(db: Session, passwords: PasswordFormat):
    user = db.query(User).filter(User.user_id == passwords.user_id).first()
    if user:
        print(f"""
                encien

                {user.password}
            """)
        is_password_valid = verify_password(passwords.old_password, user.password)
        print(is_password_valid)
        if is_password_valid != True:
            raise HTTPException (
            status_code=status.HTTP_406_NOT_ACCEPTABLE, 
            detail="Incorrect old password"
            )
        else:
            user.password = get_password_hash(password=passwords.new_password)
            print(f"""
                changé

                {get_password_hash(password=passwords.new_password)}
            """)
            db.commit()
            db.refresh(user)
            user = db.query(User).filter(User.user_id == passwords.user_id).first()
            print(f"""
                nouveau

                {user.password}
            """)
            return {
                "message" : "Password modified successfully"
            }
    else:
        
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, 
            detail="User not found"
        )



def password_forgot_verify(db: Session, email: str, code: str):
    user = db.query(User).filter(User.email == email).first()(db, email)
    if user:
        if user.code == code:
            db.commit()
            db.refresh(user)
            return user
    return None
    
