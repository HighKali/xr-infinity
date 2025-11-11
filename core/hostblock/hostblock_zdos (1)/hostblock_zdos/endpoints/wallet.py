from fastapi import APIRouter
router = APIRouter()

@router.get("/")
def wallet_endpoint():
    return {"address": "dsn1xyz...", "balance": 0.0}
