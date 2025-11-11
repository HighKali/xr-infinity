from fastapi import FastAPI
from endpoints import wallet, mining, sync, status
from rpc import router as rpc_router

app = FastAPI(title="HostBlock zDOS")

app.include_router(wallet.router, prefix="/wallet")
app.include_router(mining.router, prefix="/mining")
app.include_router(sync.router, prefix="/sync")
app.include_router(status.router, prefix="/status")
app.include_router(rpc_router.router, prefix="/rpc")

@app.get("/")
def root():
    return {"message": "HostBlock zDOS RPC is running"}

from fastapi.openapi.docs import get_swagger_ui_html
@app.get("/docs", include_in_schema=False)
def custom_docs():
    return get_swagger_ui_html(openapi_url="/openapi.json", title="HostBlock zDOS Docs")
