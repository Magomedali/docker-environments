pull:
	docker pull phpmyadmin/phpmyadmin

volumes-create:
	docker volume create env-composer
	docker volume create env-mysql-data


volumes-remove:
	docker volume rm env-composer
	docker volume rm env-mysql-data



volume-clear: volumes-remove volumes-create



build:
	docker build --file=app/docker/php-apache.docker --tag=env-php-apache app/docker
	docker build --file=app/docker/php-cli.docker --tag=env-php-cli app/docker
	docker build --file=app/docker/mysql.docker --tag=env-mysql app/docker


cli:
	docker run --rm -v ${PWD}/app:/var/www/app -v env-composer:/root/.composer/cache env-php-cli


cli-bash:
	docker run -it -v ${PWD}/app:/var/www/app -v env-composer:/root/.composer/cache --network=net-env env-php-cli



run:
	docker network create net-env
	docker run -d --name env-php-apache -v ${PWD}/app:/var/www/app -p 8000:80 --network=net-env env-php-apache
	docker run -d --name env-mysql -v ${PWD}/app:/app -v env-mysql-data:/var/lib/mysql -e MYSQL_DATABASE=app --env-file=app/docker/mysql/.env -p 33061:3306 --network=net-env env-mysql
	docker run -d --name env-myadmin --link env-mysql -p 8005:80 --network=net-env --env-file=app/docker/phpmyadmin/.env phpmyadmin/phpmyadmin



stop:
	docker stop env-php-apache
	docker stop env-mysql
	docker stop env-myadmin

remove:
	docker rm env-php-apache
	docker rm env-mysql
	docker rm env-myadmin
	docker network remove net-env


down: stop remove

rebuild: down build

init: pull volumes-create build run

reinit: down init