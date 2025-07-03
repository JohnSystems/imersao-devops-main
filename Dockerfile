# Use uma imagem base estável e mais compatível.
# A imagem 'slim' é baseada em Debian e tem maior compatibilidade com wheels
# pré-compilados do PyPI, evitando erros de compilação comuns em imagens 'alpine'.
# Usar uma versão estável como a 3.11 em vez de uma beta é uma boa prática.
FROM python:3.11-slim

# Define o diretório de trabalho dentro do contêiner.
# Todos os comandos subsequentes serão executados a partir deste diretório.
WORKDIR /app

# Copia o arquivo de dependências primeiro para aproveitar o cache de camadas do Docker.
# A reinstalação das dependências só ocorrerá se o requirements.txt for alterado.
COPY requirements.txt .

# Instala as dependências do projeto.
# A flag --no-cache-dir reduz o tamanho final da imagem.
RUN pip install --no-cache-dir -r requirements.txt

# Copia todos os arquivos do projeto para o diretório de trabalho no contêiner.
COPY . .

# Expõe a porta 8000, que é a porta padrão que o Uvicorn usará.
EXPOSE 8000

# Comando para iniciar a aplicação quando o contêiner for executado.
# Usamos 0.0.0.0 para que a aplicação seja acessível de fora do contêiner.
# A flag --reload é ótima para desenvolvimento, mas não deve ser usada em produção.
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]