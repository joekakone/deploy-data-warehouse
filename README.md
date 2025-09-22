# Setup Data Warehouse

## Launch containers
```sh
bash deploy
```

## Check containers
```sh
docker ps
```
```txt
CONTAINER ID   IMAGE                                   COMMAND                  CREATED         STATUS                   PORTS                                                                                      NAMES
4c60a5b35d8a   mongo-express:latest                    "/sbin/tini -- /dock…"   2 minutes ago   Up 2 minutes             0.0.0.0:8081->8081/tcp, [::]:8081->8081/tcp                                                analytics-mongo-express-1
a9a9b4da6d9d   postgres:latest                         "docker-entrypoint.s…"   2 minutes ago   Up 2 minutes             0.0.0.0:5432->5432/tcp, [::]:5432->5432/tcp                                                analytics-postgres-1
caff70728cd4   mongo:latest                            "docker-entrypoint.s…"   2 minutes ago   Up 2 minutes (healthy)   0.0.0.0:27017->27017/tcp, [::]:27017->27017/tcp                                            analytics-mongo-1
011aa032130f   mcr.microsoft.com/mssql/server:latest   "/opt/mssql/bin/laun…"   2 minutes ago   Up 2 minutes             0.0.0.0:1433->1433/tcp, [::]:1433->1433/tcp                                                analytics-mssql-1
83cd38af061c   neo4j:latest                            "tini -g -- /startup…"   2 minutes ago   Up 2 minutes             0.0.0.0:7474->7474/tcp, [::]:7474->7474/tcp, 0.0.0.0:7687->7687/tcp, [::]:7687->7687/tcp   analytics-neo4j-1
```


## References
1. Postgres: https://hub.docker.com/_/postgres
2. SQL Server: https://hub.docker.com/_/microsoft-mssql-server
3. MongoDB: https://hub.docker.com/_/mongo
4. Mongo Express: https://hub.docker.com/r/mongoexpress/mongo-express
5. Neo4j: https://hub.docker.com/_/neo4j
6. Elasticsearch + Kibana: https://www.elastic.co/guide/en/elasticsearch/reference/
