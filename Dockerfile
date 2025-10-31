# =========================
# Base Python
# =========================
FROM python:3.13-slim AS python-base

# =========================
# Variáveis de ambiente
# =========================
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    POETRY_HOME="/opt/poetry" \
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    POETRY_NO_INTERACTION=1 \
    PYSETUP_PATH="/opt/pysetup" \
    VENV_PATH="/opt/pysetup/.venv"

ENV PATH="$POETRY_HOME/bin:$VENV_PATH/bin:$PATH"

# =========================
# Instala dependências de sistema
# =========================
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        curl \
        git \
        build-essential \
        libpq-dev \
        gcc && \
    rm -rf /var/lib/apt/lists/*

# =========================
# Instala Poetry
# =========================
RUN curl -sSL https://install.python-poetry.org | python3 - && \
    poetry --version
# =========================
# Setup do projeto
# =========================
WORKDIR $PYSETUP_PATH
COPY poetry.lock pyproject.toml ./
RUN poetry install --no-root

# =========================
# Copia app
# =========================
WORKDIR /app
COPY . /app/

EXPOSE 8000

# =========================
# Comando padrão
# =========================
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]