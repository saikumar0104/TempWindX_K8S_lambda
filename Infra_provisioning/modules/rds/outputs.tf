output "address" {
  description = "RDS endpoint address"
  value       = aws_db_instance.this.address
}

output "port" {
  description = "RDS endpoint port"
  value       = aws_db_instance.this.port
}

output "db_id" {
  description = "RDS instance identifier"
  value       = aws_db_instance.this.id
}
