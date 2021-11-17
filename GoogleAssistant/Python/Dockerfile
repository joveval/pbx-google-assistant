FROM python:alpine3.14

RUN apt-get update && \
    apt-get install -y \
            python3-dev \
            python3-venv \
            portaudio19-dev \
            libffi-dev \
            libssl-dev
RUN python -m pip install --upgrade google-assistant-sdk[samples] 

RUN python -m pip install --upgrade google-auth-oauthlib[tool]