import logging
import azure.functions as func
import json
def main(req: func.HttpRequest) -> func.HttpResponse:
    try:
        body = req.get_json()
    except:
        body = {}
    mood = {
        "id": "m-"+body.get("userId","unknown"),
        "userId": body.get("userId"),
        "mood": body.get("mood"),
        "transcript": body.get("transcript"),
        "confidence": body.get("confidence", 0.0),
    }
    logging.info("Received mood: %s", mood)
    return func.HttpResponse(json.dumps({"moodId": mood["id"]}), mimetype="application/json")
