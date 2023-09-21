output "base_url_rest" {
  value = "${aws_api_gateway_deployment.example.invoke_url}"
}