#!/bin/bash

# Função para solicitar a entrada do usuário
prompt() {
    read -p "$1: " input
    echo "$input"
}

# Solicitar informações ao usuário
echo "----------------------------------------------"
echo "----------------------------------------------"
echo "------------starting dag creation-------------"
echo "----------------------------------------------"
echo "----------------------------------------------"

dag_domain=$(prompt "---> domain")
dag_sub_domain=$(prompt "---> sub domain")
dag_name=$(prompt "---> dag name")
schedule_interval=$(prompt "---> schedule interval (cron expression)")
task_name=$(prompt "---> task name")
write_mode=$(prompt "---> write mode(overwrite, append, etc...)")
email_on_failure=$(prompt "---> Email for failure notify(leave blank if none)")
retry=$(prompt "---> Retry if fail? (y/n)")

# Definir variáveis para os e-mails e quantidade de retries, se o usuário optar por retry
retries_quant=""
retry_delay=""
email_on_retry=""
if [ "$retry" == "y" ]; then
    retries_quant=$(prompt "---> Quantity of retries if fail")
    retry_delay=$(prompt "---> Enter retry delay (e.g., 5m, 10m, 1h)")
    email_on_retry=$(prompt "---> Email for retry notifications (leave blank if none)")
fi

# Definir os diretórios de destino
dag_folder="dags/$dag_domain/$dag_sub_domain/$dag_name"
src_folder="src/$dag_domain/$dag_sub_domain/$dag_name"

source_yaml_file="$src_folder/$dag_name.yaml"
source_python_file="$src_folder/$dag_name.py"

mkdir -p "$src_folder"

if [ -f "$dag_folder" ]; then
    echo "YAML file already exists: $yaml_file"
    echo "Skipping creation..."
else
    if [ "$retry" == "y" ]; then
        cat > "$source_yaml_file" <<EOL
dag_name: $dag_name
schedule_interval: $schedule_interval
retry: true
retries: $retries_quant
retry_delay: $retry_delay
email_on_failure: $email_on_failure
email_on_retry: $email_on_retry
EOL
    else
        cat > "$source_yaml_file" <<EOL
domain: "$dag_domain"
sub-domain: "$dag_sub_domain"
name: "$dag_name"
schedule_interval: "$schedule_interval"
retry: false
tasks:
  - id: "$task_name"
    file: "$source_python_file"
    mode: "$write_mode"
EOL
    fi
    echo "YAML configuration file created: $yaml_file"
    echo "Contents:"
    cat "$source_yaml_file"
fi

echo "YAML configuration file created: $source_yaml_file"
echo "Contents:"
cat "$source_yaml_file"
echo ""

cat > "$source_python_file" <<EOL
import pyspark
import mlflow
from datetime import timedelta
import os

EOL

echo "Python DAG file created: $source_python_file"
echo "Contents:"
