param(
  [int]$Port = 3000,
  [string]$Root = "."
)

$ErrorActionPreference = 'Stop'
$Root = (Resolve-Path $Root).Path

$mime = @{
  ".html"="text/html; charset=utf-8"; ".htm"="text/html; charset=utf-8"
  ".js"="application/javascript; charset=utf-8"; ".mjs"="application/javascript; charset=utf-8"
  ".css"="text/css; charset=utf-8"; ".json"="application/json; charset=utf-8"
  ".png"="image/png"; ".jpg"="image/jpeg"; ".jpeg"="image/jpeg"
  ".gif"="image/gif"; ".svg"="image/svg+xml; charset=utf-8"; ".ico"="image/x-icon"
  ".webp"="image/webp"
  ".mp3"="audio/mpeg"; ".wav"="audio/wav"; ".ogg"="audio/ogg"; ".m4a"="audio/mp4"
  ".mp4"="video/mp4"
  ".woff"="font/woff"; ".woff2"="font/woff2"; ".ttf"="font/ttf"
  ".txt"="text/plain; charset=utf-8"
}

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$Port/")
$listener.Prefixes.Add("http://127.0.0.1:$Port/")
try { $listener.Start() } catch {
  Write-Host "Failed to bind port $Port`: $_"
  exit 1
}

Write-Host "Serving $Root"
Write-Host "Listening on http://localhost:$Port/"
Write-Host "Default: slideshow.html"

try {
  while ($listener.IsListening) {
    $ctx = $listener.GetContext()
    $req = $ctx.Request
    $res = $ctx.Response

    try {
      $rel = [Uri]::UnescapeDataString($req.Url.AbsolutePath.TrimStart('/'))
      if ([string]::IsNullOrEmpty($rel)) { $rel = 'slideshow.html' }

      # Prevent path traversal
      $path = [IO.Path]::GetFullPath((Join-Path $Root $rel))
      if (-not $path.StartsWith($Root, [StringComparison]::OrdinalIgnoreCase)) {
        $res.StatusCode = 403
        $res.Close()
        continue
      }

      if (Test-Path -LiteralPath $path -PathType Container) {
        $path = Join-Path $path 'index.html'
      }

      if (Test-Path -LiteralPath $path -PathType Leaf) {
        $ext = [IO.Path]::GetExtension($path).ToLower()
        if ($mime.ContainsKey($ext)) {
          $res.ContentType = $mime[$ext]
        } else {
          $res.ContentType = 'application/octet-stream'
        }
        $bytes = [IO.File]::ReadAllBytes($path)
        $res.ContentLength64 = $bytes.Length
        $res.Headers.Add('Cache-Control', 'no-cache')
        $res.OutputStream.Write($bytes, 0, $bytes.Length)
        $res.StatusCode = 200
      } else {
        $res.StatusCode = 404
        $msg = [Text.Encoding]::UTF8.GetBytes("404 Not Found: $rel")
        $res.OutputStream.Write($msg, 0, $msg.Length)
      }
    } catch {
      $res.StatusCode = 500
      $err = [Text.Encoding]::UTF8.GetBytes("500: $_")
      try { $res.OutputStream.Write($err, 0, $err.Length) } catch {}
    } finally {
      try { $res.Close() } catch {}
    }

    Write-Host "$($req.HttpMethod) $($req.Url.AbsolutePath) -> $($res.StatusCode)"
  }
} finally {
  $listener.Stop()
  $listener.Close()
}
