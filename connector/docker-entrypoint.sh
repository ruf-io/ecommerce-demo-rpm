#!/usr/bin/env bash

# Copyright Materialize, Inc. All rights reserved.
#
# Use of this software is governed by the Business Source License
# included in the LICENSE file at the root of this repository.
#
# As of the Change Date specified in that file, in accordance with
# the Business Source License, use of this software will be governed
# by the Apache License, Version 2.0.

set -euo pipefail

wait-for-it --timeout=60 debezium:8083
wait-for-it --timeout=60 mysql:3306

curl -H 'Content-Type: application/json' debezium:8083/connectors --data '{
  "name": "mysql-connector",
  "config": {
    "connector.class": "io.debezium.connector.mysql.MySqlConnector",
    "database.hostname": "mysql",
    "database.port": "3306",
    "database.user": "root",
    "database.password": "debezium",
    "database.server.name": "mysql",
    "database.server.id": "1234",
    "database.history.kafka.bootstrap.servers": "redpanda:9092",
    "database.history.kafka.topic": "mysql-history",
    "time.precision.mode": "connect"
  }
}'
