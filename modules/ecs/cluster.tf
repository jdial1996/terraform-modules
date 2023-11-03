resource "aws_ecs_cluster" "ecs_cluster" {
    name = var.cluster_name

    # configuration {
    #     execute_command_configuration {
    #         logging = "OVERRIDE"
        

    #     log_configuration {
    #         cloud_watch_encryption_enabled = true 
    #         cloud_watch_log_group_name = aws_cloudwatch_log_group.ecs_cluster_log_group.name
    #     }
    #     }
    # }
    }

# resource "aws_cloudwatch_log_group" "ecs_cluster_log_group" {
#   name = "${var.cluster_name}-log-group"

# }

resource "aws_ecs_cluster_capacity_providers" "example" {
  cluster_name = aws_ecs_cluster.ecs_cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

data "aws_iam_policy_document" "ecs_task_execution_assume_role_policy_doc" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution_assume_role" {
  name               = "test-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_assume_role_policy_doc.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"]
}