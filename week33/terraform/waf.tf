resource "aws_wafv2_web_acl" "waf" {
  name  = "week33_waf"
  scope = "REGIONAL"
  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true  # wheter the resource sends metrics to cloudwatch
    metric_name                = "waf" # name of the cloudwatch metric
    sampled_requests_enabled   = true  # store samplings of requests that match the rules
  }

  # Prevent Terraform from managing inline rules -- prevents terraform from trying to overwrite rules managed externally to avoid state drift
  lifecycle {
    ignore_changes = [rule]
  }
}

resource "aws_wafv2_web_acl_rule" "common_rule" {
  name        = "AWSCommonRules"
  web_acl_arn = aws_wafv2_web_acl.waf.arn
  priority    = 1
  override_action {
    none {}
  }

  statement {
    managed_rule_group_statement {
      name        = "AWSManagedRulesCommonRuleSet"
      vendor_name = "AWS"
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "commonRules"
    sampled_requests_enabled   = true
  }
}

# attach waf to api gateway
resource "aws_wafv2_web_acl_association" "api_waf_association" {
  resource_arn = aws_api_gateway_stage.prod.arn # associate with the stage not the gw because security requirements may differ between stages
  web_acl_arn  = aws_wafv2_web_acl.waf.arn
}
