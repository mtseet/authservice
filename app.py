from typing import Optional,Dict,Any

from fastapi import FastAPI, Header, Response, Cookie, Form, Body, Request

from pydantic import BaseModel

class Credential(BaseModel):
    username: str
    password: str

app = FastAPI()

db={}
tokens={}

@app.get("/reset")
def auth():
    
    db.clear()
    tokens.clear()

    return {"status":"OK"}


@app.post("/auth")
def auth(credential: Credential,response: Response):
    
    password = db.get(credential.username,None)

    if password==None or password != credential.password:
        response.status_code = 403
        return {"status": "Invalid Username Password"}

    tokens["1234"] = True
    return {"status":"OK","token":"1234"}

@app.get("/authvalidate")
def authvalidate(token:str, response:Response):

    if not tokens.get(token,False):
        response.status_code = 403
        return {"status": "Invalid Token"}

    return {"status":"OK"}

@app.post("/register")
def register(credential: Credential,response: Response):

    password = db.get(credential.username,None)

    if password != None:
        response.status_code = 403
        return {"status": "Account not available"}

    db[credential.username] = credential.password

    return {"status":"OK"}


@app.get("/logout")
def logout(token:str,response: Response):

    if not tokens.get(token,False):
        response.status_code = 403
        return {"status": "Invalid Token"}

    del tokens[token]
    return {"status":"OK"}



