PMA_VERSION = 5.1.1
PMA_URL = https://files.phpmyadmin.net/phpMyAdmin/${PMA_VERSION}/phpMyAdmin-${PMA_VERSION}-english.tar.xz

PMA_DIST_DIR = build/dist
PMA_TINY_DIR = build/pma

.PHONY: build
build: # Get phpMyAdmin, shrink the application and build the docker image
	@$(MAKE) get
	@./build/build.sh ${PMA_DIST_DIR} ${PMA_TINY_DIR} ${PMA_VERSION}

get: # Download and extract the phpMyAdmin official package
ifeq (,$(wildcard build/dist))	
	@echo [info] downloading phpMyAdmin ${PMA_VERSION}
	@mkdir -p ${PMA_DIST_DIR}
	@wget ${PMA_URL} -O pma.tar.xz
	@tar -xf pma.tar.xz -C ${PMA_DIST_DIR} --strip-components=1
	@rm pma.tar.xz
else
	@echo [info] using ${PMA_DIST_DIR} folder
endif

push: # Push images to Docker Hub
	@docker push --all-tags noctuary/phpmyadmin

clean: # Remove build folders
	@echo [info] removing build folders
	@rm -rf ${PMA_DIST_DIR} ${PMA_TINY_DIR}
