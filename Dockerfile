FROM python:3.10-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update &&     apt install -y curl unzip &&     curl -L https://github.com/foundry-rs/foundry/releases/latest/download/anvil-linux.zip -o anvil.zip &&     unzip anvil.zip -d /usr/local/bin &&     chmod +x /usr/local/bin/anvil &&     rm anvil.zip

WORKDIR /app
COPY . .

RUN pip install -r requirements.txt

EXPOSE 8545

CMD ["sh", "start.sh"]