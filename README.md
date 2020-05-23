# README

# How to start

You must add to .env  
AWS_ACCESS_KEY_ID  
AWS_SECRET_ACCESS_KEY

Start these commands

`bundle install`  
`rails db:create`  
`rails db:migrate`  
`rails s`  
`bundle exec sidekiq`  
`ruby em.ru`

## Dependence  
Ruby 2.6.3  
Redis  
Postgres


## For example endpoint

### Check all projects
```shell script
CURL -X GET localhost:3000/projects
```

### Create project
```shell script
curl -H 'Content-Type: application/json' -X POST -d '{"project": {"name": "yo-yo", "description": "so yo", "price": 500 }}' http://localhost:3000/projects
```

### Check all tasks
```shell script
CURL -X GET localhost:3000/tasks
```

### Batch create task
```shell script
curl -H 'Content-Type: application/json' -X POST  -d '{"tasks": [{"name": "buy greenery4211", "urls": ["https://archicgi.com/wp-content/uploads/2019/12/archicgi-logotype-black.png"], "project_id": 2}, {"name": "buy greenery 4242123123", "urls": ["https://archicgi.com/wp-content/uploads/2019/12/archicgi-logotype-black.png", "https://speed.hetzner.de/1GB.bin"], "project_id": 1}]}' http://localhost:3000/tasks/batch_create
```

### Task batch update
```shell script
curl -H 'Content-Type: application/json' -X POST  -d '{"tasks": [{""name": "buy greenery4211", "urls": ["https://archicgi.com/wp-content/uploads/2019/12/archicgi-logotype-black.png"], "project_id": 2}, {"name": "buy greenery 4242123123", "urls": ["https://archicgi.com/wp-content/uploads/2019/12/archicgi-logotype-black.png", "https://speed.hetzner.de/1GB.bin"], "project_id": 1}]}' http://localhost:3000/tasks/batch_update
```
