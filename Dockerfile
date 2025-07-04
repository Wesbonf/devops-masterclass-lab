FROM python:3.10

# Define variáveis de ambiente para otimizar a execução do Python em contêineres
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /app

# Copia o arquivo de dependências primeiro para aproveitar o cache do Docker
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Cria um usuário e grupo 'app' sem privilégios de root
RUN addgroup --system app && adduser --system --group app
# Alterna para o usuário 'app'
USER app

# Copia o restante do código da aplicação
COPY . .

EXPOSE 8000

# Executa a aplicação com Gunicorn como gerenciador de processos para os workers do Uvicorn
# Lembre-se de adicionar 'gunicorn' ao seu arquivo requirements.txt
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]