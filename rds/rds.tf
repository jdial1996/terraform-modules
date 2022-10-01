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


resource "postgresql_role" "my_role" {
  name     = "microservices"
}