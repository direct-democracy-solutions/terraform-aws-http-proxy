resource "aws_lb" "target" {
  name = "test-lb"
  internal = true
  load_balancer_type = "application"
  subnets = [ for s in aws_subnet.subnet : s.id ]
  security_groups = [ aws_security_group.target.id ]
}

resource "aws_lb_listener" "hello" {
  load_balancer_arn = aws_lb.target.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Hello, World!"
      status_code = "200"
    }
  }
}

resource "aws_security_group" "target" {
  name = "test-load-balancer"
  vpc_id = aws_default_vpc.vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "ingress_to_target" {
  security_group_id = aws_security_group.target.id
  ip_protocol = "tcp"
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 80
  to_port = 80
}
