import firebase_admin
from firebase_admin import credentials, firestore
from random import randint
import time


def generate_random_number():
    value = randint(3, 8)
    return value

def setup_firebase():
    cred = credentials.Certificate("centennialcoal-70712-firebase-adminsdk-ruf8n-8840930448.json")
    firebase_admin.initialize_app(cred, {"databaseURL": "CentennialCoal.firebaseio.com/"})
    db = firestore.client()
    doc_ref = db.collection(u'Electricity')
    return doc_ref

if __name__ == '__main__':
    doc_ref = setup_firebase()
    id = 0
    while id < 48:
        value = generate_random_number()
        id += 1
        doc_ref.document().set({u'price':value})
        print(value)
        time.sleep(60)