
.PHONY: update

bootstrap: init 

init:
	bash ./hack/lomtik-init $(type) # Запуск скрипта для инициализации kind с flux


delete:
	bash ./hack/lomtik-delete # Удаление всех ресурсов на хостовой машине management
