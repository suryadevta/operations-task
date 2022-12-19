# ECS task IAM role
resource "aws_iam_role" "ecs_task_exe_role" {
  name = "operations-task-ecs-task-exe-role-${terraform.workspace}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name = "operations-task-ecs-task-exe-role-${terraform.workspace}"
    Environment = terraform.workspace
  }
}

resource "aws_iam_role_policy_attachment" "ecs_role_exe_role_policy_attach" {
  role       = aws_iam_role.ecs_task_exe_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_caller_identity" "current" {}

resource "aws_iam_policy" "ecs_task_exe_policy" {
  name = "operations-task-ecs-task-exe-policy-${terraform.workspace}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": [
            "ssm:DescribeParameters"
        ],
        "Resource": "*"
    },
    {
        "Sid": "Stmt1482841904000",
        "Effect": "Allow",
        "Action": [
            "ssm:GetParameters"
        ],
        "Resource": [
            "*"
        ]
    },
    {
        "Sid": "Stmt1482841948000",
        "Effect": "Allow",
        "Action": [
            "kms:Decrypt"
        ],
        "Resource": [
            "arn:aws:kms:${var.aws_region}:${data.aws_caller_identity.current.account_id}:key/7c9fc468-9c31-4c48-a12c-3108cb910f1d"
        ]
    }
  ]
 }

EOF
}

resource "aws_iam_role_policy_attachment" "ecs_role_exe_policy_attachment" {
  role       = aws_iam_role.ecs_task_exe_role.name
  policy_arn = aws_iam_policy.ecs_task_exe_policy.arn
}

resource "aws_iam_role" "ecs_task_def_role" {
  name = "operations-task-ecs-task-def-role-${terraform.workspace}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name = "operations-task-ecs-task-def-role-${terraform.workspace}"
    Environment = terraform.workspace
  }
}

resource "aws_iam_policy" "ecs_task_def_policy" {
  name = "operations-task-ecs-task-def-policy-${terraform.workspace}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "iam:PassRole",
                "codebuild:StartBuild",
                "route53:ChangeResourceRecordSets",
                "s3:ListBucket",
                "servicediscovery:CreateService"
            ],
            "Resource": [
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/operations-task-ecs-task-exe-role-${terraform.workspace}",
                "arn:aws:s3:::skye-training-assets/*",
                "arn:aws:s3:::skye-assistant-settings/*",
                "arn:aws:codebuild:${var.aws_region}:${data.aws_caller_identity.current.account_id}:project/operations-task-model-builder",
                "arn:aws:route53:::hostedzone/Z0389738ENTLFJHYSC6K",
                "arn:aws:servicediscovery:${var.aws_region}:${data.aws_caller_identity.current.account_id}:namespace/ns-pp3z6ils6lftytph",
                "arn:aws:iam::642801335081:role/aws-service-role/ecs.application-autoscaling.amazonaws.com/AWSServiceRoleForApplicationAutoScaling_ECSService"
            ]
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:PutObjectAcl"
            ],
            "Resource": [
                "arn:aws:s3:::skye-training-assets/*",
                "arn:aws:s3:::skye-assistant-settings/*"
            ]
        },
        {
            "Sid": "VisualEditor2",
            "Effect": "Allow",
            "Action": [
                "ses:SendEmail",
                "ecs:UpdateService",
                "ecs:CreateService",
                "ecs:RegisterTaskDefinition",
                "ses:SendRawEmail",
                "elasticloadbalancing:CreateTargetGroup",
                "elasticloadbalancing:CreateRule",
                "elasticloadbalancing:DescribeRules"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor3",
            "Effect": "Allow",
            "Action": "s3:Get*",
            "Resource": [
                "arn:aws:s3:::skye-training-assets/*",
                "arn:aws:s3:::skye-assistant-settings/*"
            ]
        }
    ]
}

EOF
}

resource "aws_iam_role_policy_attachment" "ecs_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_def_role.name
  policy_arn = aws_iam_policy.ecs_task_def_policy.arn
}

# --------------------- ECS Services ----------------------------------------------
# ECS services IAM role
resource "aws_iam_role" "ecs_service_role" {
  name = "operations-task-ecs-service-role-${terraform.workspace}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name = "operations-task-ecs-service-role-${terraform.workspace}"
    Environment = terraform.workspace
  }
}

resource "aws_iam_role_policy" "ecs_service_role_policy" {
  name = "operations-task-ecs-service-role-policy-${terraform.workspace}"
  role = aws_iam_role.ecs_service_role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ECSTaskManagement",
            "Effect": "Allow",
            "Action": [
                "ec2:AttachNetworkInterface",
                "ec2:CreateNetworkInterface",
                "ec2:CreateNetworkInterfacePermission",
                "ec2:DeleteNetworkInterface",
                "ec2:DeleteNetworkInterfacePermission",
                "ec2:Describe*",
                "ec2:DetachNetworkInterface",
                "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
                "elasticloadbalancing:DeregisterTargets",
                "elasticloadbalancing:Describe*",
                "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
                "elasticloadbalancing:RegisterTargets",
                "route53:ChangeResourceRecordSets",
                "route53:CreateHealthCheck",
                "route53:DeleteHealthCheck",
                "route53:Get*",
                "route53:List*",
                "route53:UpdateHealthCheck",
                "servicediscovery:DeregisterInstance",
                "servicediscovery:Get*",
                "servicediscovery:List*",
                "servicediscovery:RegisterInstance",
                "servicediscovery:UpdateInstanceCustomHealthStatus"
            ],
            "Resource": "*"
        },
        {
            "Sid": "ECSTagging",
            "Effect": "Allow",
            "Action": [
                "ec2:CreateTags"
            ],
            "Resource": "arn:aws:ec2:*:*:network-interface/*"
        },
        {
            "Sid": "CWLogGroupManagement",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:DescribeLogGroups",
                "logs:PutRetentionPolicy"
            ],
            "Resource": "arn:aws:logs:*:*:log-group:/aws/ecs/*"
        },
        {
            "Sid": "CWLogStreamManagement",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:log-group:/aws/ecs/*:log-stream:*"
        }
    ]
}
   EOF
}