There is a deprecation related to your environment variables. Please take the recommended actions to update your configuration:
summary-mail-report-workflow-n8n-1 | - N8N_RUNNERS_ENABLED -> Remove this environment variable; it is no longer needed.
summary-mail-report-workflow-n8n-1 |
summary-mail-report-workflow-n8n-1 | [license SDK] Skipping renewal on init: license cert is not initialized
summary-mail-report-workflow-n8n-1 | Version: 2.9.2
summary-mail-report-workflow-n8n-1 | Building workflow dependency index...
summary-mail-report-workflow-n8n-1 | Finished building workflow dependency index. Processed 0 draft workflows, 0 published workflows.
Task request timed out after 60 seconds
Your Code node task was not matched to a runner within the timeout period. This indicates that the task runner is currently down, or not ready, or at capacity, so it cannot service your task.

If you are repeatedly executing Code nodes with long-running tasks across your instance, please space them apart to give the runner time to catch up. If this does not describe your use case, please open a GitHub issue or reach out to support.

If needed, you can increase the timeout using the N8N_RUNNERS_TASK_REQUEST_TIMEOUT environment variable.
