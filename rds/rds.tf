resource "aws_db_instance" "default" {
  allocated_storage   = 10
  db_name             = "mydb"
  engine              = "postgres"
  engine_version      = "12.8"
  instance_class      = "db.t3.micro"
  username            = "postgres"
  password            = "pulumiproblems"
  publicly_accessible = true
  skip_final_snapshot = true 
}


# resource "postgresql_role" "my_role" {
#   name     = "microservices"
# }

resource "aws_rds_cluster" "postgresql" {
  cluster_identifier      = "aurora-cluster-demo"
  engine                  = "aurora-postgresql"
  availability_zones      = ["us-west-2a", "us-west-2b", "us-west-2c"]
  database_name           = "mydb"
  master_username         = "foo"
  master_password         = "bar"
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
}