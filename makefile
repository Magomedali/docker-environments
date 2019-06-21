build:
	docker build --file=app/docker/apache.docker --tag=raport-apache app/docker
	docker build --file=app/docker/php.docker --tag=raport-php app/docker
	docker build --file=app/docker/php-cli.docker --tag=raport-php-cli app/docker
	docker build --file=app/docker/mysql.docker --tag=raport-mysql app/docker


run:
	docker network create app
	docker run -d --name raport-apache -v ${PWD}/app:/var/www/app -p 8000:80 --network=app raport-apache
	docker run -d --name raport-php -v ${PWD}/app:/var/www/app --network=app raport-php
	docker run -d --name raport-mysql -v ${PWD}/app:/app -p 33060:33060 --network=app raport-mysql


cli:
	docker run --rm -v ${PWD}/app:/var/www/app raport-php-cli



down:
	docker stop raport-apache
	docker stop raport-mysql
	docker stop raport-php
	docker rm raport-apache
	docker rm raport-mysql
	docker rm raport-php
	docker network remove app
