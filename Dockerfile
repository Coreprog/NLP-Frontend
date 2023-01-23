# app/Dockerfile

FROM continuumio/miniconda3

WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    software-properties-common \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/Coreprog/NLP-Frontend.git .

RUN conda env create -f environment.yml
SHELL ["conda", "run", "-n", "frontend", "/bin/bash", "-c"]
RUN python -m spacy download de_core_news_lg

RUN conda install -c conda-forge sumy


EXPOSE 8501

HEALTHCHECK CMD curl --fail http://localhost:8501/_stcore/health

ENTRYPOINT ["streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0"]