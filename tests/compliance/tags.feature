
Feature: Tags
  Scenario Outline: Ensure that specific tags are defined
  Given I have resource that supports tags defined
  When it has tags
  Then it must contain <tags>
  And its value must match the "<value>" regex

  Examples:
   | tags        | value              |
   | Name        | .+                 |
   | Project     | .+                 |
   | Terraform   | true               |
   | Environment | ^(dev\|prod\|stg\|demo\|training-*)$ |
