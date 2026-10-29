# Rate limit observed

CloudFront returned `403` with `bb-rsn: rl-m` after a burst of bounded requests to the launch route. Backing off and limiting to minimal, spaced requests. This is an operational rate limit, not a vulnerability.
