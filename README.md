# Description
Functional:
- When creating a task - the urls field is passed to it, in which links are indicated
to files. These can be any links on any site, the only
condition - these must be links to files. After creating a task
these files are combined into an archive and this archive is uploaded to AWS S3. TO
for example: 3 links were passed in the urls field - https://site.com/logo1.png,
https://site.com/logo2.png, https://site.com/logo3.png. They should be
combined into one archive and this archive must be uploaded to S3. Sami
files on S3 do not need to be uploaded, only archive.
- After starting the formation of the archive, the status field of the task changes to
processing, in case of an error - changes to failed, after completion - to finished
- As the archive is being formed, the progress field changes, in which the
indicate the number of percent for which the archive is formed
- When changing any of the task fields - information about this is sent by
websockets
- After the completion of the formation of the archive, a link is sent via websockets
to the generated archive
# How to start

You must add to .env  
AWS_ACCESS_KEY_ID  
AWS_SECRET_ACCESS_KEY
S3_BUCKET

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
curl -H 'Content-Type: application/json' -X POST  -d '{"tasks": [{"task_id": 1, "name": "buy greenery4211", "urls": ["https://archicgi.com/wp-content/uploads/2019/12/archicgi-logotype-black.png"]}, {"task_id": 2, "name": "buy greenery 4242123123", "urls": ["https://archicgi.com/wp-content/uploads/2019/12/archicgi-logotype-black.png", "https://tinyjpg.com/images/social/website.jpg"]}]}' http://localhost:3000/tasks/batch_update
```
