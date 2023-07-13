#!/bin/bash
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

create_user() {
  if [[ -z "$USERNAME" ]]; then
    echo "USERNAME environment variable not set, skipping user creation"
    return
  fi

  # Wait for Pulsar Manager to become available
  while ! curl -s http://localhost:7750/pulsar-manager/ > /dev/null; do
    echo "Waiting for Pulsar Manager to become available..."
    sleep 5
  done

  # Get CSRF token
  local csrf_token=$(curl -s http://localhost:7750/pulsar-manager/csrf-token)

  # Create user
  curl \
    -H "X-XSRF-TOKEN: $csrf_token" \
    -H "Cookie: XSRF-TOKEN=$csrf_token;" \
    -H 'Content-Type: application/json' \
    -X PUT http://localhost:7750/pulsar-manager/users/superuser \
    -d "{\"name\": \"$USERNAME\", \"password\": \"$PASSWORD\", \"description\": \"foundation admin user\", \"email\": \"username@test.org\"}"
}

create_user
