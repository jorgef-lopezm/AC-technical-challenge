[
    {
        "name": "app",
        "image": "${app_image}",
        "essential": true,
        "memoryReservation": 512,
        "environment": [
            {"name": "DB_HOST", "value": "${db_host}"},
            {"name": "DB_PORT", "value": "${db_port}"},
            {"name": "DB_NAME", "value": "${db_name}"},
            {"name": "DB_USER", "value": "${db_user}"},
            {"name": "DB_PASSWORD", "value": "${db_pass}"},
            {"name": "ALLOWED_HOSTS", "value": "${allowed_hosts}"}
        ],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "${log_group_name}",
                "awslogs-region": "${log_group_region}",
                "awslogs-stream-prefix": "app"
            }
        },
        "portMappings": [
            {
                "protocol": "tcp",
                "containerPort": 80,
                "hostPort": 80
            }
        ]
    }
]
