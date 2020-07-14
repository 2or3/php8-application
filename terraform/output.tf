output "public_subnet1" {
  value = aws_subnet.collarks_public["ap-northeast-1a"].id
}

output "public_subnet2" {
  value = aws_subnet.collarks_public["ap-northeast-1c"].id
}

output "service_sg" {
  value = aws_security_group.collarks_service.id
}

output "blue_tg_arn" {
  value = aws_lb_target_group.collarks_blue.arn
}

output "green_tg_arn" {
  value = aws_lb_target_group.collarks_green.arn
}

