##### KSQL - KCONNECT - MSSQL - ORACLE - PROPHET - FASTAPI

# Real Time (series) forecasting with KAFKA and Prophet.

---

This Docker Compose can be used to spin up an environment.

## Getting a CLI session

- KSQL

```bash
docker exec --tty --interactive ksql-cli ksql http://ksql-server:8088
```

- MySQL

```bash
docker exec --tty --interactive mysql bash -c 'mysql -u root -p$MYSQL_ROOT_PASSWORD'
```

- Postgres

```bash
docker exec --tty --interactive postgres bash -c 'psql -U $POSTGRES_USER $POSTGRES_DB'
```

- Oracle

```bash
docker exec --tty --interactive oracle bash -c 'sqlplus sys/$ORACLE_PWD@localhost:1521/ORCLCDB as sysdba'
```

- MS SQL Server

```bash
docker exec --tty --interactive mssql bash -c '/opt/mssql-tools/bin/sqlcmd -l 30 -S localhost -U sa -P $SA_PASSWORD'
```

## Example Connector Configuration

- MySQL

```bash
curl -X POST http://localhost:8083/connectors -H "Content-Type: application/json" -d '{
        "name": "jdbc_source_mysql_01",
        "config": {
                "connector.class": "io.confluent.connect.jdbc.JdbcSourceConnector",
                "connection.url": "jdbc:mysql://mysql:3306/demo",
                "connection.user": "connect_user",
                "connection.password": "asgard",
                "topic.prefix": "mysql-01-",
                "mode":"bulk",
                "poll.interval.ms" : 3600000
                }
        }'
```

- Postgres

```bash
curl -X POST http://localhost:8083/connectors -H "Content-Type: application/json" -d '{
        "name": "jdbc_source_postgres_01",
        "config": {
                "connector.class": "io.confluent.connect.jdbc.JdbcSourceConnector",
                  "connection.url": "jdbc:postgresql://postgres:5432/postgres",
                "connection.user": "connect_user",
                "connection.password": "asgard",
                "topic.prefix": "postgres-01-",
                "mode":"bulk",
                "poll.interval.ms" : 3600000
                }
        }'
```

- Oracle

```bash
curl -X POST http://localhost:8083/connectors -H "Content-Type: application/json" -d '{
                "name": "jdbc_source_oracle_01",
                "config": {
                        "connector.class": "io.confluent.connect.jdbc.JdbcSourceConnector",
                        "connection.url": "jdbc:oracle:thin:@oracle:1521/ORCLPDB1",
                        "connection.user": "connect_user",
                        "connection.password": "asgard",
                        "topic.prefix": "oracle-01-",
                        "table.whitelist" : "NUM_TEST",
                        "mode":"bulk",
                        "poll.interval.ms" : 3600000
                        }
                }'
```

- MS SQL Server

```bash
curl -X POST http://localhost:8083/connectors -H "Content-Type: application/json" -d '{
                "name": "jdbc_source_mssql_01",
                "config": {
                        "connector.class": "io.confluent.connect.jdbc.JdbcSourceConnector",
                        "connection.url": "jdbc:sqlserver://mssql:1433;databaseName=demo",
                        "connection.user": "connect_user",
                        "connection.password": "Asgard123",
                        "topic.prefix": "mssql-01-",
                        "table.whitelist" : "demo..num_test",
                        "mode":"bulk",
                        "poll.interval.ms" : 3600000
                        }
                }'
```

## 4.5 **All Supported JDBC**

IBM DB2 driver `jdbc:db2://<host>:<port50000>/<database>`
IBM Informix `jdbc:informix-sqli://:/:informixserver=<debservername>`
MS SQL driver `jdbc:sqlserver://<host>[:<port1433>];databaseName=<database>`
MySQL driver `jdbc:mysql://<host>:<port3306>/<database>`
Oracle driver `jdbc:oracle:thin://<host>:<port>/<service> or jdbc:oracle:thin:<host>:<port>:<SID>`
Postgres included with Kafka Connect `jdbc:postgresql://<host>:<port5432>/<database>`
Amazon Redshift driver `jdbc:redshift://<server>:<port5439>/<database>`
Snowflake driver `jdbc:snowflake://<account_name>.snowflakecomputing.com/?<connection_params>`


> Other possible configurations

===============================================
|
|Confluent Platform | 5.4.0
|MySQL | 8.0.13
|Postgres | 11.1
|MS SQL Server | 2017 (RTM-CU13) (KB4466404) - 14.0.3048.4 (X64)
|Oracle | 12.2.0.1.0
|===============================================

[Reference](https://www.confluent.io/blog/kafka-connect-deep-dive-jdbc-source-connector)
