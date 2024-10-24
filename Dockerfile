ARG PYTHON_VERSION
FROM python:${PYTHON_VERSION}-slim-bookworm

RUN apt update && \
    apt install -y curl && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

ARG USERNAME=ryeuser
RUN useradd ${USERNAME} --create-home
USER ${USERNAME}

WORKDIR /home/${USERNAME}/app

ENV RYE_HOME /home/${USERNAME}/.rye
ENV PATH ${RYE_HOME}/shims:/home/${USERNAME}/app/.venv/bin:${PATH}

RUN curl -sSf https://rye.astral.sh/get | RYE_NO_AUTO_INSTALL=1 RYE_INSTALL_OPTION="--yes" bash

# For kaniko
# kaniko does not support RUN --mount
# https://github.com/GoogleContainerTools/kaniko/issues/1568
# COPY ./pyproject.toml ./requirements*.lock ./.python-version ./README.md ./
# RUN rye sync --no-dev --no-lock

RUN --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    --mount=type=bind,source=requirements.lock,target=requirements.lock \
    --mount=type=bind,source=requirements-dev.lock,target=requirements-dev.lock \
    --mount=type=bind,source=.python-version,target=.python-version \
    --mount=type=bind,source=README.md,target=README.md \
    rye sync --no-dev --no-lock

COPY . .

ENTRYPOINT ["python3", "./src/main.py"]
