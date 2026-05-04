# General Notes

- Can a WAF be associated with multiple resources? Yes

## Run multiple requests

`for i in {1..150}; do curl -s https://<api-id>.execute-api.<region>.amazonaws.com/prod/node; done`

## WAF Rules

- How does WAF evaluate rules?
  - it evaluates them in priority order and will stop when it hits a termination action (block, allow, captcha, challenge)
  - I'll apply my custom rules before having the common rule set run
- for geo rules the following will allow you to block countries that aren't the us or canada

```
  statement {
    not_statement {
      statement {
        geo_match_statement {
          country_codes = ["US", "CA"]
        }
      }
    }
  }
```

- the following would allow matching the rule based on the uri path

```
  statement {
    and_statement {
      statement {
        geo_match_statement {
          country_codes = ["CN"]
        }
      }

      statement {
        byte_match_statement {
          search_string         = "admin"
          positional_constraint = "CONTAINS"

          field_to_match {
            uri_path {}
          }

          text_transformation {
            priority = 0
            type     = "LOWERCASE"
          }
        }
      }
    }
  }
```

# Troubleshooting

- How can I view allowed reqeusts in the console?
  - On the dashboard for your WAF, click the Sampled requests view

# Resources

https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_rule#rate-based-statement

https://docs.aws.amazon.com/waf/latest/APIReference/API_GeoMatchStatement.html -- country codes

https://docs.aws.amazon.com/waf/latest/APIReference/API_RateBasedStatement.html

https://repost.aws/knowledge-center/waf-turn-on-logging -- waf log groups must start with aws-waf-logs

https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-bot.html
https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-baseline.html
