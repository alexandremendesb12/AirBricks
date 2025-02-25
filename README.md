# Airflow Databricks DAG Generator

Este repositório visa fornecer uma solução para gerar DAGs (Directed Acyclic Graphs) para o Apache Airflow de forma automática, utilizando parâmetros definidos em um arquivo YAML. O objetivo é permitir que os desenvolvedores criem DAGs para executar notebooks Databricks sem precisar escrever código Airflow manualmente.

## Funcionalidades

* Geração automática de DAGs para o Apache Airflow
* Utilização de parâmetros definidos em um arquivo YAML para configurar a DAG
* Suporte a execução de notebooks Databricks
* Integração com o Databricks para execução de notebooks

## Como Funciona

1. O desenvolvedor cria um arquivo YAML com os parâmetros necessários para a DAG, como:
	* Nome da DAG
	* Intervalo de agendamento
	* Nome do notebook Databricks a ser executado
	* Parâmetros de execução do notebook
2. O processo de geração de DAGs é executado, utilizando os parâmetros do arquivo YAML para criar a DAG.
3. A DAG é criada e salva no repositório do Airflow.
4. O Airflow é configurado para agendar a execução da DAG.
5. A DAG é executada, executando o notebook Databricks com os parâmetros definidos.

## Requisitos

* Python 3.x
* Apache Airflow
* Databricks
* Notebook Databricks

## Instalação

1. Clone o repositório.
2. Instale as dependências necessárias utilizando `pip install -r requirements.txt`.
3. Configure o Apache Airflow e o Databricks de acordo com as instruções fornecidas.

## Uso

1. Crie um arquivo YAML com os parâmetros necessários para a DAG.
2. Execute o processo de geração de DAGs utilizando o comando `make generate-dag`.
3. Verifique se a DAG foi criada corretamente no repositório do Airflow.
4. Configure o Airflow para agendar a execução da DAG.

## Exemplos

* [Exemplo de arquivo YAML](example.yaml)
* [Exemplo de DAG gerada](example_dag.py)

## Contribuições

Contribuições são bem-vindas! Se você tiver alguma ideia para melhorar o repositório, por favor, abra uma issue ou envie um pull request.

## Licença

Este repositório é licenciado sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.
