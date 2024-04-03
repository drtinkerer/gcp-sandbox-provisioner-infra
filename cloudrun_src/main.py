from fastapi import FastAPI


app= FastAPI()

@app.get('/')
def index():
    return{'value': 'Go to https://math-api-cd-4zunylksjq-uc.a.run.app/docs' }
#this is a change

@app.get('/multiply')
def multiply(a,b):
    return{'result': int(a)*int(b)}

@app.get('/substract')
def substract(a,b):

    return{'result': int(a)-int(b)}

@app.get('/sum')
def multiply(a,b):
    return{'result': int(a)+int(b)}
