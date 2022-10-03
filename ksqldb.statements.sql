-- Source connector datagen topic:ratings
CREATE SOURCE CONNECTOR DATAGEN_RATINGS_00 WITH (
    'connector.class' = 'io.confluent.kafka.connect.datagen.DatagenConnector',
    'key.converter' = 'org.apache.kafka.connect.storage.StringConverter',
    'kafka.topic' = 'ratings',
    'max.interval' = 50,
    'quickstart' = 'ratings',
    'tasks.max' = 1
);
-- Source connector datagen custom avsc schema
CREATE SOURCE CONNECTOR DATAGEN_SALES_RAW_00 WITH (
    'connector.class' = 'io.confluent.kafka.connect.datagen.DatagenConnector',
    'key.converter' = 'org.apache.kafka.connect.storage.StringConverter',
    'kafka.topic' = 'sales_data_raw',
    'max.interval' = 1,
    'iterations' = 1000,
    'schema.filename' = '/data/schema/sales_records.avsc',
    'schema.keyfield' = 'id',
    'topic.creation.default.replication.factor' = 1,
    'topic.creation.default.partitions' = 6,
    'tasks.max' = '1'
);
-- Source Connector Debezium CDC Sql databases
CREATE SOURCE CONNECTOR SOURCE_CDC_FRM_SQL_01 WITH (
    'connector.class' = 'io.debezium.connector.mysql.MySqlConnector',
    'database.hostname' = 'mysql',
    'database.port' = '3306',
    'database.user' = 'debezium',
    'database.password' = 'dbz',
    'database.server.id' = '42',
    'database.server.name' = 'sales_database',
    'table.whitelist' = 'public.sales_data_raw',
    'database.history.kafka.bootstrap.servers' = 'kafka:29092',
    'database.history.kafka.topic' = 'dbhistory.demo',
    'key.converter' = 'org.apache.kafka.connect.storage.StringConverter',
    'value.converter' = 'io.confluent.connect.avro.AvroConverter',
    'value.converter.schema.registry.url' = 'http://schema-registry:8081'
);
-- incremental options Source Connector Debezium CDC Sql databases.
(
    'include.schema.changes' = 'false',
    'transforms' = 'unwrap,extractkey',
    'transforms.unwrap.type' = 'io.debezium.transforms.ExtractNewRecordState',
    'transforms.extractkey.type' = 'org.apache.kafka.connect.transforms.ExtractField$Key',
    'transforms.extractkey.field' = 'id',
);
-- Source Connector JDBC SQL
CREATE SOURCE CONNECTOR SOURCE_DATA_FROM_MYSQL WITH (
    'connector.class' = 'io.confluent.connect.jdbc.JdbcSourceConnector',
    'connection.url' = 'jdbc:mysql://mysql:3306/demo',
    'connection.user' = 'mysql_user',
    'connection.password' = 'Passw@rd',
    'topic.prefix' = 'mysql-01-',
    'mode' = 'bulk',
    'poll.interval.ms' = 3600000
);
-- Source Connector JDBC SQLSERVER
CREATE SOURCE CONNECTOR SOURCE_DATA_FROM_MSSQL WITH (
    'connector.class' = 'io.confluent.connect.jdbc.JdbcSourceConnector',
    'connection.url' = 'jdbc:sqlserver://mssql:1433;databaseName=demo',
    'connection.user' = 'mysql_user',
    'connection.password' = 'Passw@rd',
    'topic.prefix' = 'mysql-01-',
    'mode' = 'bulk',
    'poll.interval.ms' = 3600000
);
-- Source Connector JDBC Oracle DB
CREATE SOURCE CONNECTOR SOURCE_DATA_FROM_ORACLE WITH (
    'connector.class' = 'io.confluent.connect.jdbc.JdbcSourceConnector',
    'connection.url' = 'jdbc:oracle:thin:@oracle:1521/ORCLPDB1',
    'connection.user' = 'oracle_user',
    'connection.password' = 'Passw@rd',
    'topic.prefix' = 'oracle-01-',
    'mode' = 'bulk',
    'poll.interval.ms' = 3600000
);
-- Source Connector JDBC Postgres
CREATE SOURCE CONNECTOR SOURCE_DATA_FROM_PG WITH (
    'connector.class' = 'io.confluent.connect.jdbc.JdbcSourceConnector',
    'connection.url' = 'jdbc:postgresql://postgres:5432/postgres',
    'connection.user' = 'postgres',
    'connection.password' = 'postgres',
    'topic.prefix' = 'pg-01-',
    'mode' = 'bulk',
    'poll.interval.ms' = 3600000
);
-- Sink Connector Elastic
CREATE SINK CONNECTOR SINK_DATA_TO_ELASTIC_01 WITH (
    'connector.class' = 'io.confluent.connect.elasticsearch.ElasticsearchSinkConnector',
    'connection.url' = 'http://elasticsearch:9200',
    'type.name' = '',
    'behavior.on.malformed.documents' = 'warn',
    'errors.tolerance' = 'all',
    'errors.log.enable' = 'true',
    'errors.log.include.messages' = 'true',
    'topics' = 'ratings-enriched,UNHAPPY_PLATINUM_CUSTOMERS',
    'key.ignore' = 'true',
    'schema.ignore' = 'true',
    'key.converter' = 'org.apache.kafka.connect.storage.StringConverter',
    'transforms' = 'ExtractTimestamp',
    'transforms.ExtractTimestamp.type' = 'org.apache.kafka.connect.transforms.InsertField$Value',
    'transforms.ExtractTimestamp.timestamp.field' = 'EXTRACT_TS'
);
-- Sink connector JDBC Postgres
CREATE SINK CONNECTOR SINK_DATA_TO_PG_01 WITH (
    'connector.class' = 'io.confluent.connect.jdbc.JdbcSinkConnector',
    'connection.url' = 'jdbc:postgresql://postgres:5432/',
    'connection.user' = 'postgres',
    'connection.password' = 'postgres',
    'topics' = 'TXNS_ENRICHED',
    'auto.create' = 'true',
    'auto.evolve' = 'true',
    'tasks.max' = 1
);
-- Sink connector JDBC MySQL
CREATE SINK CONNECTOR SINK_DATA_TO_MYSQL_01 WITH (
    'connector.class' = 'io.confluent.connect.jdbc.JdbcSinkConnector',
    'connection.url' = 'jdbc:mysql://<mysqlserverNameFQDN>:3306/<databaseName>',
    'connection.user' = '<userName>@<mysqlserverName>',
    'connection.password' = 'Passw@rd',
    'topics' = 'TXNS_ENRICHED',
    'auto.create' = 'true',
    'auto.evolve' = 'true',
    'tasks.max' = 1
);
-- Sink connector JDBC MSSQL Server
CREATE SINK CONNECTOR SINK_DATA_TO_MSSQL_01 WITH (
    'connector.class' = 'io.confluent.connect.jdbc.JdbcSinkConnector',
    'connection.url' = 'jdbc:sqlserver://mssql:1433;databaseName=demo',
    'connection.user' = '<userName>@<mysqlserverName>',
    'connection.password' = 'Passw@rd',
    'topics' = 'TXNS_ENRICHED',
    'auto.create' = 'true',
    'auto.evolve' = 'true',
    'tasks.max' = 1
);