# PHP SERVER2
## How to use
 ```sh
$ git clone http://github.com/urahara-12/server2.git
```
* change your httpd.conf configs from htdocs to the web directory (server2/web)
 ```sh
$ cd server2
$ ./test.sh
```
## Procfile

## composer.json

## test.sh

## schema.sql

## .htaccess

## web/main.php

---
## GET /courses?search=:string&page=:int

response body for 200 & 404
```json
{
    "rows": "",
    "estimate": "",
    "more": "",
    "page": "",
    "previous": "",
    "next": "",
    "results": [
        {
            "id": "",
            "name": "",
            "description": "",
            "professor": "",
            "department": ""
        }
    ]
}
```
respnose body for 405 & 500
```json
{
    "details": ""
}
```
