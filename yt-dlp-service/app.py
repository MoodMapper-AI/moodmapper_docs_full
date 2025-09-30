from flask import Flask, request, jsonify
import yt_dlp
app = Flask(__name__)

@app.route('/download', methods=['POST'])
def download():
    data = request.get_json() or {}
    url = data.get('url')
    if not url:
        return jsonify({"error":"no url"}),400
    ydl_opts = {'format':'bestaudio/best','quiet':True,'noplaylist':True}
    with yt_dlp.YoutubeDL(ydl_opts) as ydl:
        info = ydl.extract_info(url, download=False)
    return jsonify({"title": info.get('title'), "duration": info.get('duration'), "url": url})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
