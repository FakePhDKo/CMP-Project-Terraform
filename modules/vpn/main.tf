resource "aws_customer_gateway" "onprem" {
    bgp_asn = 65000
    ip_address = var.onprem_public_ip
    type = "ipsec.1"
}

resource "aws_vpn_gateway" "vpn_gw" {
    vpc_id = var.vpc_id
}

resource "aws_vpn_connection" "main" {
    vpn_gateway_id = aws_vpn_gateway.vpn_gw.id
    customer_gateway_id = aws_customer_gateway.onprem.id
    type = "ipsec.1"
    static_routes_only = true
}

resource "aws_vpn_connection_route" "onprem_route" {
    destination_cidr_block = "172.16.6.0/24"
    vpn_connection_id  = aws_vpn_connection.main.id
}