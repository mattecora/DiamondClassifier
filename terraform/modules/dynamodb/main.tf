resource "aws_dynamodb_table" "diamonds_predictions_table" {
    name           = "diamonds-predictions"
    billing_mode   = "PROVISIONED"
    read_capacity  = 5
    write_capacity = 5
    hash_key       = "id"

    attribute {
        name = "id"
        type = "S"
    }
}