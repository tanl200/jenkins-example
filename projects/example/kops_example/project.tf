variable "vpc_id" { }
variable "region" { default = "us-east-1"}

variable "public_subnets" { }
variable "private_subnets" { }
variable "public_zones" { }
variable "private_zones" { }

variable "port_allow" { }

variable "peering_vpc_cidrs" { }
variable "peering_vpc_info" { }

variable "lb_ingress_name" { }
variable "ingress_internal_tcp_healthcheck_port" { }
variable "ingress_internal_tcp_listen_port" { }
variable "ingress_internal_tcp_target_port" { }

variable "ingress_external_tcp_healthcheck_port" { }
variable "ingress_external_tcp_target_port" { }
variable "ingress_external_tcp_listen_port" { }

variable "ingress_external_l7_healthcheck_port" { }
variable "ingress_external_l7_healthcheck_path" { }
variable "ingress_external_l7_target_port" { }
variable "ingress_external_l7_ssl_cert" { }

variable "cluster_name" { }

variable "asg_ingress_name" {
  type = "map"
}

variable "worker_sg_name" { }

provider "aws" {
  region = "${var.region}"
}

data "aws_subnet_ids" "private_subnet" {
  vpc_id = "${var.vpc_id}"
  tags {
    KubernetesCluster = "${var.cluster_name}"
    SubnetType = "Private"
  }
}

data "aws_subnet_ids" "public_subnet" {
  vpc_id = "${var.vpc_id}"
  tags {
    KubernetesCluster = "${var.cluster_name}"
    SubnetType = "Utility"
  }
}

data "aws_subnet_ids" "all_subnets" {
  vpc_id = "${var.vpc_id}"
  tags {
    KubernetesCluster = "${var.cluster_name}"
  }
}

module "ingress_external_l7"  {
	source = "../../../module/aws/lb/alb"

	name 	= "${var.lb_ingress_name}-ext-l7"
	vpc_id = "${var.vpc_id}"
	subnets = "${join(",", data.aws_subnet_ids.public_subnet.ids)}" 
	target_port	= "${var.ingress_external_l7_target_port}"
	ssl_cert = "${var.ingress_external_l7_ssl_cert}"
	healthcheck_port = "${var.ingress_external_l7_healthcheck_port}"
	healthcheck_path = "${var.ingress_external_l7_healthcheck_path}"
  asg_name = "${var.asg_ingress_name["ingress_external_l7"]}"
}

module "ingress_external_tcp"  {
	source = "../../../module/aws/lb/nlb"

	name 	= "${var.lb_ingress_name}-ext-tcp"
	vpc_id = "${var.vpc_id}"
	subnets = "${join(",", data.aws_subnet_ids.public_subnet.ids)}" 
	target_port = "${var.ingress_external_tcp_target_port}"
	listen_port	= "${var.ingress_external_tcp_listen_port}"
  asg_name = "${var.asg_ingress_name["ingress_external_tcp"]}"
	healthcheck_port = "${var.ingress_external_tcp_healthcheck_port}"
}

module "ingress_internal_tcp"  {
	source = "../../../module/aws/lb/nlb"

	name 	= "${var.lb_ingress_name}-int-tcp"
	vpc_id = "${var.vpc_id}"
	subnets = "${join(",", data.aws_subnet_ids.public_subnet.ids)}"  # "${data.aws_subnet_ids.public_subnet.ids}"
	target_port = "${var.ingress_internal_tcp_target_port}"
	listen_port	= "${var.ingress_internal_tcp_listen_port}"
	healthcheck_port = "${var.ingress_internal_tcp_healthcheck_port}"
  asg_name = "${var.asg_ingress_name["ingress_internal_tcp"]}"
	internal_lb = "true"
}

data "aws_security_group" "worker_sg" {
  vpc_id = "${var.vpc_id}"
  tags {
    KubernetesCluster = "${var.cluster_name}"
    Name              = "${var.worker_sg_name}"
  }
}

resource "aws_security_group_rule" "ingress_access_node" {
  count                    = "${length(split(",", var.port_allow))}"
  type                     = "ingress"
  security_group_id        = "${data.aws_security_group.worker_sg.id}"
  cidr_blocks              = ["0.0.0.0/0"]
  from_port                = "${element(split(",", var.port_allow), count.index)}"
  to_port                  = "${element(split(",", var.port_allow), count.index)}"
  protocol                 = "tcp"
  lifecycle { create_before_destroy = true }
}

data "aws_route_table" "all_subnets" {
  count 	= "${length(data.aws_subnet_ids.all_subnets.ids)}"
  subnet_id = "${element(data.aws_subnet_ids.all_subnets.ids, count.index)}"
}

resource "aws_route" "route_subnet_to_peer_1" {
  count 				 = "${length(distinct(data.aws_route_table.all_subnets.*.id))}"
  route_table_id         = "${element(distinct(data.aws_route_table.all_subnets.*.id), count.index)}"
  destination_cidr_block = "${element(split(",", var.peering_vpc_cidrs), 0)}"
  vpc_peering_connection_id             = "${element(split(",", var.peering_vpc_info), 0)}"
}

resource "aws_route" "route_subnet_to_peer_2" {
  count 				 = "${length(distinct(data.aws_route_table.all_subnets.*.id))}"
  route_table_id         = "${element(distinct(data.aws_route_table.all_subnets.*.id), count.index)}"
  destination_cidr_block = "${element(split(",", var.peering_vpc_cidrs), 1)}"
  vpc_peering_connection_id             = "${element(split(",", var.peering_vpc_info), 1)}"
}

output "PUBLIC_SUBNET" {
	value = "${data.aws_subnet_ids.public_subnet.ids}"
}

output "PRIVATE_SUBNET" {
	value = "${data.aws_subnet_ids.private_subnet.ids}"
}

#output "PUBLIC_ROUTE_TABLE_ID" {
#	value = "${data.aws_route_table.public.*.id}"
#}
