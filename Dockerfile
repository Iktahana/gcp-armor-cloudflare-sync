FROM gcr.io/google.com/cloudsdktool/google-cloud-cli:slim

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .

RUN chmod +x update_armor.sh

ENTRYPOINT ["/app/update_armor.sh"]