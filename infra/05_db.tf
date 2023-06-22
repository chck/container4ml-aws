variable "db" {
  type = map(string)
  default = {
    name = "redis-container4ml"
  }
}

resource "aws_elasticache_subnet_group" "this" {
  name       = var.db.name
  subnet_ids = module.vpc.private_subnets
}

resource "aws_elasticache_replication_group" "this" {
  replication_group_id       = var.db.name
  description                = var.db.name
  engine                     = "redis"
  engine_version             = "6.x"
  node_type                  = "cache.t4g.micro"
  num_cache_clusters         = 1
  parameter_group_name       = "default.redis6.x"
  port                       = 6379
  automatic_failover_enabled = false
  security_group_ids         = [aws_security_group.allow_elasicache.id]
  subnet_group_name          = aws_elasticache_subnet_group.this.name
  apply_immediately = true
}