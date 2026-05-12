

```toml
# ─── Global defaults ──────────────────────────────────────────────────────────
# All of these can be overridden per-account.
# Values can be plain text, env vars, or op:// references.

default_account  = "dev"
default_role     = "primary"
sso_start_url    = "https://yourorg.awsapps.com/start"
sso_region       = "eu-west-1"
region           = "eu-west-1"
output           = "json"

credentials_path = "~/.aws/credentials"
config_path      = "~/.aws/config"

# ─── Secret resolution ────────────────────────────────────────────────────────

[secrets]
provider = "op"          # "op" | "env" | "plain"
cache_ttl_minutes = 60   # re-fetch from op after this, 0 = no cache so no cache = true needed.

# ─── Role tiers ───────────────────────────────────────────────────────────────
# Role name only — ARN is constructed as:
# arn:aws:iam::{account_id}:role/{role_name}

[roles]
poweruser   = "${AWS_POWERUSER_ROLE}" # PowerUserPermission
admin     = "${AWS_ADMIN_ROLE}" # AdminPermission
read      = "${AWS_READ_ROLE}" # ReadOnlyPermission
emergency = "${AWS_BREAKGLASS_ROLE}" # BreakGlassPermission

# ─── Accounts ─────────────────────────────────────────────────────────────────
# Each account inherits global defaults, overrides what it needs.
# "tier" controls which role from [roles] is the default for this account.

[[accounts]]
name       = "dev"
aliases    = ["d"]            # awsy account d  works too
account_id = "${AWS_DEV_ACCOUNT_ID}"   # env var works too
default_role = "admin"   # overrides global default_role for this account
roles = {   # overrides global default_role for this account
  admin = "${AWS_WORKLOAD_ROLE}",   # WorkloadOperator (Overrides global admin role for this account)
  read   = "${AWS_DIAGNOSTIC_ROLE}",  # DiagnosticReporter (Overrides global read role for this account)
  emergency
}

[[accounts]]
name       = "sandbox"
account_id = "op://Private/AWS/sandbox_account_id"
tier       = "primary"
aliases    = ["sb"]

[[accounts]]
name       = "test"
account_id = "op://Private/AWS/test_account_id"
tier       = "primary"
aliases    = ["t"]

[[accounts]]
name       = "prod"
account_id = "op://Private/AWS/prod_account_id"
tier       = "primary"        # default tier when switching here
aliases    = ["p"]
# prod restricts which role tiers are allowed
allowed_roles = ["primary", "read", "emergency"]   # no "admin" here

[[accounts]]
name       = "mgmt"
account_id = "op://Private/AWS/mgmt_account_id"
tier       = "primary"
aliases    = ["m", "mgmt"]
region     = "us-east-1"     # account-level override of global region
```
