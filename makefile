.PHONY: help

help: ## Descrição dos comandos
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

# Gera docker-compose.yml da iamgem de Ozone
generate-compose: ## Gera docker-compose.yaml da imagem de Ozone
	docker run apache/ozone cat docker-compose.yaml > docker-compose.yaml

# Gera configuracao da imagem de Ozone
generate-config: ## Gera configuracao da imagem de Ozone
	docker run apache/ozone cat docker-config > docker-config

# Coloca o docker-compose em execução
run: ## Build the container
	docker-compose up -d 

# Escala para 10 nós
scale: ## Escala para 10 nós
	docker-compose scale datanode=10

# Cria S3 bucket no Ozone
create-s3: ## Cria um S3 bucket no Ozone
	aws s3api --endpoint http://localhost:9878/ create-bucket --bucket=bucket1

# Cria arquivo de teste 
testfile: ## Cria arquivo de teste
	ls -1 > /tmp/testfile

# Upload do arquivo ao S3 bucket do Ozone
upload: ## Upload do arquivo ao S3 bucket do Ozone
	aws s3 --endpoint http://localhost:9878 cp --storage-class REDUCED_REDUNDANCY  /tmp/testfile  s3://bucket1/testfile
	
# Lista arquivos e verifica o upload do arquivo de teste
listfiles: ## Lista arquivos e verifica o upload
	aws s3 --endpoint http://localhost:9878 ls s3://bucket1/testfile

# S3 gateway
urls3: ## S3 gateway
	echo "http://localhost:9878"

# Ozone Manager (OM) 
urlom: ## Ozone Manager (OM) 
	echo "http://localhost:9874"

# Storage Container Management (SCM) 
urlscm: ## Storage Container Management (SCM)  
	echo "http://localhost:9876"

# Management / Monitoring (Recon)  
urlrecon: ## Management / Monitoring (Recon)  
	echo "http://localhost:9888"




