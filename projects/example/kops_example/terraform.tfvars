region 			= "us-east-1"

port_allow = "80,81,443,4443,9999"


peering_vpc_cidrs = "10.0.0.0/16,10.100.0.0/16"
peering_vpc_info = "pcx-cf26dfa7,pcx-4123da29"

lb_ingress_name 	= "prd-k8s"
ingress_external_l7_target_port = "81"
ingress_external_l7_ssl_cert = "arn:aws:acm:us-east-1:819895241319:certificate/762094ca-8788-4ca9-a789-978a8e5fb320"
ingress_external_l7_healthcheck_port = "81"
ingress_external_l7_healthcheck_path = ""

ingress_internal_tcp_listen_port = "80,443"
ingress_internal_tcp_target_port = "81,4443"
ingress_internal_tcp_healthcheck_port = "9999,9999"

ingress_external_tcp_listen_port = "80,443"
ingress_external_tcp_target_port = "81,4443"
ingress_external_tcp_healthcheck_port = "9999,9999"