FROM ubuntu:latest
RUN apt-get update && apt-get install -y gawk sed
WORKDIR /app
COPY script.sh /app/
RUN chmod +x script.sh
CMD ["./script.sh"]
