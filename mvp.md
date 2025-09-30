# 🎶 MoodMapper – Quantum Edition (MVP)

## Overview
MoodMapper is your first emotional companion app, powered by AI, scripture, and music.
It ingests moods, generates insights, and provides personalized playlists and scripture to align your emotional state with divine harmony.

## API Endpoints

### `POST /mood`
- Accepts user mood input
- Triggers OpenAI prompt engineering
- Persists results to Cosmos DB

### `GET /recommendations`
- Returns unified payload with `scriptures`, `playlist`, and `insights`

### `POST /agent`
- Conversational orchestration endpoint (OpenAI-driven)

## Data Persistence (Cosmos DB)
Collections:
- `Moods` (userId, mood, confidence, timestamp, transcript)
- `Recommendations` (moodId, payload{scriptures, playlist, insights}, timestamp)
- `AgentSessions` (context, active, insights)

See `/docs/api.md` for full schemas and sample requests.
