from fastapi import APIRouter
router = APIRouter()

@router.get("/")
def rpc_root():
    return {"rpc": "HostBlock zDOS"}
