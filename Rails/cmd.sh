#!/bin/bash

if [[ $1 == "get" ]]; then
  # ++
  # set another If-None-Match to get update
  # ++
  curl -X GET \
    -H "Content-Type: application/json" \
    -H "If-None-Match:b7997faaf29fa5fd79c13e31ebb24967" \
    -H "UUID:EB1BEA58-233B-4DA8-A26A-22D548A70650" \
    -H "Token:b0e69ff1fbc76cf60424dbff313f00d1"\
    -H "Authorization: Token token=fake" \
    --data '{"uuid":"EB1BEA58-233B-4DA8-A26A-22D548A70650" ,"token": "b0e69ff1fbc76cf60424dbff313f00d1"}' -v \
    127.0.0.1:3000/api/v1/news
  exit 0
elif [[ $1 == "post" ]]; then
  curl -X POST \
    -h "Content-Type: application/json" \
    -h "Authorization: Token token=fake" \
    --data '{"uuid":"eb1bea58-233b-4da8-a26a-22d548a70650"}' -v \
    127.0.0.1:3000/api/v1/request_access_token
  exit 0
elif [[ $1 == "post_remote" ]]; then
  curl -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: Token token=fake" \
    --data '{"uuid":"eb1bea58-233b-4da8-a26a-22d548a70650"}' -v \
    api.minghe.me/api/v1/request_access_token
  exit 1
fi 
