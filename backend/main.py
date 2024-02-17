from fastapi import FastAPI
from models.base import Base, engine
from fastapi.middleware.cors import CORSMiddleware
from routes.user import  user_router
from routes.product import product_router
from routes.category import category_router
from routes.customer import customer_router
from routes.stock_movement import stock_router
from routes.supplier import supplier_router
from routes.order import order_router
from routes.prevision import router


def create_database():
    Base.metadata.create_all(bind=engine)
    


create_database()
app = FastAPI()


# Middleware pour autoriser les requêtes CORS 
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], 
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(user_router)
app.include_router(product_router)
app.include_router(category_router)
app.include_router(customer_router)
app.include_router(stock_router)
app.include_router(supplier_router)
app.include_router(order_router)
app.include_router(router)


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="192.168.1.88", port=8000)

