build:
	docker build --build-arg CONT_IMG_VER=1.0.0 -t aurelbruno06/hadoop_base .
export:
	docker push aurelbruno06/hadoop_base
	docker push aurelbruno06/consul_base
	docker push aurelbruno06/hadoop_consul_server
	docker push aurelbruno06/hadoop_master
	docker push aurelbruno06/hadoop_worker
	docker push aurelbruno06/hadoop_job

