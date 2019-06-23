pull:
	docker pull phpmyadmin/phpmyadmin

volumes-create:
	docker volume create raport-mysql-data

volumes-remove:
	docker volume rm raport-mysql-data

build:
	
	docker build --file=app/docker/php-apache.docker --tag=raport-php-apache app/docker
	docker build --file=app/docker/php-cli.docker --tag=raport-php-cli app/docker
	docker build --file=app/docker/mysql.docker --tag=raport-mysql app/docker


run:
	docker network create app
	docker run -d --name raport-php-apache -v ${PWD}/app:/var/www/app -p 8000:80 --network=app raport-php-apache
	docker run -d --name raport-mysql -v ${PWD}/app:/app -v raport-mysql-data:/var/lib/mysql -p 33060:3306 --network=app raport-mysql
	docker run -d --name myadmin --link raport-mysql -p 8085:80 --network=app -e MYSQL_ROOT_PASSWORD=12345 -e PMA_HOST=raport-mysql -e PMA_PORT=3306 phpmyadmin/phpmyadmin


cli:
	docker run --rm -v ${PWD}/app:/var/www/app raport-php-cli



down:
	docker stop raport-php-apache
	docker stop raport-mysql
	docker rm raport-php-apache
	docker rm raport-mysql
	docker stop myadmin
	docker rm myadmin
	docker network remove app
	