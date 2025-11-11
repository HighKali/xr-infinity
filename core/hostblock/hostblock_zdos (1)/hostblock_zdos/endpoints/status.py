from fastapi import APIRouter
router = APIRouter()

@router.get("/")
def status_endpoint():
    return {
        "uptime": "24h",
        "modules": ["wallet", "mining", "sync"],
        "version": "1.0.0",
        "host": "localhost",
        "port": 8080
    }
