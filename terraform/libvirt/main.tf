# Configure the Libvirt provider

terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.7.1"
    }
  }
}

# https://registry.terraform.io/providers/dmacvicar/libvirt/latest

# See: https://registry.terraform.io/providers/multani/libvirt/latest/docs

provider "libvirt" {
  #uri = "qemu+ssh://cadm@192.168.1.108/system"
   uri = "qemu:///system"
}


# https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/cloudinit
# https://github.com/dmacvicar/terraform-provider-libvirt/blob/main/examples/v0.12/ubuntu/ubuntu-example.tf
# https://grantorchard.com/dynamic-cloudinit-content-with-terraform-file-templates/
data "template_file" "user_data" {
  template = file("./cloud-init-actions.yaml")

  # left hand var names are the var names used in the cloud-init yaml.
  vars = {
    ansible_ssh_public_key       = file(var.ansible_ssh_public_key_filename)
    ansible_playbook_file_base64 = filebase64("../../ansible_playbook/cloudstack_mgr_playbook.yaml")
    clodstack_cnf_file_base64 = filebase64("../../ansible_playbook/files/cloudstack.cnf.j2")
    vm_hostname = "tfcloudstack"
  }
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name      = "cloudstack_commoninit.iso"
  user_data = data.template_file.user_data.rendered
}

# Defining VM Volume
resource "libvirt_volume" "os-qcow2" {
  name   = "tf_cloudstack.qcow2"
  pool   = "default" # List storage pools using virsh pool-list
  # TODO is seems the kvm image wont boot
  #source = "/var/ubuntu_jammy_cloudimg_kvm.qcow2"
  source = "/var/ubuntu_jammy_cloudimg.qcow2"
  format = "qcow2"
}

# Define KVM domain to create
resource "libvirt_domain" "cloudstack-vm" {
  name   = "cloudstack_mgr_vm"
  memory = "4096"
  vcpu   = 2

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {
    network_name   = "default" # List networks with virsh net-list
    bridge         = "virbr0"
    wait_for_lease = true
  }

  disk {
    volume_id = libvirt_volume.os-qcow2.id
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

# ----------------------------------- A G E N T

data "template_file" "agent_user_data" {
  template = file("./agent_cloud-init-actions.yaml")

  # left hand var names are the var names used in the cloud-init yaml.
  vars = {
    ansible_ssh_public_key       = file(var.ansible_ssh_public_key_filename)
    ansible_playbook_file_base64 = filebase64("../../ansible_playbook/cloudstack_agent_playbook.yaml")
    vm_hostname = "tfagent"
  }
}

resource "libvirt_cloudinit_disk" "agent_commoninit" {
  name      = "cloudstack_agent_commoninit.iso"
  user_data = data.template_file.agent_user_data.rendered
}

# Defining VM Volume
resource "libvirt_volume" "agent-qcow2" {
  name   = "tf_cloudstack_agent.qcow2"
  pool   = "default" # List storage pools using virsh pool-list
  # TODO is seems the kvm image wont boot
  #source = "/var/ubuntu_jammy_cloudimg_kvm.qcow2"
  source = "/var/ubuntu_jammy_cloudimg.qcow2"
  format = "qcow2"
}

# Define KVM domain to create
resource "libvirt_domain" "kvm-agent-vm" {
  name   = "cloudstack_agent_vm"
  memory = "4096"
  vcpu   = 2

  cloudinit = libvirt_cloudinit_disk.agent_commoninit.id

  network_interface {
    network_name   = "default" # List networks with virsh net-list
    bridge         = "virbr0"
    wait_for_lease = true
  }

  disk {
    volume_id = libvirt_volume.agent-qcow2.id
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

# Output Server IP
#output "ip" {
#  value = libvirt_domain.cloudstack-vm.network_interface.*.addresses.0
#}
