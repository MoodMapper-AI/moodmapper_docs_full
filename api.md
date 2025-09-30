# MoodMapper API Reference

## POST /mood
Request:
```
POST /mood
Content-Type: application/json

{
  "userId": "u123",
  "mood": "anxious",
  "inputType": "voice",
  "transcript": "I'm feeling overwhelmed",
  "timestamp": "2025-09-28T14:00:00Z"
}
```

Response:
```
{ "moodId": "m123", "status": "stored" }
```

## GET /recommendations?moodId=m123
Response unified payload:
```json
{
  "scriptures": [
    {"reference":"Philippians 4:6-7","text":"Do not be anxious..." ,"translation":"NIV","theme":"peace"}
  ],
  "playlist": {
    "title":"Calm Spirit – Soul Resonance",
    "description":"A playlist to ease anxiety.",
    "tracks":[
      {"title":"Oceans","artist":"Hillsong UNITED","url":"https://music.youtube.com/watch?v=abc123","duration":315}
    ],
    "source":"YouTube Music",
    "fetchedWith":"yt-dlp"
  },
  "insights":["You are not alone in this moment."]
}
```

## POST /agent
Request:
```
POST /agent
{ "userId":"u123", "query":"I feel lost" }
```
Response: consolidated conversational response (scripture, playlist, insight).
