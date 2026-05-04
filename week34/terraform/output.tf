output "python_sample_url" {
  value = "${aws_api_gateway_stage.prod.invoke_url}/python?name=Python_Daniel"
}
output "node_sample_url" {
  value = "${aws_api_gateway_stage.prod.invoke_url}/node?name=Node_Daniel"
}

output "api_url" {
  value = aws_api_gateway_stage.prod.invoke_url
}
