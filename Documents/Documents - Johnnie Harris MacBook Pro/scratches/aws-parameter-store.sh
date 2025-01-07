aws ssm get-parameters-by-path --path "/" --recursive --query="Parameters[*].[Name, Value]" --output json
