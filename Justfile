# Better Fantasy — task runner.
# Edit `host` once, or override per-call: `just deploy host=user@server`

host := "home"
dest := "/var/www/better-fantasy"
url  := "https://better-fantasy.pecar.me"

# List all recipes
default:
    @just --list

# Push the app files to the server and fix ownership
deploy:
    @echo "Deploying to {{host}}:{{dest}} ..."
    rsync -avz --human-readable \
        index.html service-worker.js manifest.webmanifest icon.svg icons \
        {{host}}:{{dest}}/
    ssh {{host}} 'sudo chown -R $USER:www-data {{dest}} && \
        sudo find {{dest}} -type d -exec chmod 755 {} + && \
        sudo find {{dest}} -type f -exec chmod 644 {} +'
    @echo "Deployed: {{url}}"

# Regenerate PNG icons from icon.svg
icons:
    rsvg-convert -w 180  -h 180  icon.svg -o icons/icon-180.png
    rsvg-convert -w 192  -h 192  icon.svg -o icons/icon-192.png
    rsvg-convert -w 512  -h 512  icon.svg -o icons/icon-512.png
    rsvg-convert -w 1024 -h 1024 icon.svg -o icons/icon-1024-maskable.png

# Tail the nginx error log on the server
logs:
    ssh {{host}} 'sudo tail -f /var/log/nginx/error.log'
