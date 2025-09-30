#!/usr/bin/env bash                                                                set -e

mkdir -p docs_site
pages_file=$(mktemp)

# Detect versions
versions=$(find docs -mindepth 1 -maxdepth 1 -type d -printf "%f\n" | sort)
# Generate version links                                                           version_links=""
for ver in $versions; do
  version_links="$version_links<li><span class='collapsible'>$ver</span><ul class='nested'>"
  find "docs/$ver" -name "*.md" | sort | while read mdfile; do
    page_name=$(basename "$mdfile" .md)                                                version_links="$version_links<li><a href=\"$ver/$page_name.html\">$page_name</a></li>"                                                                              done
  version_links="$version_links</ul></li>"
done

# Convert all Markdown files to HTML with TOC                                      for ver in $versions; do
  find "docs/$ver" -name "*.md" | while read mdfile; do                                relative_path="${mdfile#docs/$ver/}"
    output_file="docs_site/$ver/${relative_path%.md}.html"                             mkdir -p "$(dirname "$output_file")"
    pandoc "$mdfile" -s --toc -o "$output_file"                                        echo "$output_file" >> "$pages_file"
  done
done
# Generate search index                                                            echo "[" > docs_site/search_index.json
first=true
while read page; do
  title=$(basename "$page" .html)
  content=$(sed ':a;N;$!ba;s/\n/ /g' "$page" | sed 's/"/\\"/g' | sed 's/<[^>]*>//g')
  if [ "$first" = true ]; then first=false; else echo "," >> docs_site/search_index.json; fi
  echo "{\"title\":\"$title\",\"url\":\"${page#docs_site/}\",\"content\":\"$content\"}" >> docs_site/search_index.json
done < "$pages_file"
echo "]" >> docs_site/search_index.json

# Generate homepage with sidebar, search, versions, and tech-team content
cat > docs_site/index.html <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>MoodMapper Documentation</title>
<style>
body { font-family: Arial, sans-serif; margin: 0; display: flex; }
.sidebar { width: 300px; background: #f4f4f4; padding: 20px; overflow-y: auto; height: 100vh; }
.content { flex: 1; padding: 2rem; max-width: 900px; }
h1,h2,h3 { color: #2c3e50; }
ul { list-style: none; padding-left: 1rem; }
li { margin: 0.5rem 0; }
a { text-decoration: none; color: #3498db; }
a:hover { text-decoration: underline; }
.checklist li::before { content: "✅ "; color: green; }
input[type="text"] { width: 100%; padding: 0.5rem; margin-bottom: 1rem; }
.search-result { margin-bottom: 0.5rem; }
.collapsible { cursor: pointer; user-select: none; }
.nested { display: none; margin-left: 1rem; }
.active { display: block; }
.active-page { font-weight: bold; color: #e74c3c; }
.toc-link { font-size: 0.9rem; margin-left: 1rem; }
</style>
</head>
<body>

<div class="sidebar">
  <h2>Docs Navigation</h2>
  <ul id="sidebar-links">
EOF

# Inject versioned nested sidebar
echo "$version_links" >> docs_site/index.html

cat >> docs_site/index.html <<'EOF'
  </ul>
</div>

<div class="content">
  <h1>MoodMapper Documentation</h1>

  <div class="section">
    <h2>Search Docs</h2>
    <input type="text" id="searchBox" placeholder="Type to search..." oninput="searchDocs()">
    <div id="searchResults"></div>
  </div>

  <div class="section">
    <h2>App Overview</h2>
    <p>MoodMapper is a next-generation mood tracking and recommendation application. It captures user mood inputs, analyzes patterns, and delivers personalized insights, scripture references, and playlist recommendations via AI-driven microservices.</p>
  </div>

  <div class="section">
    <h2>App Features</h2>
    <ul>
      <li>Mood Input & Analysis</li>
      <li>Personalized Recommendations (Music, Scriptures, AI Insights)</li>
      <li>Microservices Architecture with Azure Functions</li>
      <li>API Layer Management via Azure API Management</li>
      <li>Dynamic Documentation Deployment via GitHub Pages</li>
      <li>Scalable and Extensible MVP</li>
    </ul>
  </div>

  <div class="section">
    <h2>MVP Delivery Checklist</h2>
    <ul class="checklist">
      <li>Consumer Mobile App MVP</li>
      <li>Mood Ingest Microservice (mm-func-mood-ingest)</li>
      <li>Recommendations Microservice (mm-func-recommendations-dal)</li>
      <li>Azure CosmosDB Integration</li>
      <li>API Layer (APIM) for Mobile App Consumption</li>
      <li>Automated Docs Deployment via GitHub Pages</li>
    </ul>
  </div>
</div>

<script>
// Collapsible sidebar
document.querySelectorAll(".collapsible").forEach(item => {
  item.addEventListener("click", function() {
    this.classList.toggle("active");
    const nested = this.nextElementSibling;
    if (nested.style.display === "block") nested.style.display = "none";
    else nested.style.display = "block";
  });
});

// Highlight active page in sidebar
const currentPage = window.location.pathname.split("/").pop();
document.querySelectorAll("#sidebar-links a").forEach(a => {
  if (a.getAttribute("href") === currentPage) a.classList.add("active-page");
});

// Search functionality
let docs = [];
fetch('search_index.json').then(res => res.json()).then(data => { docs = data; });
function searchDocs() {
  const query = document.getElementById('searchBox').value.toLowerCase();
  const resultsDiv = document.getElementById('searchResults');
  resultsDiv.innerHTML = '';
  if (!query) return;
  const results = docs.filter(d => d.title.toLowerCase().includes(query) || d.content.toLowerCase().includes(query));
  results.forEach(r => {
    const div = document.createElement('div');
    div.className = 'search-result';
    div.innerHTML = '<a href="' + r.url + '">' + r.title + '</a>';
    resultsDiv.appendChild(div);
  });
}
</script>
</body>
</html>
EOF
