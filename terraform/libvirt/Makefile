all: private_ansible_cloud_init.pub
	terraform apply

private_ansible_cloud_init.pub:
	ssh-keygen -q -b 4096 -t rsa -N '' -f private_ansible_cloud_init

base:
	sudo ./virt-cloud-builder.sh

clean:
	- terraform destroy -auto-approve
	- virsh destroy cloudstack_vm
	- virsh undefine cloudstack_vm
	- virsh vol-delete cloudstack_commoninit.iso
	- sleep 5 && sudo rm /var/lib/libvirt/images/cloudstack_commoninit.iso
